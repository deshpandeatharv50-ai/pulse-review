import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/feedback.dart';
import 'team_screen.dart';
import 'goals_screen.dart';
import 'reviews_advanced_classic.dart';

// CALM CLINICAL DASHBOARD
// Light/teal, big 2x2 KPI cards, a "Today's Focus" triage list, and a thin
// recent-activity strip. Everything reacts to the quarter range filter.
enum DashRange { current, last }

class DashboardEnterprise extends StatefulWidget {
  const DashboardEnterprise({Key? key}) : super(key: key);

  @override
  State<DashboardEnterprise> createState() => _DashboardEnterpriseState();
}

class _DashboardEnterpriseState extends State<DashboardEnterprise> {
  DashRange _range = DashRange.current;

  static const Color _teal = Color(0xFF0E7C7B);
  static const Color _green = Color(0xFF1D9E75);
  static const Color _amber = Color(0xFFBA7517);
  static const Color _ink = Color(0xFF16302B);

  // Fixed "today" so demo quarters stay stable.
  static final DateTime _today = DateTime(2026, 6, 10);

  static const List<String> _mon = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  List<FeedbackItem> get _allFeedbacks => [
        // ---- Current quarter (Q2 2026: Apr–Jun) ----
        FeedbackItem(id: '1', employeeName: 'Priya Sharma', feedbackType: 'Positive',
            comment: 'Great job on technical skills and overall performance',
            createdAt: DateTime(2026, 6, 8, 18, 44)),
        FeedbackItem(id: '2', employeeName: 'Carlos Rivera', feedbackType: 'Constructive',
            comment: 'There may have been an issue with your submission. Please share the original notes.',
            createdAt: DateTime(2026, 6, 6, 16, 44)),
        FeedbackItem(id: '3', employeeName: 'Aisha Williams', feedbackType: 'Positive',
            comment: 'Your positive attitude with the VP of Marketing was commendable',
            createdAt: DateTime(2026, 6, 5, 20, 44)),
        FeedbackItem(id: '4', employeeName: 'David Park', feedbackType: 'Constructive',
            comment: 'The redesign could benefit from refinement. There is real potential here.',
            createdAt: DateTime(2026, 6, 2, 9, 12)),
        FeedbackItem(id: '5', employeeName: 'Marcus Johnson', feedbackType: 'Constructive',
            comment: 'Technical skills need work. Please focus on the fundamentals.',
            createdAt: DateTime(2026, 5, 20, 11, 30)),
        // ---- Last quarter (Q1 2026: Jan–Mar) ----
        FeedbackItem(id: '6', employeeName: 'James Bellano', feedbackType: 'Constructive',
            comment: 'Presentation lacked structure. Prepare visuals ahead of time.',
            createdAt: DateTime(2026, 3, 12, 14, 5)),
        FeedbackItem(id: '7', employeeName: 'Nina Patel', feedbackType: 'Positive',
            comment: 'Excellent patient handover and documentation this cycle.',
            createdAt: DateTime(2026, 2, 18, 10, 20)),
        FeedbackItem(id: '8', employeeName: 'Ravi Kumar', feedbackType: 'Positive',
            comment: 'Strong leadership covering the night shift rotation.',
            createdAt: DateTime(2026, 2, 3, 8, 15)),
      ];

  DateTimeRange get _activeRange {
    final qStartMonth = ((_today.month - 1) ~/ 3) * 3 + 1;
    final currentStart = DateTime(_today.year, qStartMonth, 1);
    if (_range == DashRange.current) {
      final end = DateTime(_today.year, qStartMonth + 3, 1).subtract(const Duration(days: 1));
      return DateTimeRange(start: currentStart, end: end);
    } else {
      final lastStart = DateTime(_today.year, qStartMonth - 3, 1);
      final lastEnd = currentStart.subtract(const Duration(days: 1));
      return DateTimeRange(start: lastStart, end: lastEnd);
    }
  }

  String get _rangeLabel {
    final r = _activeRange;
    return '${_mon[r.start.month]} – ${_mon[r.end.month]} ${r.end.year}';
  }

