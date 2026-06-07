import 'package:flutter/material.dart';
import '../models/feedback.dart';
import '../models/healthcare_organization.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<FeedbackItem> _localFeedbacks;

  @override
  void initState() {
    super.initState();
    _localFeedbacks = [
      FeedbackItem(
        id: '1',
        employeeName: 'Dr. Mehta',
        feedbackType: 'Positive',
        comment: 'Demonstrates strong clinical judgment and excellent patient communication skills.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FeedbackItem(
        id: '2',
        employeeName: 'Sarah Chen',
        feedbackType: 'Constructive',
        comment: 'Needs development in documentation efficiency.',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      FeedbackItem(
        id: '3',
        employeeName: 'James Peterson',
        feedbackType: 'Positive',
        comment: 'Outstanding leadership in team coordination.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      FeedbackItem(
        id: '4',
        employeeName: 'Dr. Mehta',
        feedbackType: 'Positive',
        comment: 'Fine. This work exemplifies professionalism and quality standards.',
        createdAt: DateTime(2026, 6, 7, 17, 25),
      ),
      FeedbackItem(
        id: '5',
        employeeName: 'Dr. Mehta',
        feedbackType: 'Positive',
        comment: 'Demonstrates strong clinical judgment and excellent patient communication skills.',
        createdAt: DateTime(2026, 6, 7, 15, 22),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Aggregate feedback by employee
    final Map<String, List<FeedbackItem>> grouped = {};
    for (final fb in _localFeedbacks) {
      grouped.putIfAbsent(fb.employeeName, () => []).add(fb);
    }

    final employees = grouped.entries.map((entry) {
      final fbs = entry.value;
      final positive = fbs.where((f) => f.feedbackType == 'Positive').length;
      final constructive = fbs.where((f) => f.feedbackType == 'Constructive').length;
      final avg = (positive * 5 + constructive * 3) / fbs.length;
      return {
        'name': entry.key,
        'positive': positive,
        'constructive': constructive,
        'total': fbs.length,
        'avg': avg,
      };
    }).toList()..sort((a, b) => (b['avg'] as double).compareTo(a['avg'] as double));

    final totalFeedback = _localFeedbacks.length;
    final totalPositive = _localFeedbacks.where((f) => f.feedbackType == 'Positive').length;
    final totalConstructive = _localFeedbacks.where((f) => f.feedbackType == 'Constructive').length;
    final overallAvg = totalFeedback > 0 ? (totalPositive * 5 + totalConstructive * 3) / totalFeedback : 0.0;

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
            // Overall Summary Cards (3 columns)
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Overall Avg Rating',
                    '${overallAvg.toStringAsFixed(2)}/5.0',
                    Colors.green,
                    Icons.star,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Feedback',
                    totalFeedback.toString(),
                    Colors.blue,
                    Icons.comment,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Team Members',
                    employees.length.toString(),
                    Colors.purple,
                    Icons.people,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Positive vs Constructive
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard('Positive', totalPositive, Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard('Constructive', totalConstructive, Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Top Performers
            Text('🏆 Top Performers', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800])),
            const SizedBox(height: 12),
            ...employees.take(3).toList().asMap().entries.map((entry) {
              final index = entry.key;
              final emp = entry.value;
              final medals = ['🥇', '🥈', '🥉'];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.amber[50]!, Colors.yellow[50]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(medals[index], style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(emp['name'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(emp['avg'] as double).toStringAsFixed(2)}/5.0 avg',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${emp['positive']}✓ ${emp['constructive']}⚡',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // All Team Members
            Text('👥 All Team Members', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800])),
            const SizedBox(height: 12),
            ...employees.map((emp) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(emp['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text(
                          '${(emp['avg'] as double).toStringAsFixed(2)}/5.0',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(4)),
                          child: Text('${emp['positive']}', style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(4)),
                          child: Text('${emp['constructive']}', style: const TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[700], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(count.toString(), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28, color: color)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
