import 'package:flutter/material.dart';
import '../models/feedback.dart';

// OPTION 4: DEPARTMENT ANALYTICS - Breakdown by department/specialties
class DashboardOption4 extends StatefulWidget {
  const DashboardOption4({Key? key}) : super(key: key);

  @override
  State<DashboardOption4> createState() => _DashboardOption4State();
}

class _DashboardOption4State extends State<DashboardOption4> {
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
    // Mock department data
    final departments = [
      {
        'name': 'Cardiology',
        'members': 5,
        'avgRating': 4.5,
        'positive': 8,
        'constructive': 2,
        'color': Colors.red,
      },
      {
        'name': 'Pediatrics',
        'members': 3,
        'avgRating': 4.2,
        'positive': 5,
        'constructive': 3,
        'color': Colors.pink,
      },
      {
        'name': 'Surgery',
        'members': 4,
        'avgRating': 3.8,
        'positive': 6,
        'constructive': 4,
        'color': Colors.orange,
      },
      {
        'name': 'Emergency',
        'members': 6,
        'avgRating': 4.1,
        'positive': 9,
        'constructive': 3,
        'color': Colors.purple,
      },
      {
        'name': 'Nursing',
        'members': 8,
        'avgRating': 4.3,
        'positive': 12,
        'constructive': 2,
        'color': Colors.teal,
      },
    ];

    final totalMembers = departments.fold<int>(0, (sum, d) => sum + (d['members'] as int));
    final overallAvg = departments.fold<double>(0, (sum, d) => sum + (d['avgRating'] as double)) / departments.length;

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
            // Overall Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[50]!, Colors.cyan[50]!],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(departments.length.toString(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: Colors.blue)),
                      const Text('Departments', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  Column(
                    children: [
                      Text(totalMembers.toString(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: Colors.green)),
                      const Text('Team Members', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  Column(
                    children: [
                      Text(overallAvg.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: Colors.amber)),
                      const Text('Avg Rating', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Department Cards
            Text('📊 Department Performance', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800])),
            const SizedBox(height: 12),
            ...departments.map((dept) {
              final color = dept['color'] as Color;
              final rating = dept['avgRating'] as double;
              final ratingPercent = (rating / 5.0 * 100).toInt();
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3), width: 2),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                            ),
                            const SizedBox(width: 8),
                            Text(dept['name'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                          child: Text('${dept['members']} staff', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Rating', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                  Text('${rating.toStringAsFixed(1)}/5.0', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: rating / 5.0,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(color),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${dept['positive']}✓', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                            Text('${dept['constructive']}⚡', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.orange)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Comparative Insights
            Text('🔍 Comparative Insights', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.grey[800])),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[200]!, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.green[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Top Performer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        Text('Nursing (4.3 avg) - Strongest team', style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange[200]!, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_down, color: Colors.orange[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Development Area', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        Text('Surgery (3.8 avg) - Focus on training', style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                      ],
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