  List<FeedbackItem> get _filtered {
    final r = _activeRange;
    final start = r.start;
    final end = r.end.add(const Duration(days: 1));
    return _allFeedbacks
        .where((f) =>
            f.createdAt != null &&
            f.createdAt!.isAfter(start.subtract(const Duration(seconds: 1))) &&
            f.createdAt!.isBefore(end))
        .toList()
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }

  int get _teamMembers => _range == DashRange.current ? 10 : 8;
  int get _overdueGoals => _range == DashRange.current ? 1 : 0;
  int get _pendingMeetings => _range == DashRange.current ? 2 : 1;

  @override
  Widget build(BuildContext context) {
    final fb = _filtered;
    final positive = fb.where((f) => f.feedbackType == 'Positive').length;
    final constructive = fb.where((f) => f.feedbackType == 'Constructive').length;
    final avg = fb.isEmpty ? 0.0 : (positive * 5 + constructive * 3) / fb.length;
    final constructiveList = fb.where((f) => f.feedbackType == 'Constructive').toList();
    final focusName = constructiveList.isNotEmpty
        ? constructiveList.first.employeeName
        : (fb.isNotEmpty ? fb.first.employeeName : 'your team');

    final scheme = Theme.of(context).colorScheme;
    final positives = fb.where((f) => f.feedbackType == 'Positive').toList();
    final pulseScore = avg; // 0..5
    // Synthetic last-quarter score so the trend chip has something to say.
    final lastQuarterScore = _range == DashRange.current ? 3.6 : 3.4;
    final delta = pulseScore - lastQuarterScore;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Greeting + logout ───
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: scheme.primaryContainer,
                    child: Text('JP',
                        style: TextStyle(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                            fontSize: 14)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Good afternoon, James',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface)),
                        Text('Central Medical Group · ELEV8 demo',
                            style: TextStyle(
                                fontSize: 11, color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    onPressed: () async {
                      try { await Supabase.instance.client.auth.signOut(); } catch (_) {}
                      if (mounted) Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ─── HERO Team Pulse card ───
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.primary,
                      Color.lerp(scheme.primary, scheme.tertiary, 0.55)!,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('TEAM PULSE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2)),
                        ),
                        const Spacer(),
                        Text(_rangeLabel,
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(pulseScore.toStringAsFixed(1),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 56,
                                fontWeight: FontWeight.w900,
                                height: 1.0)),
                        const SizedBox(width: 4),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('/ 5.0',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                  delta >= 0
                                      ? Icons.trending_up_rounded
                                      : Icons.trending_down_rounded,
                                  color: Colors.white,
                                  size: 16),
                              const SizedBox(width: 4),
                              Text(
                                  '${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)} vs last Q',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      delta >= 0
                          ? 'Your team is trending up this quarter — keep the momentum'
                          : 'Pulse softening — review constructive items below',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ─── M3 SegmentedButton quarter toggle ───
              SegmentedButton<DashRange>(
                segments: const [
                  ButtonSegment(value: DashRange.current, label: Text('This quarter'), icon: Icon(Icons.flash_on_rounded)),
                  ButtonSegment(value: DashRange.last, label: Text('Last quarter'), icon: Icon(Icons.history_rounded)),
                ],
                selected: {_range},
                onSelectionChanged: (s) => setState(() => _range = s.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                ),
              ),
              const SizedBox(height: 18),

              // ─── 4 KPI tiles, each its own M3 tonal container ───
              Row(children: [
                Expanded(child: _kpiM3('Team size', _teamMembers.toString(),
                    Icons.groups_rounded,
                    scheme.primaryContainer, scheme.onPrimaryContainer,
                    () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TeamScreen())))),
                const SizedBox(width: 12),
                Expanded(child: _kpiM3('Avg rating', avg.toStringAsFixed(1),
                    Icons.star_rounded,
                    scheme.tertiaryContainer, scheme.onTertiaryContainer,
                    () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReviewsAdvancedClassic())))),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _kpiM3('Positive', positive.toString(),
                    Icons.favorite_rounded,
                    scheme.secondaryContainer, scheme.onSecondaryContainer,
                    () => _showFeedbackPopup('Positive'))),
                const SizedBox(width: 12),
                Expanded(child: _kpiM3('Constructive', constructive.toString(),
                    Icons.lightbulb_rounded,
                    scheme.surfaceContainerHighest, scheme.onSurfaceVariant,
                    () => _showFeedbackPopup('Constructive'))),
              ]),
              const SizedBox(height: 22),

              // ─── Wins this quarter (horizontal celebration row) ───
              if (positives.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.celebration_rounded, size: 18, color: scheme.tertiary),
                    const SizedBox(width: 6),
                    Text('Wins this quarter',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface)),
                    const Spacer(),
                    Text('${positives.length}',
                        style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 124,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: positives.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => _winCard(positives[i], scheme),
                  ),
                ),
                const SizedBox(height: 22),
              ],

              // ─── Priorities today (M3 card) ───
              Container(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bolt_rounded, size: 18, color: scheme.primary),
                        const SizedBox(width: 6),
                        Text('Priorities today',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: scheme.onSurface)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _priorityItem(
                      scheme,
                      Icons.chat_bubble_rounded,
                      'Review $focusName feedback',
                      'Constructive · open ${(constructive == 0 ? 0 : 1)}',
                      () => _showFeedbackPopup('Constructive'),
                    ),
                    _priorityItem(
                      scheme,
                      Icons.flag_rounded,
                      '$_overdueGoals goal${_overdueGoals == 1 ? '' : 's'} overdue',
                      'SMART goals · needs attention',
                      () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GoalsScreen())),
                    ),
                    _priorityItem(
                      scheme,
                      Icons.event_rounded,
                      '$_pendingMeetings 1:1 meeting${_pendingMeetings == 1 ? '' : 's'} pending',
                      'Schedule with team',
                      () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meetings — coming soon'))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ─── Recent pulse strip ───
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showFeedbackPopup(null),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timeline_rounded, size: 18, color: scheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fb.isEmpty
                              ? 'No recent activity'
                              : 'Recent · ${fb.take(3).map((f) => f.employeeName.split(' ').first).join(', ')}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: scheme.onSurface, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text('View all',
                          style: TextStyle(fontSize: 12, color: scheme.primary, fontWeight: FontWeight.w700)),
                      Icon(Icons.chevron_right_rounded, size: 18, color: scheme.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // M3 KPI tile with full tonal container background.
  Widget _kpiM3(String label, String value, IconData icon,
      Color bg, Color fg, VoidCallback onTap) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: fg.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 16, color: fg),
                  ),
                  const Spacer(),
                  Icon(Icons.trending_up_rounded, size: 14, color: fg.withOpacity(0.6)),
                ],
              ),
              const SizedBox(height: 14),
              Text(value,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 32, height: 1.0, color: fg)),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(fontSize: 12, color: fg.withOpacity(0.8), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  // Small celebration card for "Wins this quarter".
  Widget _winCard(FeedbackItem f, ColorScheme scheme) {
    final initials = f.employeeName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .take(2)
        .join()
        .toUpperCase();
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: scheme.tertiary,
                child: Text(initials,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(f.employeeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: scheme.onTertiaryContainer)),
              ),
              Icon(Icons.favorite_rounded, size: 14, color: scheme.tertiary),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              f.comment,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11, color: scheme.onTertiaryContainer, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityItem(ColorScheme scheme, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 16, color: scheme.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  void _showFeedbackPopup(String? typeFilter) {
    final items = typeFilter == null
        ? _filtered
        : _filtered.where((f) => f.feedbackType == typeFilter).toList();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(typeFilter == null ? 'Recent Activity' : '$typeFilter Feedback',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              Text(_rangeLabel, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const Divider(),
              Flexible(
                child: items.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(child: Text('Nothing in this quarter', style: TextStyle(color: Colors.grey[500]))),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final f = items[index];
                          final isPositive = f.feedbackType == 'Positive';
                          final d = f.createdAt!;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text(f.employeeName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isPositive ? Colors.green[100] : Colors.orange[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(f.feedbackType,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: isPositive ? Colors.green[700] : Colors.orange[700])),
                                  ),
                                  const Spacer(),
                                  Text('${_mon[d.month]} ${d.day}',
                                      style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                                ]),
                                const SizedBox(height: 8),
                                Text(f.comment, style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.4)),
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
}
