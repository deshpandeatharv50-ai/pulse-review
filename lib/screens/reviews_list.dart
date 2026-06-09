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
                      onPressed: () {},
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
                      onPressed: () {},
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
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ReviewsAdvancedClassic(),
                  ),
                );
              },
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
}
