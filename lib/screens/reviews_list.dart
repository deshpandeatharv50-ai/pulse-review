import 'package:flutter/material.dart';
import 'reviews_advanced_classic.dart';
import 'employee_feedback_log_screen.dart';

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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onSurface,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Performance reviews',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
            Text('AI-drafted review documents',
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          IconButton.filledTonal(
            icon: const Icon(Icons.logout_rounded, size: 18),
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
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      style: FilledButton.styleFrom(backgroundColor: scheme.error, foregroundColor: scheme.onError),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Action row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _showQuestionTemplates,
                    icon: const Icon(Icons.help_outline_rounded, size: 16),
                    label: const Text('Templates', style: TextStyle(fontWeight: FontWeight.w700)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _showGenerateReview,
                    icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                    label: const Text('Generate', style: TextStyle(fontWeight: FontWeight.w800)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
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
    final scheme = Theme.of(context).colorScheme;
    final (cycleBg, cycleFg) = _getCyclePair(review['cycle'] as String, scheme);
    final (statusBg, statusFg) = _getStatusPair(review['status'] as String, scheme);
    final initials = (review['employeeName'] as String)
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: scheme.primaryContainer,
              child: Text(initials,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: scheme.onPrimaryContainer)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['employeeName'] as String,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: scheme.onSurface),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _chip(review['cycle'] as String, cycleBg, cycleFg),
                      _chip(review['status'] as String, statusBg, statusFg),
                      Text(
                        review['period'] as String,
                        style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Builder(builder: (_) {
                    // Compute rating from actual feedback data (0-5 stars).
                    // Falls back to hardcoded rating if employee has no feedback.
                    final empName = review['employeeName'] as String;
                    final feedbackAvg = EmployeeFeedbackLogScreen.averageRating(empName);
                    final stars = feedbackAvg != null
                        ? feedbackAvg.round().clamp(0, 5)
                        : (review['rating'] as int);
                    final ratingText = feedbackAvg != null
                        ? feedbackAvg.toStringAsFixed(1)
                        : '${review['rating']}.0';
                    return Row(
                      children: [
                        ...List.generate(5, (i) {
                          return Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: i < stars
                                ? Colors.amber[700]
                                : scheme.outlineVariant,
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          ratingText,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.amber[800],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review['date'] as String,
                          style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 10),
            review['status'] == 'shared'
                ? FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ReviewsAdvancedClassic(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('View', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  )
                : FilledButton(
                    onPressed: () => _showFinalizeDialog(review, index),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Finalize', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(label.toLowerCase(),
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg, letterSpacing: 0.2)),
    );
  }

  (Color, Color) _getCyclePair(String cycle, ColorScheme scheme) {
    switch (cycle.toLowerCase()) {
      case 'annual':
        return (scheme.primaryContainer, scheme.onPrimaryContainer);
      case 'quarterly':
        return (scheme.tertiaryContainer, scheme.onTertiaryContainer);
      case 'monthly':
        return (scheme.secondaryContainer, scheme.onSecondaryContainer);
      default:
        return (scheme.surfaceContainerHighest, scheme.onSurfaceVariant);
    }
  }

  (Color, Color) _getStatusPair(String status, ColorScheme scheme) {
    switch (status.toLowerCase()) {
      case 'shared':
        return (Colors.green.shade100, Colors.green.shade800);
      case 'draft':
        return (Colors.amber.shade100, Colors.amber.shade900);
      default:
        return (scheme.surfaceContainerHighest, scheme.onSurfaceVariant);
    }
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
                isExpanded: true,
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
                isExpanded: true,
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
