import 'package:flutter/material.dart';
import 'team_screen.dart';
import '../services/supabase_service.dart';

// Per-employee feedback log — every feedback entry for one person,
// sorted newest first. Includes a quarter filter, a trend block matching
// the dashboard's heatmap, and an Add / Edit / Delete flow.
class EmployeeFeedbackLogScreen extends StatefulWidget {
  final String employeeName;
  const EmployeeFeedbackLogScreen({Key? key, required this.employeeName})
      : super(key: key);

  static const teal = Color(0xFF0E7C7B);

  // ─── App-wide feedback notifier ──
  // Any screen that mutates feedback bumps this; the Dashboard listens
  // and rebuilds, so its rolled-up numbers always match the latest edits.
  static final ValueNotifier<int> feedbackVersion = ValueNotifier<int>(0);
  // Per-employee local overrides — writes from this screen land here so
  // the static logFor() returns the edited list to every other screen too.
  static final Map<String, List<Map<String, dynamic>>> _overrides = {};

  static void _publishOverride(
      String employeeName, List<Map<String, dynamic>> entries) {
    _overrides[employeeName] = entries
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    feedbackVersion.value++;
  }

  // One-shot hydration on app start: pull all feedbacks from Supabase and
  // merge into the deterministic baseline so dashboard/team see cross-device
  // data without the user having to open each employee's log first.
  static Future<void> hydrateAllFromSupabase() async {
    try {
      final all = await SupabaseService().getFeedbacks();
      if (all.isEmpty) return;
      final byEmployee = <String, List<Map<String, dynamic>>>{};
      for (final f in all) {
        byEmployee.putIfAbsent(f.employeeName, () => []);
        byEmployee[f.employeeName]!.add({
          'id': f.id,
          'type': f.feedbackType,
          'comment': f.comment,
          'date': f.createdAt ?? DateTime.now(),
          'rating': f.rating ?? 3.0,
          '_supabase': true,
        });
      }
      byEmployee.forEach((name, cloud) {
        final baseline = _generateLogFor(name);
        final merged = [...baseline, ...cloud]
          ..sort((a, b) =>
              (b['date'] as DateTime).compareTo(a['date'] as DateTime));
        _overrides[name] = merged;
      });
      feedbackVersion.value++;
      print('✅ Hydrated ${all.length} Supabase feedbacks');
    } catch (e) {
      print('⚠️ Supabase hydration failed: $e');
    }
  }

  // Employees marked with `noFeedback: true` in the roster get an empty
  // history — useful for "fresh hire" demo scenarios.
  static bool _isNoFeedback(String name) {
    try {
      final entry = TeamScreen.roster.firstWhere((e) => e['name'] == name);
      return entry['noFeedback'] == true;
    } catch (_) {
      return false;
    }
  }

  // ─── Static helpers used by Team screen + Dashboard (kept stable) ──
  static List<Map<String, dynamic>> logFor(String employeeName) {
    if (_overrides.containsKey(employeeName)) {
      return _overrides[employeeName]!
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return _generateLogFor(employeeName);
  }

  static List<Map<String, dynamic>> _generateLogFor(String employeeName) {
    // Fresh hires / new roles have no history yet.
    if (_isNoFeedback(employeeName)) return [];
    final seed = employeeName.hashCode.abs();
    const positives = [
      'Strong clinical judgment and clear patient communication.',
      'Excellent teamwork during the night shift rotation.',
      'Handled a difficult family conversation with real empathy.',
      'Proactively flagged a safety risk before it escalated.',
      'Consistently thorough documentation this cycle.',
    ];
    const constructives = [
      'Documentation was late on two handovers — tighten turnaround.',
      'Consider delegating more during peak load.',
      'Follow up on the pending compliance training module.',
      'Presentation could be more structured next time.',
    ];
    final entries = <Map<String, dynamic>>[];
    final count = 4 + (seed % 3);
    var day = DateTime(2026, 6, 8, 9 + (seed % 8), (seed % 60));
    for (var i = 0; i < count; i++) {
      final isPos = ((seed >> i) & 1) == 0;
      final list = isPos ? positives : constructives;
      // Ratings are HALF-STAR steps (1.0, 1.5, 2.0, ... 5.0) — sane discrete
      // values, no fake 3.27 precision but allows nuance.
      final halfSteps = isPos
          ? 7 + ((seed + i * 7) % 4) // 3.5, 4.0, 4.5, 5.0
          : 2 + ((seed + i * 11) % 5); // 1.0, 1.5, 2.0, 2.5, 3.0
      final r = halfSteps / 2.0;
      entries.add({
        'id': '${employeeName.hashCode}-$i',
        'type': isPos ? 'Positive' : 'Constructive',
        'comment': list[(seed + i) % list.length],
        'date': day,
        'rating': r,
      });
      day = day.subtract(Duration(days: 12 + ((seed + i) % 20)));
    }
    entries.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return entries;
  }

  static double? averageRating(String employeeName) {
    final l = logFor(employeeName);
    if (l.isEmpty) return null;
    final sum = l.fold<double>(0, (a, e) => a + (e['rating'] as double));
    return double.parse((sum / l.length).toStringAsFixed(1));
  }

  @override
  State<EmployeeFeedbackLogScreen> createState() =>
      _EmployeeFeedbackLogScreenState();
}

class _EmployeeFeedbackLogScreenState extends State<EmployeeFeedbackLogScreen> {
  final _supabase = SupabaseService();

