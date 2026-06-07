import 'package:flutter/material.dart';
import '../models/feedback.dart';

// OPTION 3: ALERTS & RISKS - Focus on what needs attention
class DashboardOption3 extends StatefulWidget {
  const DashboardOption3({Key? key}) : super(key: key);

  @override
  State<DashboardOption3> createState() => _DashboardOption3State();
}

class _DashboardOption3State extends State<DashboardOption3> {
  late List<FeedbackItem> _localFeedbacks;

  @override
  void initState() {
    super.initState();
    _localFeedbacks = [
      FeedbackItem(
        id: '1',
        employeeName: 'Dr. Mehta',
        feedbackType: 'Positive',
        comment: 'Demonstrates strong clinical judgment.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FeedbackItem(
        id: '2',
        employeeName: 'Sarah Chen',
        feedbackType: 'Constructive',
        comment: 'Needs development in documentation.',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      FeedbackItem(
        id: '3',
        employeeName: 'James Peterson',
        feedbackType: 'Positive',
        comment: 'Outstanding leadership.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<FeedbackItem>>{};
    for (final fb in _localFeedbacks) {
      grouped.putIfAbsent(fb.employeeName, () => []).add(fb);
    }

    final atRisk = grouped.entries
        .where((e) {
          final constructive = e.value.where((f) => f.feedbackType == 'Constructive').length;
          final positive = e.value.where((f) => f.feedbackType == 'Positive').length;
          return constructive > positive;
        })
        .toList();

    final upcomingGoals = [
      {'name': 'Zero Medication Errors', 'daysLeft': 3, 'owner': 'Sarah Chen'},
      {'name': 'Complete Certification', 'daysLeft': 15, 'owner': 'Dr. Mehta'},
      {'name': 'Team Training', 'daysLeft': 28, 'owner': 'James Peterson'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        automaticallyImplyLeading: false,
        elevation: 2,
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[200]!, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_rounded, color: Colors.red[600], size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⚠️ Attention Needed', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        Text('${atRisk.length} employee(s) at risk • ${upcomingGoals.where((g) => g['daysLeft'] as int <= 7).length} urgent deadlines',
                            style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // At-Risk Employees
            if (atRisk.isNotEmpty) ...[
              Text('🚨 At-Risk Employees', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.red[700])),
              const SizedBox(height: 10),
              ...atRisk.map((entry) {
                final constructive = entry.value.where((f) => f.feedbackType == 'Constructive').length;
                final positive = entry.value.where((f) => f.feedbackType == 'Positive').length;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red[200]!, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('$constructive constructive vs $positive positive', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.red[600], borderRadius: BorderRadius.circular(6)),
                        child: const Text('Action Needed', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],

            // Urgent Deadlines
            Text('⏰ Urgent Goals (< 7 days)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.orange[700])),
            const SizedBox(height: 10),
            ...upcomingGoals
                .where((g) => g['daysLeft'] as int <= 7)
                .map((goal) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange[200]!, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(goal['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text('${goal['owner']}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange[600], borderRadius: BorderRadius.circular(4)),
                      child: Text('${goal['daysLeft']} days', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Upcoming Goals
            Text('📅 Upcoming Deadlines (7-30 days)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.blue[700])),
            const SizedBox(height: 10),
            ...upcomingGoals
                .where((g) => (g['daysLeft'] as int) > 7 && (g['daysLeft'] as int) <= 30)
                .map((goal) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue[200]!, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(goal['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text('${goal['owner']}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                    Text('${goal['daysLeft']} days', style: TextStyle(fontSize: 11, color: Colors.blue[600], fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
