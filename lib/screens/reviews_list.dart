import 'package:flutter/material.dart';
import 'reviews_advanced_classic.dart';

class ReviewsList extends StatefulWidget {
  const ReviewsList({Key? key}) : super(key: key);

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  final List<Map<String, dynamic>> _reviewsData = [
    {
      'employeeName': 'Sarah Mitchell',
      'cycle': 'annual',
      'period': '2026',
      'date': 'May 30, 2026',
      'rating': 4,
      'status': 'draft',
      'type': 'Annual Review',
    },
    {
      'employeeName': 'Marcus Johnson',
      'cycle': 'annual',
      'period': 'Q4',
      'date': 'May 24, 2026',
      'rating': 3,
      'status': 'draft',
      'type': 'Annual Review',
    },
    {
      'employeeName': 'Marcus Johnson',
      'cycle': 'monthly',
      'period': 'Q3',
      'date': 'May 24, 2026',
      'rating': 3,
      'status': 'draft',
      'type': 'Monthly Review',
    },
    {
      'employeeName': 'Priya Sharma',
      'cycle': 'annual',
      'period': 'Annual',
      'date': 'May 22, 2026',
      'rating': 4,
      'status': 'draft',
      'type': 'Annual Review',
    },
    {
      'employeeName': 'Sarah Mitchell',
      'cycle': 'annual',
      'period': 'End of Year',
      'date': 'May 22, 2026',
      'rating': 4,
      'status': 'shared',
      'type': 'Annual Review',
    },
    {
      'employeeName': 'Sarah Mitchell',
      'cycle': 'monthly',
      'period': 'Q2 May',
      'date': 'May 22, 2026',
      'rating': 3,
      'status': 'shared',
      'type': 'Monthly Review',
    },
    {
      'employeeName': 'Sarah Mitchell',
      'cycle': 'quarterly',
      'period': 'February 2026',
      'date': 'Feb 28, 2026',
      'rating': 4,
      'status': 'shared',
      'type': 'Quarterly Review',
    },
    {
      'employeeName': 'Dr. Rajesh Mehta',
      'cycle': 'annual',
      'period': '2026',
      'date': 'Jun 12, 2026',
      'rating': 4,
      'status': 'draft',
      'type': 'Annual Review',
    },
    {
      'employeeName': 'RN. Emily Rodriguez',
      'cycle': 'quarterly',
      'period': 'Q2 2026',
      'date': 'Jun 15, 2026',
      'rating': 4,
      'status': 'draft',
      'type': 'Quarterly Review',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Header with Title and Action Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Performance Reviews',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                ),
                const SizedBox(height: 6),
                Text(
                  'AI-drafted review documents',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _showQuestionTemplates,
                      icon: Icon(Icons.help_outline, color: Colors.grey[700]),
                      label: Text(
                        'Question Templates',
                        style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[400]!),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showGenerateReview,
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text('Generate Review'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Reviews List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _reviewsData.length,
              itemBuilder: (context, index) {
                final review = _reviewsData[index];
                return _buildReviewCard(review, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, int index) {
    final cycleColor = _getCycleColor(review['cycle'] as String);
    final statusColor = _getStatusColor(review['status'] as String);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Employee Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['employeeName'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Cycle Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: cycleColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          review['cycle'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Period
                      Text(
                        review['period'] as String,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500),
                      ),

                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          review['status'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Star Rating
                      ...List.generate(5, (i) {
                        return Icon(
                          Icons.star,
                          size: 16,
                          color: i < (review['rating'] as int)
                              ? Colors.amber[600]
                              : Colors.grey[300],
                        );
                      }),
                      const SizedBox(width: 12),
                      // Date
                      Text(
                        review['date'] as String,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Button
            const SizedBox(width: 16),
            review['status'] == 'shared'
                ? OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ReviewsAdvancedClassic(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      side: BorderSide(color: Colors.grey[400]!),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('View', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  )
                : OutlinedButton(
                    onPressed: () => _showFinalizeDialog(review, index),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue[600],
                      side: BorderSide(color: Colors.blue[600]!, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Finalize', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
          ],
        ),
      ),
    );
  }

  Color _getCycleColor(String cycle) {
    switch (cycle.toLowerCase()) {
      case 'annual':
        return Colors.blue[500]!;
      case 'quarterly':
        return Colors.purple[500]!;
      case 'monthly':
        return Colors.orange[500]!;
      default:
        return Colors.grey[500]!;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.orange[500]!;
      case 'shared':
        return Colors.green[600]!;
      default:
        return Colors.grey[500]!;
    }
  }

  void _showQuestionTemplates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review Question Templates'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTemplateSection('Clinical Performance', [
                'What were the key clinical achievements this period?',
                'How effectively did you manage patient outcomes?',
                'Describe your approach to quality assurance.',
                'How do you stay updated with latest clinical practices?',
              ]),
              const SizedBox(height: 16),
              _buildTemplateSection('Professional Development', [
                'What certifications or training did you complete?',
                'How have you contributed to team development?',
                'What areas would you like to improve?',
                'Describe your career goals for the next year.',
              ]),
              const SizedBox(height: 16),
              _buildTemplateSection('Leadership & Collaboration', [
                'How did you contribute to team success?',
                'Describe your collaboration with other departments.',
                'What leadership qualities did you demonstrate?',
                'How do you handle feedback and challenges?',
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateSection(String title, List<String> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...questions.map((q) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontWeight: FontWeight.w700)),
              Expanded(
                child: Text(q, style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
        )),
      ],
    );
  }

  void _showGenerateReview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate New Review'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select review details to generate:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text('Employee', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: const [
                  DropdownMenuItem(value: 'rajesh', child: Text('Dr. Rajesh Mehta')),
                  DropdownMenuItem(value: 'sarah', child: Text('Dr. Sarah Mitchell')),
                  DropdownMenuItem(value: 'emily', child: Text('RN. Emily Rodriguez')),
                  DropdownMenuItem(value: 'james', child: Text('Dr. James Anderson')),
                ],
                onChanged: (_) {},
                hint: const Text('Select employee'),
              ),
              const SizedBox(height: 16),
              const Text('Review Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: const [
                  DropdownMenuItem(value: 'annual', child: Text('Annual Review')),
                  DropdownMenuItem(value: 'quarterly', child: Text('Quarterly Review')),
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly Review')),
                ],
                onChanged: (_) {},
                hint: const Text('Select review type'),
              ),
              const SizedBox(height: 16),
              const Text('Review Period', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'e.g., Q2 2026, June 2026',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✓ Review generated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check),
            label: const Text('Generate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }

  void _showFinalizeDialog(Map<String, dynamic> review, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalize & Share Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Finalize review for ${review['employeeName']}?',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'This action will:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  _buildChecklistItem('Lock the review (no more edits)'),
                  _buildChecklistItem('Mark as "Shared"'),
                  _buildChecklistItem('Send notification to employee'),
                  _buildChecklistItem('Create official record'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '⚠️ This action cannot be undone.',
              style: TextStyle(fontSize: 11, color: Colors.orange[700], fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Update review status
              _reviewsData[index]['status'] = 'shared';
              setState(() {});

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✓ ${review['employeeName']}\'s review finalized and shared!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );

              Navigator.pop(context);
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Finalize & Share'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✓ ', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