  static const List<String> _mon = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // Mirror the dashboard "today" so quarters stay stable.
  static final DateTime _today = DateTime(2026, 6, 10);

  // Same warm orange → yellow → green palette as the dashboard.
  static const List<Color> _heatColors = [
    Color(0xFFE89A6B),
    Color(0xFFEBB57A),
    Color(0xFFE0C04A),
    Color(0xFFA8C977),
    Color(0xFF3DA66E),
  ];

  String _filter = 'This Q'; // This Q | Last Q | All
  late List<Map<String, dynamic>> _entries;

  @override
  void initState() {
    super.initState();
    _entries = EmployeeFeedbackLogScreen.logFor(widget.employeeName)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  DateTimeRange get _thisQ {
    final qStartMonth = ((_today.month - 1) ~/ 3) * 3 + 1;
    return DateTimeRange(
      start: DateTime(_today.year, qStartMonth, 1),
      end: DateTime(_today.year, qStartMonth + 3, 1)
          .subtract(const Duration(days: 1)),
    );
  }

  DateTimeRange get _lastQ {
    final qStartMonth = ((_today.month - 1) ~/ 3) * 3 + 1;
    return DateTimeRange(
      start: DateTime(_today.year, qStartMonth - 3, 1),
      end: DateTime(_today.year, qStartMonth, 1)
          .subtract(const Duration(days: 1)),
    );
  }

  String _qLabel(DateTime d) {
    final q = ((d.month - 1) ~/ 3) + 1;
    return 'Q$q ${d.year.toString().substring(2)}';
  }

  List<Map<String, dynamic>> get _filteredEntries {
    DateTimeRange? r;
    if (_filter == 'This Q') r = _thisQ;
    if (_filter == 'Last Q') r = _lastQ;
    if (r == null) return _entries;
    return _entries.where((e) {
      final d = e['date'] as DateTime;
      return !d.isBefore(r!.start) && d.isBefore(r.end.add(const Duration(days: 1)));
    }).toList();
  }

  double? _avgForRange(DateTimeRange r) {
    final scope = _entries.where((e) {
      final d = e['date'] as DateTime;
      return !d.isBefore(r.start) && d.isBefore(r.end.add(const Duration(days: 1)));
    }).toList();
    if (scope.isEmpty) return null;
    final sum = scope.fold<double>(0, (a, e) => a + (e['rating'] as double));
    return double.parse((sum / scope.length).toStringAsFixed(1));
  }

  int _zoneIndex(double r) {
    if (r >= 4.5) return 4;
    if (r >= 3.5) return 3;
    if (r >= 3.0) return 2;
    if (r >= 2.5) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Use the SELECTED period for the headline rating + badge.
    // Falls back to thisQ when 'All' is selected.
    final selectedRange = _filter == 'Last Q' ? _lastQ : _thisQ;
    final thisQAvg = _filter == 'All'
        ? EmployeeFeedbackLogScreen.averageRating(widget.employeeName)
        : _avgForRange(selectedRange);
    final lastQAvg = _avgForRange(_lastQ);
    final overallAvg =
        EmployeeFeedbackLogScreen.averageRating(widget.employeeName);
    final filtered = _filteredEntries;
    final initials = widget.employeeName
        .split(' ')
        .map((p) => p.isEmpty ? '' : p[0])
        .join()
        .toUpperCase();

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Feedback log',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text(widget.employeeName,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        icon: const Icon(Icons.add_comment_rounded),
        label: const Text('New feedback',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          // ── Quarter filter chips at the very top (matches dashboard layout) ──
          Row(
            children: [
              _filterChip(scheme, 'This Q', _qLabel(_thisQ.start)),
              const SizedBox(width: 6),
              _filterChip(scheme, 'Last Q', _qLabel(_lastQ.start)),
              const SizedBox(width: 6),
              _filterChip(scheme, 'All', 'all'),
            ],
          ),
          const SizedBox(height: 14),
          // ── Hero with employee + total avg + trend bar ──
          _heroCard(scheme, initials, overallAvg, thisQAvg, lastQAvg, filtered),
          const SizedBox(height: 14),
          // ── Section title ──
          Row(
            children: [
              Text('TIMELINE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 0.8)),
              const Spacer(),
              Text('${filtered.length} entries',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 10),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text('No feedback in this period',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
              ),
            )
          else
            ...filtered.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _entryCard(e, scheme),
                )),
        ],
      ),
    );
  }

