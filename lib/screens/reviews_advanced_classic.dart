import 'package:flutter/material.dart';

// MOST ADVANCED & CLASSIC REVIEW DESIGN
// Combines timeless appraisal structure with cutting-edge AI insights
class ReviewsAdvancedClassic extends StatefulWidget {
  const ReviewsAdvancedClassic({Key? key}) : super(key: key);

  @override
  State<ReviewsAdvancedClassic> createState() => _ReviewsAdvancedClassicState();
}

class _ReviewsAdvancedClassicState extends State<ReviewsAdvancedClassic> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedEmployeeIndex = 0;

  final List<Map<String, dynamic>> _employees = [
    {
      'name': 'Dr. Rajesh Mehta',
      'role': 'Consultant Cardiologist',
      'dept': 'Cardiology',
      'tenure': '8 years',
      'profileImage': '👨‍⚕️',
      'cycle': 'Q2 2026',
      'reviewerName': 'Dr. Priya Sharma',
      'status': 'Approved',

      // CLASSIC SECTION: Core Rating
      'overallScore': 4.5,
      'performanceLevel': 'Exceeds Expectations',
      'compareTo': 'Department Avg: 4.1',

      // CLASSIC: Competencies (timeless structure)
      'competencies': [
        {'name': 'Clinical Excellence', 'score': 5, 'weight': 25, 'benchmark': 4.2, 'trend': '↑'},
        {'name': 'Patient Care', 'score': 5, 'weight': 25, 'benchmark': 4.3, 'trend': '↑'},
        {'name': 'Team Collaboration', 'score': 4, 'weight': 20, 'benchmark': 4.0, 'trend': '→'},
        {'name': 'Leadership', 'score': 4, 'weight': 15, 'benchmark': 3.8, 'trend': '↑'},
        {'name': 'Innovation', 'score': 4, 'weight': 15, 'benchmark': 3.5, 'trend': '↑'},
      ],

      // ADVANCED: AI Behavioral Intelligence
      'aiInsights': {
        'sentiment': 'Positive',
        'sentimentScore': 92,
        'communication': 'Excellent articulator, clear decision maker',
        'collaboration': 'Strong peer relationships, mentors 3 juniors',
        'reliability': '98.5% attendance, zero missed deadlines',
        'adaptability': 'Quick learner, implements feedback immediately',
      },

      // ADVANCED: Skill Velocity (growth trajectory)
      'skillVelocity': [
        {'skill': 'Diagnostic Accuracy', 'growth': 12, 'trajectory': 'Ascending'},
        {'skill': 'Mentoring', 'growth': 18, 'trajectory': 'Ascending'},
        {'skill': 'Research', 'growth': 8, 'trajectory': 'Stable'},
        {'skill': 'Documentation', 'growth': -3, 'trajectory': 'Descending'},
      ],

      // CLASSIC: Objectives & Goals
      'objectives': [
        {'goal': 'Publish 2 research papers', 'status': 'In Progress', 'progress': 50, 'dueDate': '30-Sep-2026'},
        {'goal': 'Advance Echocardiography', 'status': 'In Progress', 'progress': 75, 'dueDate': '31-Aug-2026'},
        {'goal': 'Mentor 2 junior residents', 'status': 'Completed', 'progress': 100, 'dueDate': '30-Jun-2026'},
      ],

      // ADVANCED: Peer Benchmarking
      'peerBenchmark': {
        'yourRank': '1st',
        'totalPeers': 12,
        'percentile': 92,
        'topQuartile': true,
      },

      // ADVANCED: Engagement & Culture Fit
      'engagementMetrics': {
        'teamSentiment': 95,
        'cultureFit': 94,
        'leadershipReady': 88,
        'retentionRisk': 5,
      },

      // CLASSIC: Strengths (narrative)
      'strengths': [
        'Exceptional diagnostic accuracy (98% rate)',
        'Natural mentor - develops junior talent',
        'Proactive in adopting new protocols',
        'Strong patient outcomes',
      ],

      // CLASSIC: Development Areas
      'development': [
        'Time management in documentation (85% vs 95% target)',
        'Delegate more tasks to team',
      ],

      // ADVANCED: Predictive Analytics
      'predictiveInsights': {
        'promotionReadiness': 92,
        'leadershipPotential': 'Very High',
        'retentionScore': 95,
        'nextCareerPath': 'Department Head in 2-3 years',
        'skillGapsForPromotion': ['Executive leadership', 'Strategic planning'],
      },

      // ADVANCED: Development Roadmap
      'developmentRoadmap': [
        {'q': 'Q3 2026', 'action': 'Executive Leadership Workshop', 'priority': 'High'},
        {'q': 'Q4 2026', 'action': 'MBA in Healthcare Management', 'priority': 'High'},
        {'q': 'Q1 2027', 'action': 'Lead Strategic Initiative', 'priority': 'Medium'},
        {'q': 'Q2 2027', 'action': 'Department Head Shadowing', 'priority': 'High'},
      ],

      // ADVANCED: Real-time Feedback Pulse
      'feedbackPulse': [
        {'date': 'Jun 10', 'sentiment': 'Positive', 'category': 'Clinical Excellence'},
        {'date': 'Jun 5', 'sentiment': 'Positive', 'category': 'Mentoring'},
        {'date': 'May 28', 'sentiment': 'Constructive', 'category': 'Documentation'},
        {'date': 'May 15', 'sentiment': 'Positive', 'category': 'Collaboration'},
      ],

      // ADVANCED: Comparison Trends (6 months)
      'trendData': [
        {'month': 'Jan', 'score': 4.1},
        {'month': 'Feb', 'score': 4.2},
        {'month': 'Mar', 'score': 4.3},
        {'month': 'Apr', 'score': 4.4},
        {'month': 'May', 'score': 4.5},
        {'month': 'Jun', 'score': 4.5},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emp = _employees[_selectedEmployeeIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Performance Reviews', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER - Classic Professional Format
            _buildClassicHeader(emp),

            // TABS - Organize Advanced Content
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: const Color(0xFF1A237E),
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: const Color(0xFF1A237E),
                tabs: const [
                  Tab(text: '📊 Overview'),
                  Tab(text: '🎯 Goals'),
                  Tab(text: '🤖 AI Insights'),
                  Tab(text: '📈 Analytics'),
                  Tab(text: '🚀 Growth Path'),
                  Tab(text: '💬 Feedback'),
                ],
              ),
            ),

            SizedBox(
              height: 1200,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(emp),
                  _buildGoalsTab(emp),
                  _buildAIInsightsTab(emp),
                  _buildAnalyticsTab(emp),
                  _buildGrowthPathTab(emp),
                  _buildFeedbackTab(emp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ CLASSIC HEADER ============
  Widget _buildClassicHeader(Map<String, dynamic> emp) {
    return Container(
      color: const Color(0xFF1A237E),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee Name & Role (Classic Format)
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Center(child: Text(emp['profileImage'] as String, style: const TextStyle(fontSize: 32))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emp['name'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white)),
                    Text('${emp['role']} • ${emp['dept']}', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                    Text('${emp['tenure']} tenure', style: const TextStyle(fontSize: 11, color: Colors.white60)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Approved', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Classic Overall Score (Centered, Professional)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Overall Score', style: TextStyle(fontSize: 11, color: Colors.white70)),
                    Text('${emp['overallScore']}/5.0', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: Colors.white)),
                    Text(emp['performanceLevel'] as String, style: const TextStyle(fontSize: 11, color: Colors.greenAccent)),
                  ],
                ),
                Container(width: 1, height: 50, color: Colors.white.withOpacity(0.2)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emp['compareTo'] as String, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                    Text('${emp['peerBenchmark']['yourRank']} of ${emp['peerBenchmark']['totalPeers']}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
                    Text('${emp['peerBenchmark']['percentile']}th percentile', style: const TextStyle(fontSize: 11, color: Colors.amber)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ TAB 1: OVERVIEW ============
  Widget _buildOverviewTab(Map<String, dynamic> emp) {
    final competencies = emp['competencies'] as List<Map<String, dynamic>>;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Core Competencies (Weighted)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          ...competencies.map((c) {
            final benchmark = c['benchmark'] as double;
            final score = c['score'] as int;
            final trend = c['trend'] as String;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${c['name']} (${c['weight']}%)', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Row(
                        children: [
                          Text('$score/5', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(width: 4),
                          Text(trend, style: TextStyle(fontSize: 12, color: trend == '↑' ? Colors.green : Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(value: score / 5, minHeight: 8, backgroundColor: Colors.grey[300]),
                      ),
                      Positioned(
                        left: benchmark / 5 * 100,
                        child: Container(
                          width: 2,
                          height: 8,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('Benchmark: ${benchmark.toStringAsFixed(1)} (red line)', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          const Text('Summary', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          _buildBulletPoint('Strengths', (emp['strengths'] as List<String>).join(' • '), Colors.green),
          const SizedBox(height: 10),
          _buildBulletPoint('Development', (emp['development'] as List<String>).join(' • '), Colors.orange),
        ],
      ),
    );
  }

  // ============ TAB 2: GOALS ============
  Widget _buildGoalsTab(Map<String, dynamic> emp) {
    final objectives = emp['objectives'] as List<Map<String, dynamic>>;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: objectives
            .map((obj) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(obj['goal'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: obj['status'] == 'Completed' ? Colors.green[100] : Colors.blue[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(obj['status'] as String, style: TextStyle(fontSize: 10, color: obj['status'] == 'Completed' ? Colors.green[700] : Colors.blue[700], fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(value: (obj['progress'] as int) / 100, minHeight: 6),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${obj['progress']}% complete', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                            Text('Due: ${obj['dueDate']}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ============ TAB 3: AI INSIGHTS ============
  Widget _buildAIInsightsTab(Map<String, dynamic> emp) {
    final ai = emp['aiInsights'] as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Text('🤖', style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('AI Assessment', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      Text('Sentiment: ${ai['sentiment']} (${ai['sentimentScore']}%)', style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightCard('💬 Communication', ai['communication'] as String),
          _buildInsightCard('🤝 Collaboration', ai['collaboration'] as String),
          _buildInsightCard('⏱️ Reliability', ai['reliability'] as String),
          _buildInsightCard('🔄 Adaptability', ai['adaptability'] as String),
        ],
      ),
    );
  }

  // ============ TAB 4: ANALYTICS ============
  Widget _buildAnalyticsTab(Map<String, dynamic> emp) {
    final trendData = emp['trendData'] as List<Map<String, dynamic>>;
    final velocity = emp['skillVelocity'] as List<Map<String, dynamic>>;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Performance Trend (6 months)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: trendData
                  .map((d) => Column(
                        children: [
                          Text(d['month'] as String, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                          const SizedBox(height: 4),
                          Text('${d['score']}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        ],
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Skill Velocity (Growth Rate)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),
          ...velocity.map((v) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(v['skill'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                          Text(v['trajectory'] as String, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (v['growth'] as int) > 0 ? Colors.green[100] : Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${v['growth'] > 0 ? '+' : ''}${v['growth']}%',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: (v['growth'] as int) > 0 ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ============ TAB 5: GROWTH PATH ============
  Widget _buildGrowthPathTab(Map<String, dynamic> emp) {
    final predictive = emp['predictiveInsights'] as Map<String, dynamic>;
    final roadmap = emp['developmentRoadmap'] as List<Map<String, dynamic>>;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.purple[50]!, Colors.blue[50]!]),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.purple[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Career Trajectory', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  '🚀 ${predictive['nextCareerPath']}',
                  style: TextStyle(fontSize: 12, color: Colors.purple[700], fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Promotion Readiness: ${predictive['promotionReadiness']}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    Text('Retention Score: ${predictive['retentionScore']}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Skill Gaps for Advancement', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          ...(predictive['skillGapsForPromotion'] as List<String>)
              .map((skill) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, size: 16, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(skill, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  )),
          const SizedBox(height: 20),
          const Text('Development Roadmap', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 12),
          ...roadmap.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item['priority'] == 'High' ? Colors.red[100] : Colors.blue[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(child: Text(item['q'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['action'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                            Text(item['priority'] as String, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // ============ TAB 6: FEEDBACK ============
  Widget _buildFeedbackTab(Map<String, dynamic> emp) {
    final pulse = emp['feedbackPulse'] as List<Map<String, dynamic>>;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: pulse
            .map((fb) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: fb['sentiment'] == 'Positive' ? Colors.green[50] : Colors.orange[50],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          fb['sentiment'] == 'Positive' ? Icons.check_circle : Icons.info,
                          color: fb['sentiment'] == 'Positive' ? Colors.green : Colors.orange,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fb['category'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                              Text(fb['sentiment'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Text(fb['date'] as String, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ============ HELPERS ============
  Widget _buildBulletPoint(String title, String content, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: color)),
          const SizedBox(height: 6),
          Text(content, style: TextStyle(fontSize: 11, color: Colors.grey[700], height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            const SizedBox(height: 6),
            Text(content, style: TextStyle(fontSize: 11, color: Colors.grey[700], height: 1.4)),
          ],
        ),
      ),
    );
  }
}
