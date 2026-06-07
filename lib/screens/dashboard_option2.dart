import 'package:flutter/material.dart';
import '../models/feedback.dart';

class DashboardOption2 extends StatefulWidget {
  const DashboardOption2({Key? key}) : super(key: key);

  @override
  State<DashboardOption2> createState() => _DashboardOption2State();
}

class _DashboardOption2State extends State<DashboardOption2> {
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
    final totalPositive = _localFeedbacks.where((f) => f.feedbackType == 'Positive').length;
    final totalConstructive = _localFeedbacks.where((f) => f.feedbackType == 'Constructive').length;
    final total = _localFeedbacks.length;
    final positivePercent = total > 0 ? (totalPositive / total * 100).toInt() : 0;

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
            // Health Gauge Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[50]!, Colors.indigo[100]!],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue[200]!, width: 2),
              ),
              child: Column(
                children: [
                  const Text('Team Health Score', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: positivePercent / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            positivePercent > 70 ? Colors.green : positivePercent > 50 ? Colors.amber : Colors.red,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text('$positivePercent%', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 32)),
                          const Text('Positive', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(totalPositive.toString(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.green)),
                            const Text('Positive', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        Container(width: 1, height: 40, color: Colors.grey[300]),
                        Column(
                          children: [
                            Text(totalConstructive.toString(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.orange)),
                            const Text('Constructive', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800])),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildActionCard('➕ Add Feedback', Colors.blue)),
                const SizedBox(width: 10),
                Expanded(child: _buildActionCard('🎯 View Goals', Colors.green)),
                const SizedBox(width: 10),
                Expanded(child: _buildActionCard('📊 Reports', Colors.purple)),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activity
            Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800])),
            const SizedBox(height: 12),
            ...(_localFeedbacks.take(4).map((fb) {
              final isPositive = fb.feedbackType == 'Positive';
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: isPositive ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(fb.employeeName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              Text(
                                isPositive ? '✓ Positive' : '⚡ Constructive',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isPositive ? Colors.green : Colors.orange),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            fb.comment,
                            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
        ),
      ),
    );
  }
}
