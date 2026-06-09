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
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Performance Reviews',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI-drafted review documents',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.help_outline),
                      label: const Text('Question Templates'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Generate Review'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        foregroundColor: Colors.white,
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
    final statusBgColor = _getStatusBgColor(review['status'] as String);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
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
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Cycle Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cycleColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          review['cycle'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: cycleColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Period
                      Text(
                        review['period'] as String,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 8),

                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          review['status'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Star Rating
                      ...List.generate(5, (i) {
                        return Icon(
                          Icons.star,
                          size: 14,
                          color: i < (review['rating'] as int)
                              ? Colors.amber
                              : Colors.grey[300],
                        );
                      }),
                      const SizedBox(width: 12),
                      // Date
                      Text(
                        review['date'] as String,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ReviewsAdvancedClassic(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[600],
                side: BorderSide(color: Colors.blue[600]!),
                elevation: 0,
              ),
              child: const Text('Finalize'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCycleColor(String cycle) {
    switch (cycle.toLowerCase()) {
      case 'annual':
        return Colors.blue;
      case 'quarterly':
        return Colors.purple;
      case 'monthly':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.orange;
      case 'shared':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.orange.withOpacity(0.1);
      case 'shared':
        return Colors.green.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }
}
