import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/goal.dart';

class GoalItem {
  final String id;
  final String title;
  final String category; // Clinical, Professional Development, Patient Care, Safety
  final String owner; // Doctor name who owns this goal
  final double progress;
  final String status; // On Track, At Risk, Completed
  final DateTime startDate;
  final DateTime deadline;
  final String description;

  GoalItem({
    required this.id,
    required this.title,
    required this.category,
    required this.owner,
    required this.progress,
    required this.status,
    required this.startDate,
    required this.deadline,
    required this.description,
  });

  int get daysRemaining {
    return deadline.difference(DateTime.now()).inDays;
  }

  String get formattedStartDate {
    return '${startDate.day}/${startDate.month}/${startDate.year}';
  }

  String get formattedDeadline {
    return '${deadline.day}/${deadline.month}/${deadline.year}';
  }
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String _selectedCategory = 'All';

  // Sample medical goals for demo
  final List<GoalItem> _demoGoals = [
    GoalItem(
      id: '1',
      title: 'Achieve 95% Patient Satisfaction Rating',
      category: 'Patient Care',
      owner: 'Dr. Mehta',
      progress: 0.92,
      status: 'On Track',
      startDate: DateTime(2026, 1, 1),
      deadline: DateTime(2026, 9, 30),
      description: 'Maintain excellent patient care standards and satisfaction metrics',
    ),
    GoalItem(
      id: '2',
      title: 'Complete Advanced Cardiac Certification',
      category: 'Professional Development',
      owner: 'Dr. Mehta',
      progress: 0.65,
      status: 'On Track',
      startDate: DateTime(2026, 4, 1),
      deadline: DateTime(2026, 8, 31),
      description: 'Obtain advanced certification in cardiology to enhance clinical expertise',
    ),
    GoalItem(
      id: '3',
      title: 'Zero Medication Errors Protocol Implementation',
      category: 'Safety',
      owner: 'Sarah Chen',
      progress: 0.88,
      status: 'On Track',
      startDate: DateTime(2026, 3, 1),
      deadline: DateTime(2026, 6, 30),
      description: 'Implement and maintain zero medication error standards',
    ),
    GoalItem(
      id: '4',
      title: 'Lead Monthly Clinical Training Sessions',
      category: 'Professional Development',
      owner: 'Dr. Mehta',
      progress: 0.45,
      status: 'At Risk',
      startDate: DateTime(2026, 6, 1),
      deadline: DateTime(2026, 12, 31),
      description: 'Conduct peer training and knowledge sharing sessions',
    ),
    GoalItem(
      id: '5',
      title: 'Reduce Average Patient Wait Time to <15 min',
      category: 'Patient Care',
      owner: 'James Peterson',
      progress: 0.72,
      status: 'On Track',
      startDate: DateTime(2026, 5, 1),
      deadline: DateTime(2026, 9, 30),
      description: 'Optimize scheduling and workflow efficiency',
    ),
  ];


  Color _getStatusColor(String status) {
    switch (status) {
      case 'On Track':
        return Colors.green;
      case 'At Risk':
        return Colors.orange;
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Clinical':
        return Colors.red;
      case 'Professional Development':
        return Colors.blue;
      case 'Patient Care':
        return Colors.green;
      case 'Safety':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Clinical':
        return '🏥';
      case 'Professional Development':
        return '📚';
      case 'Patient Care':
        return '👥';
      case 'Safety':
        return '🛡️';
      default:
        return '📋';
    }
  }

  void _showGoalDetails(GoalItem goal) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(goal.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getCategoryColor(goal.category).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_getCategoryIcon(goal.category)} ${goal.category}',
                  style: TextStyle(
                    color: _getCategoryColor(goal.category),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Owner: ${goal.owner}', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('Status: ${goal.status}', style: TextStyle(color: _getStatusColor(goal.status), fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('Start Date: ${goal.formattedStartDate}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
              const SizedBox(height: 4),
              Text('Deadline: ${goal.formattedDeadline}', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                'Days Remaining: ${goal.daysRemaining} days',
                style: TextStyle(
                  color: goal.daysRemaining > 30 ? Colors.green : goal.daysRemaining > 7 ? Colors.amber : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(goal.description, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              const SizedBox(height: 14),
              const Text('Progress:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: goal.progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(goal.status)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(goal.progress * 100).toInt()}%',
                    style: TextStyle(fontWeight: FontWeight.bold, color: _getStatusColor(goal.status)),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals & Objectives'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Category filter
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Clinical', 'Professional Development', 'Patient Care', 'Safety']
                    .map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat),
                            selected: _selectedCategory == cat,
                            onSelected: (selected) {
                              setState(() => _selectedCategory = cat);
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          // Goals list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _demoGoals.length,
              itemBuilder: (context, index) {
                final goal = _demoGoals[index];
                if (_selectedCategory != 'All' && goal.category != _selectedCategory) {
                  return const SizedBox.shrink();
                }

                final progressPercent = (goal.progress * 100).toInt();
                final categoryColor = _getCategoryColor(goal.category);
                final statusColor = _getStatusColor(goal.status);

                return GestureDetector(
                  onTap: () => _showGoalDetails(goal),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Title + Status Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  goal.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  goal.status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Category & Owner
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${_getCategoryIcon(goal.category)} ${goal.category}',
                                  style: TextStyle(
                                    color: categoryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Owner: ${goal.owner}',
                                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),

                        // Description
                        Text(
                          goal.description,
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 12),

                        // Progress bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: goal.progress,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '$progressPercent%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Dates and Days Remaining
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${goal.formattedStartDate} → ${goal.formattedDeadline}',
                                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.timer, size: 14, color: goal.daysRemaining > 30 ? Colors.green : goal.daysRemaining > 7 ? Colors.amber : Colors.red),
                            const SizedBox(width: 6),
                            Text(
                              '${goal.daysRemaining} days remaining',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: goal.daysRemaining > 30 ? Colors.green : goal.daysRemaining > 7 ? Colors.amber : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
