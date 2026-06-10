import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/feedback.dart';
import 'team_screen.dart';
import 'goals_screen.dart';
import 'reviews_advanced_classic.dart';

// ENTERPRISE PROFESSIONAL DASHBOARD
// Bold, big, actionable KPIs + quarter date-range filter + compact recent activity.
enum DashRange { current, last }

class DashboardEnterprise extends StatefulWidget {
  const DashboardEnterprise({Key? key}) : super(key: key);

  @override
  State<DashboardEnterprise> createState() => _DashboardEnterpriseState();
}

class _DashboardEnterpriseState extends State<DashboardEnterprise> {
  // Selected reporting window. Everything on this screen reacts to it.
  DashRange _range = DashRange.current;

  // Fixed "today" so the demo quarters stay stable.
  static final DateTime _today = DateTime(2026, 6, 10);

  static const List<String> _mon = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // All feedback across both quarters. Built as a getter so hot-reload picks
  // up edits without needing a full restart.
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

  // Quarter boundaries derived from _today.
  DateTimeRange get _activeRange {
    final qStartMonth = ((_today.month - 1) ~/ 3) * 3 + 1; // Q2 -> Apr (4)
    final currentStart = DateTime(_today.year, qStartMonth, 1);
    if (_range == DashRange.current) {
      final end = DateTime(_today.year, qStartMonth + 3, 1)
          .subtract(const Duration(days: 1));
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

  // Team headcount differs by quarter to prove the range drives everything.
  int get _teamMembers => _range == DashRange.current ? 10 : 8;

  @override
  Widget build(BuildContext context) {
    final fb = _filtered;
    final positive = fb.where((f) => f.feedbackType == 'Positive').length;
    final constructive = fb.where((f) => f.feedbackType == 'Constructive').length;
    final avg = fb.isEmpty ? 0.0 : (positive * 5 + constructive * 3) / fb.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('MediFlow',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black)),
            Text('Central Medical Group · James Peterson',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black54)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
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
            // Header + range label
            Text('Performance Overview',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26, color: Colors.grey[900])),
            const SizedBox(height: 4),
            Text(_rangeLabel,
                style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),

            // Quarter selector — drives every number below.
            _buildRangeToggle(),
            const SizedBox(height: 20),

            // BIG ACTIONABLE KPI GRID (2x2)
            Row(children: [
              Expanded(child: _bigKPI('TEAM MEMBERS', _teamMembers.toString(), 'Active',
                  Icons.groups_rounded, Colors.blue, () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TeamScreen()));
              })),
              const SizedBox(width: 14),
              Expanded(child: _bigKPI('POSITIVE', positive.toString(), 'this quarter',
                  Icons.thumb_up_rounded, Colors.green, () => _showFeedbackPopup('Positive'))),
            ]),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _bigKPI('CONSTRUCTIVE', constructive.toString(), 'this quarter',
                  Icons.bolt_rounded, Colors.orange, () => _showFeedbackPopup('Constructive'))),
              const SizedBox(width: 14),
              Expanded(child: _bigKPI('AVG RATING', avg.toStringAsFixed(1), 'out of 5.0',
                  Icons.star_rounded, Colors.amber.shade700, () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ReviewsAdvancedClassic()));
              })),
            ]),
            const SizedBox(height: 26),

            // COMPACT Recent Activity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Activity',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.grey[800])),
                GestureDetector(
                  onTap: () => _showFeedbackPopup(null),
                  child: Text('View all →',
                      style: TextStyle(fontSize: 12, color: Colors.teal[700], fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: fb.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text('No activity in this quarter',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      ),
                    )
                  : Column(
                      children: fb.take(4).map((f) => _compactActivityRow(f, f != fb.take(4).last)).toList(),
                    ),
            ),
            const SizedBox(height: 22),

            // Quick Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F3A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Actions',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _quickAction('👥 Team', () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TeamScreen()));
                    })),
                    const SizedBox(width: 12),
                    Expanded(child: _quickAction('🎯 Goals', () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GoalsScreen()));
                    })),
                    const SizedBox(width: 12),
                    Expanded(child: _quickAction('📋 Review', () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReviewsAdvancedClassic()));
                    })),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Range toggle ----
  Widget _buildRangeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        _rangeChip('This Quarter', DashRange.current),
        _rangeChip('Last Quarter', DashRange.last),
      ]),
    );
  }

  Widget _rangeChip(String label, DashRange value) {
    final selected = _range == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _range = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? Colors.teal : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [BoxShadow(color: Colors.teal.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 2))]
                : null,
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : Colors.grey[700])),
          ),
        ),
      ),
    );
  }

  // ---- Big actionable KPI tile ----
  Widget _bigKPI(String label, String value, String sub, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  Icon(Icons.arrow_outward_rounded, size: 16, color: Colors.grey[400]),
                ],
              ),
              const SizedBox(height: 14),
              Text(value,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 42, height: 1.0, color: Colors.grey[900])),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.3)),
              Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Compact activity row ----
  Widget _compactActivityRow(FeedbackItem f, bool divider) {
    final isPositive = f.feedbackType == 'Positive';
    final d = f.createdAt!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 9, height: 9,
                decoration: BoxDecoration(
                    color: isPositive ? Colors.green : Colors.orange, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.employeeName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(f.comment,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: isPositive ? Colors.green[50] : Colors.orange[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(f.feedbackType,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isPositive ? Colors.green[700] : Colors.orange[700])),
                  ),
                  const SizedBox(height: 3),
                  Text('${_mon[d.month]} ${d.day}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                ],
              ),
            ],
          ),
        ),
        if (divider) Divider(height: 1, color: Colors.grey[100]),
      ],
    );
  }

  Widget _quickAction(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Center(
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white)),
        ),
      ),
    );
  }

  // ---- Feedback popup (optionally filtered by type) ----
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