  // ─── Hero with rating + trend ──
  Widget _heroCard(
      ColorScheme scheme,
      String initials,
      double? overallAvg,
      double? thisQAvg,
      double? lastQAvg,
      List<Map<String, dynamic>> visible) {
    final hasTrend = thisQAvg != null && lastQAvg != null;
    final delta = hasTrend ? thisQAvg - lastQAvg : 0.0;
    final trendUp = delta >= 0;
    final trendColor = trendUp
        ? const Color(0xFF5BB880)
        : const Color(0xFFE6B43A);
    final pulseForBar = thisQAvg ?? lastQAvg ?? 3.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: scheme.surfaceContainerLow,
        border: Border(top: BorderSide(color: scheme.primary, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Identity row
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: scheme.primary,
                child: Text(initials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.employeeName,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: scheme.onSurface)),
                    Text('Career feedback timeline',
                        style: TextStyle(
                            fontSize: 11,
                            color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                  _filter == 'All'
                      ? 'All time'
                      : _qLabel((_filter == 'Last Q' ? _lastQ : _thisQ).start),
                  style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700)),
              const Spacer(),
              if (lastQAvg != null)
                Text('vs ${_qLabel(_lastQ.start)} · ${lastQAvg.toStringAsFixed(1)}',
                    style: TextStyle(
                        fontSize: 10,
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          // Right-aligned ticker — matches the dashboard layout
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(thisQAvg?.toStringAsFixed(1) ?? '—',
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      color: scheme.onSurface)),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('/ 5.0',
                    style: TextStyle(
                        fontSize: 14,
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              if (hasTrend)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                          trendUp
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          size: 16,
                          color: trendColor),
                      const SizedBox(width: 2),
                      Text(delta.abs().toStringAsFixed(2),
                          style: TextStyle(
                              color: trendColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('—',
                      style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Heatmap bar — triangle marker only shows if there's feedback this period
          Builder(builder: (_) {
            final avg = thisQAvg;
            if (avg == null) return const SizedBox.shrink();
            return LayoutBuilder(builder: (ctx, c) {
              final frac = ((avg - 1.0) / 4.0).clamp(0.0, 1.0);
              const markerW = 12.0;
              final left = (frac * c.maxWidth - markerW / 2)
                  .clamp(0.0, c.maxWidth - markerW);
              return SizedBox(
                height: 10,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: left,
                      bottom: 0,
                      child: CustomPaint(
                        size: const Size(markerW, 8),
                        painter: _MiniTri(color: scheme.onSurface),
                      ),
                    ),
                  ],
                ),
              );
            });
          }),
          Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: thisQAvg == null
                    ? _heatColors.map((c) => c.withOpacity(0.3)).toList()
                    : _heatColors,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('At-risk',
                  style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 9,
                      fontWeight: FontWeight.w700)),
              Text('Excellent',
                  style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 9,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(ColorScheme scheme, String value, String label) {
    final selected = _filter == value;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _filter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: selected ? scheme.onPrimary : scheme.onSurface)),
            if (label != 'all' && label != value) ...[
              const SizedBox(width: 5),
              Text('· $label',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? scheme.onPrimary.withOpacity(0.75)
                          : scheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _entryCard(Map<String, dynamic> e, ColorScheme scheme) {
    final isPositive = e['type'] == 'Positive';
    final accentBg = isPositive ? scheme.secondaryContainer : scheme.errorContainer;
    final accentFg = isPositive ? scheme.onSecondaryContainer : scheme.onErrorContainer;
    final d = e['date'] as DateTime;
    final when =
        '${_mon[d.month]} ${d.day}, ${d.year} · ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    final qTag = _qLabel(d);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: rating shown as colored number (no "Positive"/"Constructive"
              // word — the color tells the story)
              // Render the rating as 5 little stars (filled/half/empty).
              // Filled portions use the zone color so 2 stars in orange
              // reads at-risk, 4 stars in green reads healthy. Empty
              // outlines stay neutral grey so the "unfilled" portion is
              // visually quiet.
              Builder(builder: (_) {
                final r = e['rating'] as double;
                final zone = _zoneIndex(r);
                final filledColor = _heatColors[zone];
                final emptyColor = Colors.grey.shade400;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) {
                    final position = i + 1;
                    IconData icon;
                    Color c;
                    if (r >= position) {
                      icon = Icons.star_rounded;
                      c = filledColor;
                    } else if (r >= position - 0.5) {
                      icon = Icons.star_half_rounded;
                      c = filledColor;
                    } else {
                      icon = Icons.star_outline_rounded;
                      c = emptyColor;
                    }
                    return Icon(icon, size: 16, color: c);
                  }),
                );
              }),
              const Spacer(),
              // Right: date on top, quarter tag below — vertical stack, clean
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(when,
                      style: TextStyle(
                          fontSize: 10, color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 2),
                  Text(qTag,
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(e['comment'],
              style: TextStyle(
                  fontSize: 13.5, color: scheme.onSurface, height: 1.4)),
          const SizedBox(height: 10),
          // Inline action row — explicit edit + delete (no hidden menu)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _showAddEditDialog(existing: e),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_rounded,
                          size: 14, color: scheme.primary),
                      const SizedBox(width: 4),
                      Text('Edit',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: scheme.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _confirmDelete(e),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.delete_outline_rounded,
                          size: 14, color: Color(0xFFD64545)),
                      const SizedBox(width: 4),
                      Text('Delete',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFD64545))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Add / Edit dialog ──
  void _showAddEditDialog({Map<String, dynamic>? existing}) {
    final isEdit = existing != null;
    final commentC = TextEditingController(text: existing?['comment'] ?? '');
    // Stored as half-steps (1..10 → 0.5..5.0)
    int halfSteps =
        (((existing?['rating'] as double?) ?? 4.0) * 2).round().clamp(1, 10);
    // Type is derived from the rating: ≥3.5 = Positive, <3.5 = Constructive.
    String typeFromRating(int hs) => (hs / 2.0) >= 3.5 ? 'Positive' : 'Constructive';
    DateTime date = existing?['date'] ?? _today;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(isEdit ? 'Edit feedback' : 'New feedback'),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comment field with AI polish button inline at the top-right
                Stack(
                  children: [
                    TextField(
                      controller: commentC,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Comment',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 40, 12),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: IconButton(
                        tooltip: 'AI polish',
                        icon: const Icon(Icons.auto_awesome_rounded,
                            size: 18, color: Color(0xFF7E57C2)),
                        onPressed: () {
                          // Lightweight word-boundary polish (no LLM call)
                          final original = commentC.text;
                          if (original.trim().isEmpty) return;
                          final polished = _polishComment(original);
                          commentC.text = polished;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Comment polished'),
                                duration: Duration(seconds: 1)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Rating',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text((halfSteps / 2.0).toStringAsFixed(1),
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: _heatColors[_zoneIndex(halfSteps / 2.0)])),
                  ],
                ),
                const SizedBox(height: 8),
                // Half-star picker: each star = two tap zones (left half, full)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final leftHalfValue = i * 2 + 1; // 1, 3, 5, 7, 9
                    final fullValue = i * 2 + 2; // 2, 4, 6, 8, 10
                    IconData icon;
                    if (halfSteps >= fullValue) {
                      icon = Icons.star_rounded;
                    } else if (halfSteps >= leftHalfValue) {
                      icon = Icons.star_half_rounded;
                    } else {
                      icon = Icons.star_outline_rounded;
                    }
                    final filled = halfSteps >= leftHalfValue;
                    final zoneColor = _heatColors[_zoneIndex(halfSteps / 2.0)];
                    return SizedBox(
                      width: 48,
                      height: 48,
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              icon,
                              size: 40,
                              color: filled ? zoneColor : Colors.grey.shade400,
                            ),
                          ),
                          // Left-half tap zone → set to half (i*2 + 1)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: 24,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () =>
                                  setS(() => halfSteps = leftHalfValue),
                            ),
                          ),
                          // Right-half tap zone → set to full (i*2 + 2)
                          Positioned(
                            left: 24,
                            top: 0,
                            bottom: 0,
                            width: 24,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => setS(() => halfSteps = fullValue),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: date,
                      firstDate: DateTime(2025, 1, 1),
                      lastDate: _today.add(const Duration(days: 365)),
                    );
                    if (picked != null) setS(() => date = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 16),
                        const SizedBox(width: 8),
                        Text('${_mon[date.month]} ${date.day}, ${date.year}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (commentC.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter a comment')));
                  return;
                }
                final newRating = halfSteps / 2.0;
                final derivedType = typeFromRating(halfSteps);
                final comment = commentC.text.trim();
                Navigator.pop(ctx);
                // Optimistic local update first, then sync with Supabase
                String entryId = existing?['id'] as String? ??
                    'pending-${DateTime.now().millisecondsSinceEpoch}';
                setState(() {
                  if (isEdit) {
                    final i = _entries.indexWhere((x) => x['id'] == existing['id']);
                    if (i >= 0) {
                      _entries[i] = {
                        ..._entries[i],
                        'type': derivedType,
                        'comment': comment,
                        'rating': newRating,
                        'date': date,
                      };
                    }
                  } else {
                    _entries.insert(0, {
                      'id': entryId,
                      'type': derivedType,
                      'comment': comment,
                      'rating': newRating,
                      'date': date,
                    });
                  }
                  _entries.sort((a, b) =>
                      (b['date'] as DateTime).compareTo(a['date'] as DateTime));
                });
                EmployeeFeedbackLogScreen._publishOverride(
                    widget.employeeName, _entries);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(isEdit ? 'Feedback updated' : 'Feedback added'),
                  backgroundColor: Colors.green,
                ));

                // Background Supabase sync — silent on failure so the demo
                // keeps moving even if RLS rejects the write.
                if (isEdit && existing['_supabase'] == true) {
                  _supabase.updateFeedback(
                    existing['id'].toString(),
                    feedbackType: derivedType,
                    comment: comment,
                    rating: newRating,
                    createdAt: date,
                  );
                } else if (!isEdit) {
                  () async {
                    final realId = await _supabase.submitFeedback(
                      widget.employeeName,
                      derivedType,
                      comment,
                      rating: newRating,
                      createdAt: date,
                    );
                    if (realId != null && mounted) {
                      setState(() {
                        final i = _entries.indexWhere((x) => x['id'] == entryId);
                        if (i >= 0) {
                          _entries[i]['id'] = realId;
                          _entries[i]['_supabase'] = true;
                        }
                      });
                      EmployeeFeedbackLogScreen._publishOverride(
                          widget.employeeName, _entries);
                    }
                  }();
                }
              },
              child: Text(isEdit ? 'Save' : 'Add'),
            ),
          ],
        );
      }),
    );
  }

  // Word-boundary cleanup — fixes common typos and softens harsh phrasing.
  // No LLM call (the OpenAI key path is the demo's biggest reliability risk).
  String _polishComment(String input) {
    const fixes = <String, String>{
      'recieve': 'receive', 'seperate': 'separate', 'definately': 'definitely',
      'tommorrow': 'tomorrow', 'occured': 'occurred', 'thier': 'their',
      'cant': "can't", 'dont': "don't", 'wont': "won't", 'isnt': "isn't",
      'youre': "you're", 'theyre': "they're", 'wouldnt': "wouldn't",
      'should of': 'should have', 'could of': 'could have',
      'alot': 'a lot', 'untill': 'until',
      'bad': 'below expectations',
      'lazy': 'less engaged than expected',
      'stupid': 'unclear in execution',
      'sucks': 'falls short',
      'horrible': 'needs significant improvement',
      'terrible': 'needs significant improvement',
    };
    var out = input.trim();
    fixes.forEach((bad, good) {
      out = out.replaceAllMapped(
        RegExp(r'\b' + RegExp.escape(bad) + r'\b', caseSensitive: false),
        (m) => good,
      );
    });
    // Capitalize first letter, ensure ending punctuation.
    if (out.isNotEmpty) out = out[0].toUpperCase() + out.substring(1);
    if (out.isNotEmpty && !RegExp(r'[.!?]$').hasMatch(out)) out += '.';
    return out;
  }

  void _confirmDelete(Map<String, dynamic> e) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this feedback?'),
        content: Text('"${e['comment']}" will be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _entries.removeWhere((x) => x['id'] == e['id']));
              EmployeeFeedbackLogScreen._publishOverride(
                  widget.employeeName, _entries);
              // Background Supabase delete only if this was a cloud-backed row
              if (e['_supabase'] == true) {
                _supabase.deleteFeedback(e['id'].toString());
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feedback deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _MiniTri extends CustomPainter {
  final Color color;
  _MiniTri({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, p);
  }
  @override
  bool shouldRepaint(covariant _MiniTri old) => old.color != color;
}
