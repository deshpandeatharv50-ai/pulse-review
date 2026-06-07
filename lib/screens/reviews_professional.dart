import 'package:flutter/material.dart';
import '../models/review.dart';

// PROFESSIONAL HOSPITAL REVIEWS - Enterprise-grade performance appraisal system
class ReviewsProfessional extends StatefulWidget {
  const ReviewsProfessional({Key? key}) : super(key: key);

  @override
  State<ReviewsProfessional> createState() => _ReviewsProfessionalState();
}

class _ReviewsProfessionalState extends State<ReviewsProfessional> {
  int _selectedReviewIndex = 0;

  final List<Map<String, dynamic>> _reviews = [
    {
      'employeeName': 'Dr. Rajesh Mehta',
      'designation': 'Consultant Cardiologist',
      'department': 'Cardiology',
      'reviewCycle': 'Q2 2026',
      'reviewDate': '15 Jun 2026',
      'period': 'Apr 1 - Jun 15, 2026',
      'status': 'Approved',
      'statusColor': Colors.green,
      'overallRating': 4.5,
      'reviewerName': 'Dr. Priya Sharma',
      'reviewerRole': 'Department Head',
      'competencies': [
        {'name': 'Clinical Excellence', 'rating': 5, 'weightage': '25%'},
        {'name': 'Patient Care', 'rating': 5, 'weightage': '25%'},
        {'name': 'Team Collaboration', 'rating': 4, 'weightage': '20%'},
        {'name': 'Communication Skills', 'rating': 4, 'weightage': '15%'},
        {'name': 'Professional Development', 'rating': 4, 'weightage': '15%'},
      ],
      'strengths': [
        'Exceptional diagnostic accuracy with 98% accuracy rate',
        'Strong mentoring skills - trains junior residents effectively',
        'Excellent patient outcomes - mortality rate 2% below department average',
        'Proactive in adopting new clinical protocols',
      ],
      'developmentAreas': [
        'Enhance documentation timeliness (currently 85%, target 95%)',
        'Increase participation in departmental committees',
      ],
      'goals': [
        {'title': 'Publish 2 clinical research papers', 'status': 'In Progress', 'progress': 50},
        {'title': 'Complete Advanced Echocardiography certification', 'status': 'In Progress', 'progress': 75},
        {'title': 'Mentor 2 junior residents', 'status': 'Completed', 'progress': 100},
      ],
      'previousReviews': [
        {'cycle': 'Q1 2026', 'rating': 4.3, 'date': '15 Mar 2026'},
        {'cycle': 'Q4 2025', 'rating': 4.4, 'date': '15 Dec 2025'},
        {'cycle': 'Annual 2025', 'rating': 4.5, 'date': '30 Nov 2025'},
      ],
    },
    {
      'employeeName': 'Sarah Chen',
      'designation': 'Senior Nurse Practitioner',
      'department': 'Emergency Medicine',
      'reviewCycle': 'Q2 2026',
      'reviewDate': '10 Jun 2026',
      'period': 'Apr 1 - Jun 15, 2026',
      'status': 'Submitted',
      'statusColor': Colors.orange,
      'overallRating': 4.2,
      'reviewerName': 'Dr. James Peterson',
      'reviewerRole': 'Department Head',
      'competencies': [
        {'name': 'Clinical Competence', 'rating': 4, 'weightage': '25%'},
        {'name': 'Patient Safety', 'rating': 5, 'weightage': '25%'},
        {'name': 'Teamwork', 'rating': 4, 'weightage': '20%'},
        {'name': 'Professionalism', 'rating': 4, 'weightage': '15%'},
        {'name': 'Continuous Learning', 'rating': 4, 'weightage': '15%'},
      ],
      'strengths': [
        'Exceptional patient safety record - zero adverse incidents',
        'Quick decision-making under high pressure',
        'Excellent communication with patients and families',
      ],
      'developmentAreas': [
        'Expand knowledge in latest emergency protocols',
        'Develop leadership skills for potential supervisor role',
      ],
      'goals': [
        {'title': 'Complete Critical Care certification', 'status': 'In Progress', 'progress': 60},
        {'title': 'Lead 1 quality improvement project', 'status': 'In Progress', 'progress': 40},
      ],
      'previousReviews': [
        {'cycle': 'Q1 2026', 'rating': 4.1, 'date': '15 Mar 2026'},
        {'cycle': 'Annual 2025', 'rating': 4.3, 'date': '30 Nov 2025'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final review = _reviews[_selectedReviewIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Reviews', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        automaticallyImplyLeading: false,
        elevation: 2,
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Review Selector
            _buildReviewSelector(review),
            const SizedBox(height: 24),

            // Header - Employee Info & Status
            _buildReviewHeader(review),
            const SizedBox(height: 24),

            // Overall Rating
            _buildOverallRating(review),
            const SizedBox(height: 24),

            // Competency Assessment
            _buildCompetencies(review),
            const SizedBox(height: 24),

            // Strengths
            _buildSection('💪 Strengths', review['strengths'] as List<String>, Colors.green),
            const SizedBox(height: 20),

            // Development Areas
            _buildSection('🎯 Development Areas', review['developmentAreas'] as List<String>, Colors.orange),
            const SizedBox(height: 20),

            // Goals Progress
            _buildGoalsProgress(review),
            const SizedBox(height: 20),

            // Review History Timeline
            _buildReviewHistory(review),
            const SizedBox(height: 20),

            // Reviewer Info
            _buildReviewerInfo(review),
            const SizedBox(height: 20),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSelector(Map<String, dynamic> review) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_reviews.length, (index) {
          final isSelected = index == _selectedReviewIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedReviewIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[600] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _reviews[index]['employeeName'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      _reviews[index]['designation'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildReviewHeader(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['employeeName'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${review['designation']} • ${review['department']}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (review['statusColor'] as Color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: review['statusColor'] as Color),
                ),
                child: Text(
                  review['status'] as String,
                  style: TextStyle(fontWeight: FontWeight.w700, color: review['statusColor'] as Color, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Review Cycle', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  Text(review['reviewCycle'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Review Date', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  Text(review['reviewDate'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Period', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  Text(review['period'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverallRating(Map<String, dynamic> review) {
    final rating = review['overallRating'] as double;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green[50]!, Colors.blue[50]!],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Overall Performance Rating', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('${rating.toStringAsFixed(1)}/5.0', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 28, color: Colors.green)),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating.toInt() ? Icons.star : Icons.star_half,
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                      Text(_getRatingLabel(rating), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Performance Status', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Exceeds Expectations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompetencies(Map<String, dynamic> review) {
    final competencies = review['competencies'] as List<Map<String, dynamic>>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Core Competencies Assessment', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 12),
        ...competencies.map((comp) {
          final rating = comp['rating'] as int;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(comp['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    Text('${comp['weightage']}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: rating / 5.0,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            rating >= 4 ? Colors.green : rating >= 3 ? Colors.orange : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: accentColor)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: accentColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle, color: accentColor, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(item, style: TextStyle(fontSize: 12, color: Colors.grey[800], height: 1.4)),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsProgress(Map<String, dynamic> review) {
    final goals = review['goals'] as List<Map<String, dynamic>>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Performance Goals & Objectives', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 12),
        ...goals.map((goal) {
          final progress = goal['progress'] as int;
          final isCompleted = goal['status'] == 'Completed';
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(goal['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.green[100] : Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          goal['status'] as String,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isCompleted ? Colors.green[700] : Colors.blue[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(isCompleted ? Colors.green : Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('$progress% complete', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReviewHistory(Map<String, dynamic> review) {
    final history = review['previousReviews'] as List<Map<String, dynamic>>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Review History', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: history
                .map((h) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(h['cycle'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              Text(h['date'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                            ],
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < (h['rating'] as double).toInt() ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 14,
                              );
                            }),
                          ),
                          Text('${h['rating']}/5.0', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewerInfo(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.indigo[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.indigo[600],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reviewed By', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              Text(review['reviewerName'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(review['reviewerRole'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download),
            label: const Text('Download PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.print),
            label: const Text('Print'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  String _getRatingLabel(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4) return 'Very Good';
    if (rating >= 3) return 'Good';
    return 'Needs Improvement';
  }
}
