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

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF9),
      appBar: AppBar(
        backgroundColor: _teal,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('MediFlow',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
            Text('Central Medical Group · James Peterson',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              try {
                await Supabase.instance.client.auth.signOut();
              } catch (_) {}
              if (mounted) Navigator.of(context).pushReplacementNamed('/');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Performance Overview',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: _ink)),
            const SizedBox(height: 3),
            Text(_rangeLabel,
                style: const TextStyle(fontSize: 13, color: Color(0xFF8AA39B), fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),

            // Pill range toggle
            Row(children: [
              _pill('This Quarter', DashRange.current),
              const SizedBox(width: 10),
              _pill('Last Quarter', DashRange.last),
            ]),
            const SizedBox(height: 20),

            // 2x2 calm KPI cards
            Row(children: [
              Expanded(child: _kpi('Team members', _teamMembers.toString(), Icons.groups_rounded, _teal,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TeamScreen())))),
              const SizedBox(width: 12),
              Expanded(child: _kpi('Positive', positive.toString(), Icons.thumb_up_rounded, _green,
                  () => _showFeedbackPopup('Positive'))),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _kpi('Constructive', constructive.toString(), Icons.bolt_rounded, _amber,
                  () => _showFeedbackPopup('Constructive'))),
              const SizedBox(width: 12),
              Expanded(child: _kpi('Avg rating', avg.toStringAsFixed(1), Icons.star_rounded, _amber,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReviewsAdvancedClassic())))),
            ]),
            const SizedBox(height: 22),

            // Today's Focus triage card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0EAE7)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today's focus",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _ink)),
                  const SizedBox(height: 10),
                  _focusItem('Review $focusName feedback', () => _showFeedbackPopup('Constructive')),
                  _focusItem('$_overdueGoals goal${_overdueGoals == 1 ? '' : 's'} overdue',
                      () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GoalsScreen()))),
                  _focusItem('$_pendingMeetings meeting${_pendingMeetings == 1 ? '' : 's'} pending',
                      () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meetings — coming soon')))),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Thin recent-activity strip
            GestureDetector(
              onTap: () => _showFeedbackPopup(null),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history_rounded, size: 16, color: Color(0xFF8AA39B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fb.isEmpty
                            ? 'No recent activity'
                            : 'Recent · ${fb.take(3).map((f) => f.employeeName.split(' ').first).join(', ')}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF5A6E68)),
                      ),
                    ),
                    const Text('View all',
                        style: TextStyle(fontSize: 12, color: _teal, fontWeight: FontWeight.w600)),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: _teal),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, DashRange value) {
    final selected = _range == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _range = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? _teal : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: selected ? _teal : const Color(0xFFB8D4D0)),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : _teal)),
          ),
        ),
      ),
    );
  }

  Widget _kpi(String label, String value, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: const Color(0xFFF1F7F5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 12),
              Text(value,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 34, height: 1.0, color: _ink)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF8AA39B))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _focusItem(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            const Icon(Icons.radio_button_unchecked, size: 18, color: _teal),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF3D544E)))),
            const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFB8C9C4)),
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
