import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'team_screen.dart';

// Heatmap analytics — flexible reporting across region / department / employee
// for any date range. Numbers reconcile with the rest of the app because they
// come from TeamScreen.rosterFeedback + avgRatingFor.
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

enum GroupBy { region, department, manager, employee }

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  static final DateTime _today = DateTime(2026, 6, 12);

  String _dateRange = 'This Q';
  DateTimeRange? _customRange;
  GroupBy _groupBy = GroupBy.region;
  String _regionFilter = 'All';
  String _deptFilter = 'All';
  String _search = '';

  // ── Date-range helpers ─────────────────────────────────────────────
  DateTimeRange get _activeRange {
    final qStartMonth = ((_today.month - 1) ~/ 3) * 3 + 1;
    final thisStart = DateTime(_today.year, qStartMonth, 1);
    final thisEnd = DateTime(_today.year, qStartMonth + 3, 1)
        .subtract(const Duration(days: 1));
    switch (_dateRange) {
      case 'Last Q':
        final lastStart = DateTime(_today.year, qStartMonth - 3, 1);
        return DateTimeRange(
            start: lastStart,
            end: thisStart.subtract(const Duration(days: 1)));
      case 'YTD':
        return DateTimeRange(
            start: DateTime(_today.year, 1, 1), end: _today);
      case 'All time':
        return DateTimeRange(
            start: DateTime(2020, 1, 1), end: _today);
      case 'Custom':
        return _customRange ?? DateTimeRange(start: thisStart, end: thisEnd);
      default:
        return DateTimeRange(start: thisStart, end: thisEnd);
    }
  }

  DateTimeRange get _previousRange {
    final r = _activeRange;
    final duration = r.end.difference(r.start);
    final prevEnd = r.start.subtract(const Duration(days: 1));
    return DateTimeRange(start: prevEnd.subtract(duration), end: prevEnd);
  }

  String get _rangeLabel {
    final r = _activeRange;
    String mon(int m) => const [
          '',
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ][m];
    return '${mon(r.start.month)} ${r.start.day} – '
        '${mon(r.end.month)} ${r.end.day}, ${r.end.year}';
  }

  // ── Filtered roster ────────────────────────────────────────────────
  List<Map<String, dynamic>> get _filteredRoster {
    return TeamScreen.roster.where((e) {
      if (_regionFilter != 'All' && e['region'] != _regionFilter) return false;
      if (_deptFilter != 'All' && e['department'] != _deptFilter) return false;
      if (_search.isNotEmpty &&
          !(e['name'] as String).toLowerCase().contains(_search.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  // Returns 4 quarterly avg ratings ending in (and including) the active range's quarter.
  // Each entry is null if there was no feedback in that quarter.
  List<double?> _trendSeries(List<String> names) {
    final out = <double?>[];
    final r = _activeRange;
    // Anchor the end quarter to the end of the active range
    final anchorMonth = ((r.end.month - 1) ~/ 3) * 3 + 1;
    var anchorYear = r.end.year;
    for (var i = 3; i >= 0; i--) {
      final qStartMonthIdx = anchorMonth - i * 3;
      var year = anchorYear;
      var month = qStartMonthIdx;
      while (month < 1) {
        month += 12;
        year -= 1;
      }
      final qStart = DateTime(year, month, 1);
      final qEnd =
          DateTime(year, month + 3, 1).subtract(const Duration(days: 1));
      final avg = TeamScreen.avgRatingFor(
          start: qStart,
          end: qEnd.add(const Duration(days: 1)),
          names: names);
      out.add(avg);
    }
    return out;
  }

  List<_HeatRow> get _heatRows {
    final roster = _filteredRoster;
    final r = _activeRange;
    final endExcl = r.end.add(const Duration(days: 1));

    final buckets = <String, List<String>>{};
    for (final emp in roster) {
      final name = emp['name'] as String;
      final key = switch (_groupBy) {
        GroupBy.region => emp['region'] as String? ?? 'Unassigned',
        GroupBy.department => emp['department'] as String? ?? 'Unassigned',
        GroupBy.manager =>
          (emp['manager'] as String?) ?? '— Top level —',
        GroupBy.employee => name,
      };
      buckets.putIfAbsent(key, () => []).add(name);
    }

    final rows = buckets.entries.map((entry) {
      final avg = TeamScreen.avgRatingFor(
          start: r.start, end: endExcl, names: entry.value);
      final count = TeamScreen.rosterFeedbackCount(
          start: r.start, end: endExcl, names: entry.value);
      final trend = _trendSeries(entry.value);
      return _HeatRow(
          label: entry.key,
          avg: avg,
          feedbackCount: count,
          peopleCount: entry.value.length,
          members: entry.value,
          trend: trend);
    }).toList()
      ..sort((a, b) {
        if (a.avg == null && b.avg == null) return 0;
        if (a.avg == null) return 1;
        if (b.avg == null) return -1;
        return b.avg!.compareTo(a.avg!);
      });
    return rows;
  }

  // ── UI helpers ─────────────────────────────────────────────────────
  static const List<Color> _heatColors = [
    Color(0xFFE89A6B),
    Color(0xFFEBB57A),
    Color(0xFFEBC575),
    Color(0xFFA8C788),
    Color(0xFF3DA66E),
  ];

  Color _heatColor(double? avg) {
    if (avg == null) return Colors.grey.shade400;
    if (avg >= 4.5) return _heatColors[4];
    if (avg >= 4.0) return _heatColors[3];
    if (avg >= 3.5) return _heatColors[2];
    if (avg >= 3.0) return _heatColors[1];
    return _heatColors[0];
  }

  int _zoneIndex(double? avg) {
    if (avg == null) return -1;
    if (avg >= 4.5) return 4;
    if (avg >= 4.0) return 3;
    if (avg >= 3.5) return 2;
    if (avg >= 3.0) return 1;
    return 0;
  }

  String _heatLabel(double? avg) {
    if (avg == null) return 'No data';
    if (avg >= 4.5) return 'Excellent';
    if (avg >= 4.0) return 'Healthy';
    if (avg >= 3.5) return 'Steady';
    if (avg >= 3.0) return 'Watch';
    return 'At-risk';
  }

  Future<void> _pickCustomRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2027, 12, 31),
      initialDateRange: _activeRange,
    );
    if (range != null) {
      setState(() {
        _customRange = range;
        _dateRange = 'Custom';
      });
    }
  }

  Future<void> _showShareSheet() async {
    final rows = _heatRows;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('Share report',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 16),
            _shareTile(Icons.format_align_left_rounded, 'Plain text',
                'Tab-aligned for Slack/email', () => _copy(_asText(rows))),
            _shareTile(Icons.code_rounded, 'Markdown',
                'For docs / GitHub / Notion', () => _copy(_asMarkdown(rows))),
            _shareTile(Icons.grid_on_rounded, 'CSV',
                'Spreadsheet-ready', () => _copy(_asCsv(rows))),
          ],
        ),
      ),
    );
  }

  Widget _shareTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: scheme.onPrimaryContainer, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface)),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 11,
                            color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 18, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  String _asText(List<_HeatRow> rows) {
    final buf = StringBuffer();
    buf.writeln('PERFORMANCE HEATMAP — ${_groupLabel(_groupBy).toUpperCase()}');
    buf.writeln('Range: $_rangeLabel');
    buf.writeln('');
    buf.writeln('GROUP                          AVG    ZONE        FEEDBACK  PEOPLE');
    for (final row in rows) {
      final label = row.label.padRight(30).substring(0, 30);
      final avg = (row.avg?.toStringAsFixed(1) ?? '—').padLeft(5);
      final zone = _heatLabel(row.avg).padRight(11);
      final fb = row.feedbackCount.toString().padLeft(8);
      final ppl = row.peopleCount.toString().padLeft(6);
      buf.writeln('$label $avg  $zone $fb  $ppl');
    }
    return buf.toString();
  }

  String _asMarkdown(List<_HeatRow> rows) {
    final buf = StringBuffer();
    buf.writeln('# Performance Heatmap — ${_groupLabel(_groupBy)}');
    buf.writeln('**Range:** $_rangeLabel  ');
    buf.writeln('');
    buf.writeln('| Group | Avg | Zone | Feedback | People |');
    buf.writeln('|---|---:|---|---:|---:|');
    for (final row in rows) {
      buf.writeln(
          '| ${row.label} | ${row.avg?.toStringAsFixed(1) ?? '—'} | ${_heatLabel(row.avg)} | ${row.feedbackCount} | ${row.peopleCount} |');
    }
    return buf.toString();
  }

  String _asCsv(List<_HeatRow> rows) {
    final buf = StringBuffer();
    buf.writeln('Group,Avg,Zone,Feedback,People');
    for (final row in rows) {
      buf.writeln(
          '"${row.label}",${row.avg?.toStringAsFixed(1) ?? ''},${_heatLabel(row.avg)},${row.feedbackCount},${row.peopleCount}');
    }
    return buf.toString();
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✓ Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── BUILD ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rows = _heatRows;
    final r = _activeRange;
    final endExcl = r.end.add(const Duration(days: 1));
    final allNames =
        _filteredRoster.map((e) => e['name'] as String).toList();
    final orgAvg =
        TeamScreen.avgRatingFor(start: r.start, end: endExcl, names: allNames);
    final totalFeedback = TeamScreen.rosterFeedbackCount(
        start: r.start, end: endExcl, names: allNames);
    final pr = _previousRange;
    final prevAvg = TeamScreen.avgRatingFor(
        start: pr.start,
        end: pr.end.add(const Duration(days: 1)),
        names: allNames);
    final hasTrend = orgAvg != null && prevAvg != null;
    final delta = hasTrend ? orgAvg - prevAvg : 0.0;
    final trendUp = delta >= 0;
    final trendColor =
        trendUp ? const Color(0xFF5BB880) : const Color(0xFFE6B43A);

    // Zone distribution: how many groups in each of 5 zones
    final zoneCounts = List.filled(5, 0);
    var noData = 0;
    for (final row in rows) {
      final z = _zoneIndex(row.avg);
      if (z >= 0) {
        zoneCounts[z]++;
      } else {
        noData++;
      }
    }

    final regions = <String>{
      'All',
      ...TeamScreen.roster.map((e) => (e['region'] as String?) ?? 'Unassigned'),
    }.toList();
    final depts = <String>{
      'All',
      ...TeamScreen.roster.map((e) => e['department'] as String),
    }.toList();

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        automaticallyImplyLeading: Navigator.of(context).canPop(),
        titleSpacing: Navigator.of(context).canPop() ? 0 : 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Analytics',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: scheme.onSurface)),
            Text('Performance heatmap',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            // ── HERO: Org pulse + delta + zone distribution ──
            _heroCard(scheme, orgAvg, totalFeedback, allNames.length,
                hasTrend, delta, trendUp, trendColor, zoneCounts, noData),
            const SizedBox(height: 22),

            // ── DATE RANGE ──
            _sectionLabel(scheme, 'DATE RANGE'),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 4),
              child: Row(
                children: [
                  for (final rr in ['This Q', 'Last Q', 'YTD', 'All time']) ...[
                    _chip(scheme, rr, _dateRange == rr,
                        () => setState(() => _dateRange = rr)),
                    const SizedBox(width: 6),
                  ],
                  _chip(
                      scheme,
                      _dateRange == 'Custom' && _customRange != null
                          ? '📅 Custom set'
                          : '📅 Custom…',
                      _dateRange == 'Custom',
                      _pickCustomRange),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 12, color: scheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(_rangeLabel,
                    style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 22),

            // ── GROUP BY ──
            _sectionLabel(scheme, 'GROUP BY'),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 4),
              child: Row(
                children: [
                  for (final g in GroupBy.values) ...[
                    _chip(
                      scheme,
                      _groupLabel(g),
                      _groupBy == g,
                      () => setState(() => _groupBy = g),
                    ),
                    const SizedBox(width: 6),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 22),

            // ── FILTERS ──
            _sectionLabel(scheme, 'FILTERS'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: _dropdown(scheme, 'Region', _regionFilter, regions,
                        (v) => setState(() => _regionFilter = v!))),
                const SizedBox(width: 10),
                Expanded(
                    child: _dropdown(scheme, 'Department', _deptFilter, depts,
                        (v) => setState(() => _deptFilter = v!))),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search by name…',
                prefixIcon: Icon(Icons.search_rounded,
                    size: 20, color: scheme.onSurfaceVariant),
                isDense: true,
                filled: true,
                fillColor: scheme.surfaceContainerLow,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 22),

            // ── HEATMAP ──
            Row(
              children: [
                _sectionLabel(scheme, 'HEATMAP'),
                const Spacer(),
                Text(
                    '${rows.length} group${rows.length == 1 ? '' : 's'} · ${allNames.length} people',
                    style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            if (rows.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inbox_rounded,
                          size: 32, color: scheme.onSurfaceVariant),
                      const SizedBox(height: 8),
                      Text('No data for these filters',
                          style: TextStyle(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              )
            else
              ...rows.map((row) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _heatTile(scheme, row),
                  )),
            const SizedBox(height: 18),
            _legendStrip(scheme),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _showShareSheet,
                icon: const Icon(Icons.ios_share_rounded, size: 18),
                label: const Text('Share report',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── REPORT ACTIONS GRID ──
  Widget _reportActions(ColorScheme scheme, List<_HeatRow> rows) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _actionCard(
                scheme,
                Icons.format_align_left_rounded,
                'Plain text',
                'Slack, email, chat',
                const Color(0xFF3F7DBE),
                () => _copy(_asText(rows)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionCard(
                scheme,
                Icons.code_rounded,
                'Markdown',
                'Notion, GitHub, docs',
                const Color(0xFF1D9E75),
                () => _copy(_asMarkdown(rows)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _actionCard(
                scheme,
                Icons.grid_on_rounded,
                'CSV',
                'Excel, Sheets',
                const Color(0xFFE6B43A),
                () => _copy(_asCsv(rows)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionCard(
                scheme,
                Icons.summarize_rounded,
                'Summary',
                'Headline + zone counts',
                const Color(0xFFA855F7),
                () => _copy(_asSummary(rows)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Big primary share button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: _showShareSheet,
            icon: const Icon(Icons.ios_share_rounded, size: 18),
            label: const Text('Share full report',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionCard(ColorScheme scheme, IconData icon, String title,
      String subtitle, Color accent, VoidCallback onTap) {
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 16, color: accent),
                  ),
                  const Spacer(),
                  Icon(Icons.content_copy_rounded,
                      size: 14, color: scheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 10),
              Text(title,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 10,
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  // Compact executive summary text format
  String _asSummary(List<_HeatRow> rows) {
    final r = _activeRange;
    final endExcl = r.end.add(const Duration(days: 1));
    final names = _filteredRoster.map((e) => e['name'] as String).toList();
    final orgAvg =
        TeamScreen.avgRatingFor(start: r.start, end: endExcl, names: names);
    final fb = TeamScreen.rosterFeedbackCount(
        start: r.start, end: endExcl, names: names);
    final zones = List.filled(5, 0);
    for (final row in rows) {
      final z = _zoneIndex(row.avg);
      if (z >= 0) zones[z]++;
    }
    final top = rows.isNotEmpty ? rows.first : null;
    final bottom = rows.isNotEmpty ? rows.last : null;

    final buf = StringBuffer();
    buf.writeln('📊 PERFORMANCE SUMMARY');
    buf.writeln('Range: $_rangeLabel');
    buf.writeln('Grouped by: ${_groupLabel(_groupBy)}');
    buf.writeln('');
    buf.writeln('• Org pulse: ${orgAvg?.toStringAsFixed(1) ?? '—'} / 5.0');
    buf.writeln('• Coverage: ${names.length} people, $fb feedback entries');
    buf.writeln(
        '• Distribution: ${zones[4]} excellent, ${zones[3]} healthy, ${zones[2]} steady, ${zones[1]} watch, ${zones[0]} at-risk');
    if (top != null && top.avg != null) {
      buf.writeln(
          '• Top: ${top.label} @ ${top.avg!.toStringAsFixed(1)} (${_heatLabel(top.avg)})');
    }
    if (bottom != null && bottom.avg != null && bottom != top) {
      buf.writeln(
          '• Bottom: ${bottom.label} @ ${bottom.avg!.toStringAsFixed(1)} (${_heatLabel(bottom.avg)})');
    }
    return buf.toString();
  }

  // ── HERO CARD ──
  Widget _heroCard(
      ColorScheme scheme,
      double? orgAvg,
      int totalFeedback,
      int peopleCount,
      bool hasTrend,
      double delta,
      bool trendUp,
      Color trendColor,
      List<int> zoneCounts,
      int noData) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border(top: BorderSide(color: scheme.primary, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('ORG PULSE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: scheme.onSurfaceVariant)),
              const SizedBox(width: 8),
              Text('$peopleCount people · $totalFeedback feedback',
                  style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(orgAvg?.toStringAsFixed(1) ?? '—',
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
                      Text(delta.abs().toStringAsFixed(2),
                          style: TextStyle(
                              color: trendColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text('ZONE DISTRIBUTION',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: scheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          _zoneBar(zoneCounts, noData),
          const SizedBox(height: 8),
          _legendStrip(scheme),
        ],
      ),
    );
  }

  Widget _zoneBar(List<int> zoneCounts, int noData) {
    final total = zoneCounts.fold<int>(0, (a, b) => a + b) + noData;
    if (total == 0) {
      return Container(
        height: 16,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 16,
        child: Row(
          children: [
            for (var i = 0; i < 5; i++)
              if (zoneCounts[i] > 0)
                Expanded(
                    flex: zoneCounts[i],
                    child: Container(color: _heatColors[i])),
            if (noData > 0)
              Expanded(
                  flex: noData,
                  child: Container(color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }

  // ── SECTION LABEL ──
  Widget _sectionLabel(ColorScheme scheme, String text) => Text(text,
      style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: scheme.onSurfaceVariant,
          letterSpacing: 0.8));

  // ── CHIPS ──
  Widget _chip(ColorScheme scheme, String label, bool selected, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: selected ? scheme.onPrimary : scheme.onSurfaceVariant)),
      ),
    );
  }

  // ── DROPDOWN ──
  Widget _dropdown(ColorScheme scheme, String label, String value,
      List<String> items, void Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          icon: Icon(Icons.expand_more_rounded,
              size: 18, color: scheme.onSurfaceVariant),
          hint: Text(label,
              style: TextStyle(
                  fontSize: 13, color: scheme.onSurfaceVariant)),
          items: items
              .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── HEAT TILE ──
  Widget _heatTile(ColorScheme scheme, _HeatRow row) {
    final color = _heatColor(row.avg);
    final zoneLabel = _heatLabel(row.avg);
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showGroupMembers(row),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: [
              // Big colored numeric pill (like dashboard)
              Container(
                width: 64,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(0.5), width: 1.3),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(row.avg?.toStringAsFixed(1) ?? '—',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: color,
                            height: 1.0)),
                    const SizedBox(height: 2),
                    Text(zoneLabel,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: color)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(row.label,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _miniStat(scheme, Icons.people_rounded,
                            '${row.peopleCount}', 'people'),
                        _miniStat(scheme, Icons.chat_bubble_rounded,
                            '${row.feedbackCount}', 'feedback'),
                      ],
                    ),
                  ],
                ),
              ),
              // 4-quarter trend sparkline
              Container(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 32,
                      child: CustomPaint(
                        painter: _SparklinePainter(
                            series: row.trend, color: color),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_trendArrow(row.trend),
                            size: 10, color: _trendArrowColor(row.trend, color)),
                        const SizedBox(width: 2),
                        Text('4Q',
                            style: TextStyle(
                                fontSize: 9,
                                color: scheme.onSurfaceVariant,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded,
                  size: 18, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  // Pick first and last non-null values in the trend to determine direction
  IconData _trendArrow(List<double?> series) {
    final non = series.where((v) => v != null).cast<double>().toList();
    if (non.length < 2) return Icons.remove_rounded;
    final delta = non.last - non.first;
    if (delta > 0.1) return Icons.trending_up_rounded;
    if (delta < -0.1) return Icons.trending_down_rounded;
    return Icons.trending_flat_rounded;
  }

  Color _trendArrowColor(List<double?> series, Color fallback) {
    final non = series.where((v) => v != null).cast<double>().toList();
    if (non.length < 2) return Colors.grey;
    final delta = non.last - non.first;
    if (delta > 0.1) return const Color(0xFF1D9E75);
    if (delta < -0.1) return const Color(0xFFE89A6B);
    return fallback;
  }

  Widget _miniStat(ColorScheme scheme, IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: scheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface)),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
      ],
    );
  }

  // ── DRILL-DOWN: show members of a group ──
  void _showGroupMembers(_HeatRow row) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scroll) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text(row.label,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: scheme.onSurface)),
              const SizedBox(height: 4),
              Text(
                  '${row.peopleCount} people · ${row.feedbackCount} feedback · ${_heatLabel(row.avg)}',
                  style: TextStyle(
                      fontSize: 12, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scroll,
                  itemCount: row.members.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final name = row.members[i];
                    final emp = TeamScreen.roster
                        .firstWhere((e) => e['name'] == name, orElse: () => {});
                    final r = _activeRange;
                    final avg = TeamScreen.avgRatingFor(
                        start: r.start,
                        end: r.end.add(const Duration(days: 1)),
                        names: [name]);
                    final color = _heatColor(avg);
                    final initials = name
                        .split(' ')
                        .map((p) => p.isEmpty ? '' : p[0])
                        .join()
                        .toUpperCase();
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: scheme.primaryContainer,
                            child: Text(initials,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: scheme.onPrimaryContainer)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: scheme.onSurface)),
                                if (emp['title'] != null)
                                  Text(
                                      '${emp['title']} · ${emp['department'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: scheme.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: color.withOpacity(0.5), width: 1.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded, size: 12, color: color),
                                const SizedBox(width: 2),
                                Text(avg?.toStringAsFixed(1) ?? '—',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: color)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── LEGEND ──
  Widget _legendStrip(ColorScheme scheme) {
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: [
        _legend(_heatColors[0], 'At-risk'),
        _legend(_heatColors[1], 'Watch'),
        _legend(_heatColors[2], 'Steady'),
        _legend(_heatColors[3], 'Healthy'),
        _legend(_heatColors[4], 'Excellent'),
      ],
    );
  }

  Widget _legend(Color c, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(color: c, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700)),
      ],
    );
  }

  String _groupLabel(GroupBy g) => switch (g) {
        GroupBy.region => 'Region',
        GroupBy.department => 'Department',
        GroupBy.manager => 'Manager',
        GroupBy.employee => 'Employee',
      };
}

class _HeatRow {
  final String label;
  final double? avg;
  final int feedbackCount;
  final int peopleCount;
  final List<String> members;
  final List<double?> trend; // 4 quarterly avgs, oldest → newest
  _HeatRow({
    required this.label,
    required this.avg,
    required this.feedbackCount,
    required this.peopleCount,
    required this.members,
    required this.trend,
  });
}

// Mini line graph painter — 4 quarterly avg points
class _SparklinePainter extends CustomPainter {
  final List<double?> series;
  final Color color;
  _SparklinePainter({required this.series, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (series.length < 2) return;
    final values = series.map((v) => v ?? 0.0).toList();
    // y-range: 1.0 to 5.0
    const minY = 1.0;
    const maxY = 5.0;
    final dx = size.width / (series.length - 1);

    final points = <Offset>[];
    for (var i = 0; i < series.length; i++) {
      final v = series[i];
      if (v == null) continue;
      final x = i * dx;
      final y = size.height -
          ((v - minY) / (maxY - minY)).clamp(0.0, 1.0) * size.height;
      points.add(Offset(x, y));
    }
    if (points.length < 2) {
      // Single dot
      if (points.length == 1) {
        canvas.drawCircle(
            points.first, 2.5, Paint()..color = color);
      }
      return;
    }

    // Line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, linePaint);

    // Subtle fill below the line
    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();
    canvas.drawPath(
        fillPath, Paint()..color = color.withOpacity(0.15));

    // End dot to anchor "now"
    final dotPaint = Paint()..color = color;
    canvas.drawCircle(points.last, 2.5, dotPaint);
    canvas.drawCircle(points.last, 4, Paint()..color = color.withOpacity(0.35));
    // ignore unused warning
    values;
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.series != series || old.color != color;
}
