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

  // Sample feedback submissions from feedback_screen
  final List<Map<String, dynamic>> _feedbackSubmissions = [
    {
      'employeeName': 'Dr. Rajesh Mehta',
      'feedbackType': 'Positive',
      'category': 'Clinical Excellence',
      'details': 'Outstanding diagnostic accuracy in complex cardiac cases. Exceptional patient outcomes this quarter.',
      'rating': 5,
      'submittedBy': 'Dr. Priya Sharma',
      'date': 'Jun 10, 2026',
    },
    {
      'employeeName': 'Dr. Rajesh Mehta',
      'feedbackType': 'Positive',
      'category': 'Team Collaboration',
      'details': 'Excellent mentor for junior residents. Demonstrates patience and clear communication.',
      'rating': 5,
      'submittedBy': 'Dr. Priya Sharma',
      'date': 'Jun 5, 2026',
    },
    {
      'employeeName': 'Dr. Rajesh Mehta',
      'feedbackType': 'Constructive',
      'category': 'Documentation',
      'details': 'Documentation needs improvement. Sometimes delayed in updating patient records.',
      'rating': 3,
      'submittedBy': 'Dr. Priya Sharma',
      'date': 'May 28, 2026',
    },
    {
      'employeeName': 'Dr. Sarah Mitchell',
      'feedbackType': 'Positive',
      'category': 'Leadership',
      'details': 'Visionary leader. Successfully launched cardiac unit ahead of schedule. Inspires team confidence.',
      'rating': 5,
      'submittedBy': 'Hospital Director',
      'date': 'Jun 12, 2026',
    },
    {
      'employeeName': 'Dr. Sarah Mitchell',
      'feedbackType': 'Positive',
      'category': 'Strategic Vision',
      'details': 'Champion of innovation. Pushing organization toward digital transformation effectively.',
      'rating': 5,
      'submittedBy': 'Hospital Director',
      'date': 'Jun 8, 2026',
    },
    {
      'employeeName': 'Dr. Sarah Mitchell',
      'feedbackType': 'Positive',
      'category': 'Team Development',
      'details': 'Exceptional mentorship. Has developed 8+ staff members for advancement. Strong bench strength.',
      'rating': 5,
      'submittedBy': 'Hospital Director',
      'date': 'May 30, 2026',
    },
    {
      'employeeName': 'RN. Emily Rodriguez',
      'feedbackType': 'Positive',
      'category': 'Patient Safety',
      'details': 'Maintains highest safety standards in OR. Zero incidents under her coordination this quarter.',
      'rating': 5,
      'submittedBy': 'OR Supervisor',
      'date': 'Jun 9, 2026',
    },
    {
      'employeeName': 'RN. Emily Rodriguez',
      'feedbackType': 'Positive',
      'category': 'Team Coordination',
      'details': 'Excellent surgical team leader. Handles complex multi-department coordination seamlessly.',
      'rating': 5,
      'submittedBy': 'OR Supervisor',
      'date': 'Jun 1, 2026',
    },
    {
      'employeeName': 'RN. Emily Rodriguez',
      'feedbackType': 'Positive',
      'category': 'Clinical Skills',
      'details': 'Advanced surgical nursing expertise. Consistently delivers high-quality patient care.',
      'rating': 4,
      'submittedBy': 'OR Supervisor',
      'date': 'May 25, 2026',
    },
    {
      'employeeName': 'Dr. James Anderson',
      'feedbackType': 'Positive',
      'category': 'Clinical Skills',
      'details': 'Strong clinical expertise in interventional cardiology. Excellent technical skills.',
      'rating': 5,
      'submittedBy': 'Cardiology Head',
      'date': 'Jun 7, 2026',
    },
    {
      'employeeName': 'Dr. James Anderson',
      'feedbackType': 'Constructive',
      'category': 'Team Collaboration',
      'details': 'Could improve collaboration on research initiatives. Prefers working independently.',
      'rating': 3,
      'submittedBy': 'Cardiology Head',
      'date': 'May 22, 2026',
    },
    {
      'employeeName': 'Dr. James Anderson',
      'feedbackType': 'Constructive',
      'category': 'Innovation',
      'details': 'Slower to adopt new technologies. Prefers traditional methods. Needs upskilling in digital tools.',
      'rating': 2,
      'submittedBy': 'Cardiology Head',
      'date': 'May 10, 2026',
    },
  ];

  // Calculate review metrics based on feedback
  Map<String, dynamic> _calculateReviewMetrics(String employeeName) {
    final employeeFeedback = _feedbackSubmissions
        .where((f) => f['employeeName'] == employeeName)
        .toList();

    if (employeeFeedback.isEmpty) {
      return {'score': 0.0, 'sentiment': 'No Data', 'sentimentScore': 0};
    }

    final positive = employeeFeedback.where((f) => f['feedbackType'] == 'Positive').length;
    final constructive = employeeFeedback.where((f) => f['feedbackType'] == 'Constructive').length;
    final avgRating = employeeFeedback.fold<double>(0, (sum, f) => sum + (f['rating'] as int)) / employeeFeedback.length;

    final sentimentScore = ((positive / employeeFeedback.length) * 100).toInt();
    final sentiment = sentimentScore > 75
        ? 'Positive'
        : sentimentScore > 50
            ? 'Neutral'
            : 'Needs Improvement';

    return {
      'score': avgRating,
      'sentiment': sentiment,
      'sentimentScore': sentimentScore,
      'totalFeedback': employeeFeedback.length,
      'positiveFeedback': positive,
      'constructiveFeedback': constructive,
    };
  }

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
      'overallScore': 4.3,
      'performanceLevel': 'Exceeds Expectations',
      'compareTo': 'Department Avg: 4.1',
      'competencies': [
        {'name': 'Clinical Excellence', 'score': 5, 'weight': 25, 'benchmark': 4.2, 'trend': '↑'},
        {'name': 'Team Collaboration', 'score': 5, 'weight': 25, 'benchmark': 4.3, 'trend': '↑'},
        {'name': 'Mentoring', 'score': 5, 'weight': 20, 'benchmark': 4.0, 'trend': '↑'},
        {'name': 'Patient Care', 'score': 4, 'weight': 15, 'benchmark': 3.8, 'trend': '→'},
        {'name': 'Documentation', 'score': 3, 'weight': 15, 'benchmark': 3.5, 'trend': '↓'},
      ],
      'aiInsights': {
        'sentiment': 'Positive',
        'sentimentScore': 67,
        'communication': 'Clear communicator with excellent clinical insights',
        'collaboration': 'Strong mentor, patiently develops junior talent',
        'reliability': 'Consistent performer with high accuracy rates',
        'adaptability': 'Receptive to feedback, eager to improve documentation',
      },
      'skillVelocity': [
        {'skill': 'Diagnostic Accuracy', 'growth': 12, 'trajectory': 'Ascending'},
        {'skill': 'Mentoring', 'growth': 18, 'trajectory': 'Ascending'},
        {'skill': 'Patient Communication', 'growth': 8, 'trajectory': 'Stable'},
        {'skill': 'Documentation', 'growth': -5, 'trajectory': 'Descending'},
      ],
      'objectives': [
        {'goal': 'Publish 2 research papers', 'status': 'In Progress', 'progress': 50, 'dueDate': '30-Sep-2026'},
        {'goal': 'Improve documentation processes', 'status': 'In Progress', 'progress': 40, 'dueDate': '31-Aug-2026'},
        {'goal': 'Mentor 2 junior residents', 'status': 'Completed', 'progress': 100, 'dueDate': '30-Jun-2026'},
      ],
      'peerBenchmark': {'yourRank': '3rd', 'totalPeers': 12, 'percentile': 82, 'topQuartile': true},
      'engagementMetrics': {'teamSentiment': 92, 'cultureFit': 88, 'leadershipReady': 80, 'retentionRisk': 6},
      'strengths': ['Outstanding diagnostic accuracy in complex cardiac cases', 'Excellent mentor with patience for junior residents', 'Strong clinical decision-making', 'Positive influence on team morale'],
      'development': ['Improve timeliness of patient record documentation', 'Enhance research publication efforts'],
      'predictiveInsights': {'promotionReadiness': 92, 'leadershipPotential': 'Very High', 'retentionScore': 95, 'nextCareerPath': 'Department Head in 2-3 years', 'skillGapsForPromotion': ['Executive leadership', 'Strategic planning']},
      'developmentRoadmap': [
        {'q': 'Q3 2026', 'action': 'Executive Leadership Workshop', 'priority': 'High'},
        {'q': 'Q4 2026', 'action': 'MBA in Healthcare Management', 'priority': 'High'},
        {'q': 'Q1 2027', 'action': 'Lead Strategic Initiative', 'priority': 'Medium'},
        {'q': 'Q2 2027', 'action': 'Department Head Shadowing', 'priority': 'High'},
      ],
      'feedbackPulse': [
        {'date': 'Jun 10', 'sentiment': 'Positive', 'category': 'Clinical Excellence'},
        {'date': 'Jun 5', 'sentiment': 'Positive', 'category': 'Mentoring'},
        {'date': 'May 28', 'sentiment': 'Constructive', 'category': 'Documentation'},
        {'date': 'May 15', 'sentiment': 'Positive', 'category': 'Collaboration'},
      ],
      'trendData': [
        {'month': 'Jan', 'score': 4.1},
        {'month': 'Feb', 'score': 4.2},
        {'month': 'Mar', 'score': 4.3},
        {'month': 'Apr', 'score': 4.4},
        {'month': 'May', 'score': 4.5},
        {'month': 'Jun', 'score': 4.5},
      ],
    },
    {
      'name': 'Dr. Sarah Mitchell',
      'role': 'Chief Medical Officer',
      'dept': 'Clinical',
      'tenure': '15 years',
      'profileImage': '👩‍⚕️',
      'cycle': 'Q2 2026',
      'reviewerName': 'Hospital Director',
      'status': 'Approved',
      'overallScore': 4.7,
      'performanceLevel': 'Exceeds Expectations',
      'compareTo': 'Department Avg: 4.1',
      'competencies': [
        {'name': 'Leadership', 'score': 5, 'weight': 25, 'benchmark': 4.2, 'trend': '↑'},
        {'name': 'Strategic Vision', 'score': 5, 'weight': 25, 'benchmark': 4.3, 'trend': '↑'},
        {'name': 'Team Development', 'score': 5, 'weight': 20, 'benchmark': 4.0, 'trend': '↑'},
        {'name': 'Organizational Impact', 'score': 5, 'weight': 15, 'benchmark': 3.8, 'trend': '↑'},
        {'name': 'Change Management', 'score': 5, 'weight': 15, 'benchmark': 3.5, 'trend': '↑'},
      ],
      'aiInsights': {
        'sentiment': 'Positive',
        'sentimentScore': 100,
        'communication': 'Visionary leader with inspiring communication style',
        'collaboration': 'Exceptional team builder, developed 8+ staff for advancement',
        'reliability': '99.2% attendance, exceeds all organizational goals',
        'adaptability': 'Innovation champion, successfully drives organizational transformation',
      },
      'skillVelocity': [
        {'skill': 'Strategic Planning', 'growth': 22, 'trajectory': 'Ascending'},
        {'skill': 'Team Leadership', 'growth': 25, 'trajectory': 'Ascending'},
        {'skill': 'Digital Transformation', 'growth': 20, 'trajectory': 'Ascending'},
        {'skill': 'Executive Presence', 'growth': 18, 'trajectory': 'Ascending'},
      ],
      'objectives': [
        {'goal': 'Successfully launch cardiac unit ahead of schedule', 'status': 'Completed', 'progress': 100, 'dueDate': '30-May-2026'},
        {'goal': 'Implement digital health initiatives', 'status': 'In Progress', 'progress': 85, 'dueDate': '31-Dec-2026'},
        {'goal': 'Develop succession pipeline', 'status': 'In Progress', 'progress': 90, 'dueDate': '30-Aug-2026'},
      ],
      'peerBenchmark': {'yourRank': '1st', 'totalPeers': 12, 'percentile': 99, 'topQuartile': true},
      'engagementMetrics': {'teamSentiment': 98, 'cultureFit': 97, 'leadershipReady': 96, 'retentionRisk': 1},
      'strengths': ['Visionary leadership inspiring organizational transformation', 'Exceptional track record developing leaders', 'Successfully launched cardiac unit ahead of schedule', 'Strategic innovator pushing digital adoption'],
      'development': ['Work-life balance management', 'Mentoring external healthcare leaders'],
      'predictiveInsights': {'promotionReadiness': 98, 'leadershipPotential': 'Executive Ready', 'retentionScore': 98, 'nextCareerPath': 'Hospital Director potential', 'skillGapsForPromotion': ['None identified']},
      'developmentRoadmap': [
        {'q': 'Q3 2026', 'action': 'Executive Board Leadership Course', 'priority': 'High'},
        {'q': 'Q4 2026', 'action': 'Healthcare Economics Certification', 'priority': 'Medium'},
      ],
      'feedbackPulse': [
        {'date': 'Jun 12', 'sentiment': 'Positive', 'category': 'Leadership'},
        {'date': 'Jun 8', 'sentiment': 'Positive', 'category': 'Strategic Vision'},
        {'date': 'May 30', 'sentiment': 'Positive', 'category': 'Team Development'},
      ],
      'trendData': [
        {'month': 'Jan', 'score': 4.6},
        {'month': 'Feb', 'score': 4.7},
        {'month': 'Mar', 'score': 4.7},
        {'month': 'Apr', 'score': 4.8},
        {'month': 'May', 'score': 4.8},
        {'month': 'Jun', 'score': 4.8},
      ],
    },
    {
      'name': 'RN. Emily Rodriguez',
      'role': 'Charge Nurse',
      'dept': 'OR',
      'tenure': '10 years',
      'profileImage': '👩‍⚕️',
      'cycle': 'Q2 2026',
      'reviewerName': 'OR Supervisor',
      'status': 'Approved',
      'overallScore': 4.7,
      'performanceLevel': 'Exceeds Expectations',
      'compareTo': 'Department Avg: 4.0',
      'competencies': [
        {'name': 'Patient Safety', 'score': 5, 'weight': 25, 'benchmark': 4.2, 'trend': '↑'},
        {'name': 'Team Coordination', 'score': 5, 'weight': 25, 'benchmark': 4.3, 'trend': '↑'},
        {'name': 'Clinical Skills', 'score': 4, 'weight': 20, 'benchmark': 4.0, 'trend': '→'},
        {'name': 'Surgical Expertise', 'score': 5, 'weight': 15, 'benchmark': 3.8, 'trend': '↑'},
        {'name': 'Leadership', 'score': 4, 'weight': 15, 'benchmark': 3.5, 'trend': '↑'},
      ],
      'aiInsights': {
        'sentiment': 'Positive',
        'sentimentScore': 100,
        'communication': 'Efficient communicator, commands respect in OR',
        'collaboration': 'Seamless multi-department coordination under pressure',
        'reliability': '98% attendance, zero incidents this quarter',
        'adaptability': 'Highly adaptable to complex surgical procedures',
      },
      'skillVelocity': [
        {'skill': 'Surgical Safety Protocols', 'growth': 18, 'trajectory': 'Ascending'},
        {'skill': 'Team Leadership', 'growth': 16, 'trajectory': 'Ascending'},
        {'skill': 'Patient Care Quality', 'growth': 14, 'trajectory': 'Ascending'},
        {'skill': 'Complex Case Management', 'growth': 12, 'trajectory': 'Ascending'},
      ],
      'objectives': [
        {'goal': 'Maintain zero surgical incidents', 'status': 'Completed', 'progress': 100, 'dueDate': '30-Jun-2026'},
        {'goal': 'Advanced surgical nursing certification', 'status': 'In Progress', 'progress': 75, 'dueDate': '31-Oct-2026'},
        {'goal': 'Lead OR safety initiatives', 'status': 'In Progress', 'progress': 85, 'dueDate': '30-Sep-2026'},
      ],
      'peerBenchmark': {'yourRank': '2nd', 'totalPeers': 10, 'percentile': 92, 'topQuartile': true},
      'engagementMetrics': {'teamSentiment': 95, 'cultureFit': 93, 'leadershipReady': 87, 'retentionRisk': 4},
      'strengths': ['Maintains highest safety standards with zero incidents', 'Excellent surgical team leadership and coordination', 'Advanced surgical nursing expertise', 'Strong patient care quality'],
      'development': ['Formal supervisory leadership training', 'Research publication in surgical nursing'],
      'predictiveInsights': {'promotionReadiness': 85, 'leadershipPotential': 'High', 'retentionScore': 92, 'nextCareerPath': 'Senior OR Charge Nurse in 2 years', 'skillGapsForPromotion': ['Formal management training']},
      'developmentRoadmap': [
        {'q': 'Q3 2026', 'action': 'Nursing Leadership Certificate', 'priority': 'High'},
        {'q': 'Q4 2026', 'action': 'Advanced Surgical Certification', 'priority': 'High'},
      ],
      'feedbackPulse': [
        {'date': 'Jun 9', 'sentiment': 'Positive', 'category': 'Patient Safety'},
        {'date': 'Jun 1', 'sentiment': 'Positive', 'category': 'Team Coordination'},
        {'date': 'May 25', 'sentiment': 'Positive', 'category': 'Clinical Skills'},
      ],
      'trendData': [
        {'month': 'Jan', 'score': 4.2},
        {'month': 'Feb', 'score': 4.3},
        {'month': 'Mar', 'score': 4.4},
        {'month': 'Apr', 'score': 4.5},
        {'month': 'May', 'score': 4.6},
        {'month': 'Jun', 'score': 4.6},
      ],
    },
    {
      'name': 'Dr. James Anderson',
      'role': 'Senior Cardiologist',
      'dept': 'Cardiac Care',
      'tenure': '18 years',
      'profileImage': '👨‍⚕️',
      'cycle': 'Q2 2026',
      'reviewerName': 'Cardiology Head',
      'status': 'Pending',
      'overallScore': 3.7,
      'performanceLevel': 'Meets Expectations',
      'compareTo': 'Department Avg: 4.1',
      'competencies': [
        {'name': 'Clinical Skills', 'score': 5, 'weight': 25, 'benchmark': 4.2, 'trend': '↑'},
        {'name': 'Interventional Expertise', 'score': 5, 'weight': 25, 'benchmark': 4.3, 'trend': '→'},
        {'name': 'Team Collaboration', 'score': 3, 'weight': 20, 'benchmark': 4.0, 'trend': '↓'},
        {'name': 'Innovation Adoption', 'score': 2, 'weight': 15, 'benchmark': 3.8, 'trend': '↓'},
        {'name': 'Digital Competency', 'score': 2, 'weight': 15, 'benchmark': 3.5, 'trend': '↓'},
      ],
      'aiInsights': {
        'sentiment': 'Neutral',
        'sentimentScore': 33,
        'communication': 'Technical communicator, prefers independent work',
        'collaboration': 'Works independently, limited research collaboration',
        'reliability': '96% attendance, meets technical requirements',
        'adaptability': 'Resistance to new technologies and modern methods',
      },
      'skillVelocity': [
        {'skill': 'Interventional Cardiology', 'growth': 5, 'trajectory': 'Stable'},
        {'skill': 'Patient Outcomes', 'growth': 3, 'trajectory': 'Stable'},
        {'skill': 'Digital Tool Adoption', 'growth': -8, 'trajectory': 'Descending'},
        {'skill': 'Collaborative Research', 'growth': -3, 'trajectory': 'Descending'},
      ],
      'objectives': [
        {'goal': 'Complete interventional procedures', 'status': 'Completed', 'progress': 100, 'dueDate': '30-Jun-2026'},
        {'goal': 'Adopt new diagnostic technologies', 'status': 'Not Started', 'progress': 15, 'dueDate': '30-Oct-2026'},
        {'goal': 'Collaborate on research initiatives', 'status': 'Not Started', 'progress': 10, 'dueDate': '31-Dec-2026'},
      ],
      'peerBenchmark': {'yourRank': '9th', 'totalPeers': 12, 'percentile': 55, 'topQuartile': false},
      'engagementMetrics': {'teamSentiment': 62, 'cultureFit': 58, 'leadershipReady': 45, 'retentionRisk': 35},
      'strengths': ['Strong technical expertise in interventional cardiology', 'Excellent patient outcomes in specialized procedures', 'Reliable clinical performer', 'Deep clinical knowledge'],
      'development': ['Improve team collaboration on research', 'Embrace digital health technologies and tools', 'Increase openness to innovative treatment approaches'],
      'predictiveInsights': {'promotionReadiness': 62, 'leadershipPotential': 'Moderate', 'retentionScore': 70, 'nextCareerPath': 'Specialist consultant role', 'skillGapsForPromotion': ['Leadership training', 'Innovation mindset', 'Digital transformation']},
      'developmentRoadmap': [
        {'q': 'Q3 2026', 'action': 'Innovation in Healthcare Workshop', 'priority': 'High'},
        {'q': 'Q4 2026', 'action': 'Digital Health Certification', 'priority': 'High'},
      ],
      'feedbackPulse': [
        {'date': 'Jun 7', 'sentiment': 'Positive', 'category': 'Clinical Skills'},
        {'date': 'May 22', 'sentiment': 'Constructive', 'category': 'Team Collaboration'},
        {'date': 'May 10', 'sentiment': 'Constructive', 'category': 'Innovation'},
      ],
      'trendData': [
        {'month': 'Jan', 'score': 4.4},
        {'month': 'Feb', 'score': 4.4},
        {'month': 'Mar', 'score': 4.4},
        {'month': 'Apr', 'score': 4.4},
        {'month': 'May', 'score': 4.4},
        {'month': 'Jun', 'score': 4.4},
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
        title: const Text('Advanced Performance Reviews', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white, letterSpacing: 0.3)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF1A237E),
        toolbarHeight: 56,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // EMPLOYEE SELECTOR - Horizontal Scrollable List
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.grey[100],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: List.generate(
                    _employees.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _selectedEmployeeIndex = index;
                          _tabController.animateTo(0);
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedEmployeeIndex == index ? const Color(0xFF1A237E) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedEmployeeIndex == index ? const Color(0xFF1A237E) : Colors.grey[300]!,
                              width: 2,
                            ),
                            boxShadow: _selectedEmployeeIndex == index
                                ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8)]
                                : [],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _employees[index]['profileImage'] as String,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (_employees[index]['name'] as String).split(' ')[0],
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: _selectedEmployeeIndex == index ? Colors.white : Colors.grey[800],
                                ),
                              ),
                              Text(
                                (_employees[index]['name'] as String).split(' ').last,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: _selectedEmployeeIndex == index ? Colors.white70 : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

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
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue[200]!, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Center(child: Text(emp['profileImage'] as String, style: const TextStyle(fontSize: 38))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emp['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white, letterSpacing: 0.2),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${emp['role']} • ${emp['dept']}',
                      style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.87), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${emp['tenure']} tenure',
                      style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.75), fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: emp['status'] == 'Approved' ? Colors.green[400] : Colors.orange[400],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Text(
                  emp['status'] as String,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Classic Overall Score (Centered, Professional)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Score',
                        style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${emp['overallScore']}/5.0',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: Colors.white, letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        emp['performanceLevel'] as String,
                        style: const TextStyle(fontSize: 12, color: Colors.greenAccent, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                ),
                Container(width: 1.5, height: 80, color: Colors.white.withOpacity(0.15), margin: const EdgeInsets.symmetric(horizontal: 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ranking',
                        style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '${emp['peerBenchmark']['yourRank']}',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.amber, letterSpacing: -0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'of ${emp['peerBenchmark']['totalPeers']}',
                            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${emp['peerBenchmark']['percentile']}th percentile',
                        style: const TextStyle(fontSize: 12, color: Colors.cyanAccent, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                      ),
                    ],
                  ),
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
    final employeeName = emp['name'] as String;
    final metrics = _calculateReviewMetrics(employeeName);
    final sentimentScore = metrics['sentimentScore'] as int;
    final sentiment = metrics['sentiment'] as String;

    // Generate insights from actual feedback
    final employeeFeedback = _feedbackSubmissions
        .where((f) => f['employeeName'] == employeeName)
        .toList();

    final positiveFeedbackItems = employeeFeedback
        .where((f) => f['feedbackType'] == 'Positive')
        .map((f) => f['details'] as String)
        .toList();

    final constructiveItems = employeeFeedback
        .where((f) => f['feedbackType'] == 'Constructive')
        .map((f) => f['details'] as String)
        .toList();

    if (employeeFeedback.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.analytics_outlined, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text('No feedback data available for analysis', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main AI Sentiment Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: sentiment == 'Positive'
                    ? [Colors.green[400]!, Colors.green[600]!]
                    : sentiment == 'Neutral'
                        ? [Colors.blue[400]!, Colors.blue[600]!]
                        : [Colors.orange[400]!, Colors.orange[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('🤖', style: TextStyle(fontSize: 32))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Feedback-Based AI Analysis',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Derived from ${metrics['totalFeedback']} feedback submissions',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overall Sentiment',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            sentiment,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$sentimentScore%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Positive',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Feedback Themes Section
          const Text(
            'Key Feedback Themes',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.3),
          ),
          const SizedBox(height: 12),

          if (positiveFeedbackItems.isNotEmpty)
            _buildAdvancedInsightCard(
              icon: '✅',
              title: 'Positive Feedback Themes',
              content: positiveFeedbackItems.take(2).join(' • '),
              color: Colors.green,
              badges: _extractBadges(employeeFeedback.where((f) => f['feedbackType'] == 'Positive').toList()),
            ),

          if (constructiveItems.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildAdvancedInsightCard(
              icon: '📝',
              title: 'Development Areas',
              content: constructiveItems.take(2).join(' • '),
              color: Colors.orange,
              badges: _extractBadges(employeeFeedback.where((f) => f['feedbackType'] == 'Constructive').toList()),
            ),
          ],

          const SizedBox(height: 24),

          // Feedback Statistics
          const Text(
            'Feedback Distribution',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.3),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildMetricRow('Positive Feedback', metrics['positiveFeedback'] as int, Colors.green,
                    maxValue: metrics['totalFeedback'] as int),
                const SizedBox(height: 12),
                _buildMetricRow('Constructive Feedback', metrics['constructiveFeedback'] as int, Colors.orange,
                    maxValue: metrics['totalFeedback'] as int),
              ],
            ),
          ),
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
    final employeeName = emp['name'] as String;
    final employeeFeedback = _feedbackSubmissions
        .where((f) => f['employeeName'] == employeeName)
        .toList();

    if (employeeFeedback.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.comment_outlined, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text('No feedback submitted yet', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
        ),
      );
    }

    final metrics = _calculateReviewMetrics(employeeName);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feedback Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Total Feedback', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text('${metrics['totalFeedback']}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                  ],
                ),
                Container(width: 1, height: 50, color: Colors.blue[200]),
                Column(
                  children: [
                    Text('Positive', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(
                      '${metrics['positiveFeedback']}',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.green[700]),
                    ),
                  ],
                ),
                Container(width: 1, height: 50, color: Colors.blue[200]),
                Column(
                  children: [
                    Text('Constructive', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(
                      '${metrics['constructiveFeedback']}',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.orange[700]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('Feedback Entries', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),

          // Individual Feedback Items
          ...employeeFeedback.map((fb) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                    color: fb['feedbackType'] == 'Positive' ? Colors.green[50] : Colors.orange[50],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fb['category'] as String,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'By ${fb['submittedBy']}',
                                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: fb['feedbackType'] == 'Positive'
                                  ? Colors.green[200]
                                  : Colors.orange[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              fb['feedbackType'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: fb['feedbackType'] == 'Positive'
                                    ? Colors.green[800]
                                    : Colors.orange[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        fb['details'] as String,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.5),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (i) => Icon(
                                  Icons.star,
                                  size: 14,
                                  color: i < (fb['rating'] as int) ? Colors.amber : Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            fb['date'] as String,
                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
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

  Widget _buildAdvancedInsightCard({
    required String icon,
    required String title,
    required String content,
    required Color color,
    required List<String> badges,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon and Title
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '✓ Strong',
                    style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Content Text
            Text(
              content,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),

            // Badges
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: badges
                  .map((badge) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 10,
                            color: color.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, int value, Color color, {bool inverted = false, int maxValue = 100}) {
    final displayValue = inverted ? maxValue - value : value;
    final percentage = (displayValue / maxValue * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            Text(
              '$displayValue/$maxValue',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: displayValue / maxValue,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  List<String> _extractBadges(List<Map<String, dynamic>> feedbackItems) {
    final badges = <String>{};
    for (var item in feedbackItems) {
      final category = item['category'] as String;
      if (category.isNotEmpty) {
        badges.add(category);
      }
    }
    return badges.toList().take(3).toList();
  }
}
