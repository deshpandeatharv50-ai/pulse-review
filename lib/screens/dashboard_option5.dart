import 'package:flutter/material.dart';
import '../models/feedback.dart';

// OPTION 5: TEAM SENTIMENT & CULTURE - Real-time team pulse & engagement
class DashboardOption5 extends StatefulWidget {
  const DashboardOption5({Key? key}) : super(key: key);

  @override
  State<DashboardOption5> createState() => _DashboardOption5State();
}

class _DashboardOption5State extends State<DashboardOption5> {
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
    final totalPositive = _localFeedbacks.where((f) => f.feedbackType == 'Positive').length;
    final totalConstructive = _localFeedbacks.where((f) => f.feedbackType == 'Constructive').length;
    final total = _localFeedbacks.length;
    final sentimentScore = total > 0 ? ((totalPositive - totalConstructive) / total * 100).toInt() : 50;

    // Mock trending employees
    final trending = [
      {'name': 'Dr. Mehta', 'trend': '↑ +3 this week', 'sentiment': 'Very Positive'},
      {'name': 'Sarah Chen', 'trend': '→ Stable', 'sentiment': 'Neutral'},
      {'name': 'James Peterson', 'trend': '↑ +2 this week', 'sentiment': 'Positive'},
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
            // Team Sentiment Gauge
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[50]!, Colors.emerald[100]!],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green[300]!, width: 2),
              ),
              child: Column(
                children: [
                  const Text('💚 Team Sentiment', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: (sentimentScore + 100) / 200,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            sentimentScore > 20 ? Colors.green : sentimentScore > 0 ? Colors.amber : Colors.red,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text('${sentimentScore > 0 ? '+' : ''}$sentimentScore', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 28)),
                          const Text('Sentiment', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(totalPositive.toString(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.green)),
                            const Text('Positive', style: TextStyle(fontSize: 9)),
                          ],
                        ),
                        const Text('vs', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                        Column(
                          children: [
                            Text(totalConstructive.toString(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.orange)),
                            const Text('Constructive', style: TextStyle(fontSize: 9)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // This Week's Highlights
            Text("🌟 This Week's Highlights", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800])),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[200]!, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Clinical Excellence', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text('Dr. Mehta showcased exceptional patient care', style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('🎯', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Team Collaboration', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text('James Peterson led impressive team coordination', style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sentiment Tracker
            Text('📈 Team Member Sentiment', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800])),
            const SizedBox(height: 12),
            ...trending.map((emp) {
              final isTrendingUp = emp['trend']!.contains('↑');
              final isStable = emp['trend']!.contains('→');
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(emp['name']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Row(
                          children: [
                            Text(
                              emp['trend']!,
                              style: TextStyle(
                                fontSize: 11,
                                color: isTrendingUp ? Colors.green : isStable ? Colors.grey : Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(emp['sentiment']!, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isTrendingUp ? Colors.green[50] : isStable ? Colors.grey[50] : Colors.orange[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isTrendingUp ? Colors.green[200]! : isStable ? Colors.grey[200]! : Colors.orange[200]!,
                        ),
                      ),
                      child: Icon(
                        isTrendingUp ? Icons.trending_up : isStable ? Icons.trending_flat : Icons.trending_down,
                        color: isTrendingUp ? Colors.green[600] : isStable ? Colors.grey[600] : Colors.orange[600],
                        size: 18,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Engagement Velocity
            Text('⚡ Feedback Velocity', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800])),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[200]!, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Today', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      Text('2 feedback items', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 6,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('This Week', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      Text('5 feedback items', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.8,
                      minHeight: 6,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
