import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/feedback.dart';
import '../models/employee_feedback_summary.dart';
import '../models/healthcare_organization.dart';
import 'employee_feedback_dashboard.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _supabaseService = SupabaseService();
  late Future<List<FeedbackItem>> _feedbacksFuture;
  String _searchQuery = '';
  String _dateFilter = 'This Quarter';

  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  final _searchController = TextEditingController();
  final _yourNameController = TextEditingController();
  String _feedbackType = 'Positive';
  String _category = 'Clinical Excellence';
  int _rating = 0;
  bool _requestMeeting = false;
  bool _isSubmitting = false;

  // Sample feedback data
  late List<FeedbackItem> _localFeedbacks;

  @override
  void initState() {
    super.initState();
    _feedbacksFuture = _supabaseService.getFeedbacks();
    _localFeedbacks = [
      FeedbackItem(
        id: '1',
        employeeName: 'Dr. Mehta',
        feedbackType: 'Positive',
        comment: 'Demonstrates strong clinical judgment and excellent patient communication skills.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FeedbackItem(
        id: '2',
        employeeName: 'Sarah Chen',
        feedbackType: 'Constructive',
        comment: 'Needs development in documentation efficiency. Consider time management strategies.',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      FeedbackItem(
        id: '3',
        employeeName: 'James Peterson',
        feedbackType: 'Positive',
        comment: 'Outstanding leadership in team coordination. Sets excellent example for junior staff.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<EmployeeFeedbackSummary> _aggregateFeedbackByEmployee(List<FeedbackItem> feedbacks) {
    final Map<String, List<FeedbackItem>> grouped = {};

    for (final fb in feedbacks) {
      grouped.putIfAbsent(fb.employeeName, () => []).add(fb);
    }

    final now = DateTime.now();
    final currentQuarterStart = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1);
    final previousQuarterStart = DateTime(now.year, ((now.month - 4) ~/ 3) * 3 + 1);

    return grouped.entries.map((entry) {
      final fbs = entry.value;
      final positive = fbs.where((f) => f.feedbackType == 'Positive').length;
      final constructive = fbs.where((f) => f.feedbackType == 'Constructive').length;

      final currentQ = fbs.where((f) => f.createdAt != null && f.createdAt!.isAfter(currentQuarterStart)).toList();
      final currentQPos = currentQ.where((f) => f.feedbackType == 'Positive').length;
      final currentQCon = currentQ.where((f) => f.feedbackType == 'Constructive').length;

      final prevQ = fbs.where((f) => f.createdAt != null && f.createdAt!.isAfter(previousQuarterStart) && f.createdAt!.isBefore(currentQuarterStart)).toList();
      final prevQPos = prevQ.where((f) => f.feedbackType == 'Positive').length;
      final prevQCon = prevQ.where((f) => f.feedbackType == 'Constructive').length;

      return EmployeeFeedbackSummary(
        employeeName: entry.key,
        positiveCount: positive,
        constructiveCount: constructive,
        averageRating: 3.5,
        currentQuarterPositive: currentQPos,
        currentQuarterConstructive: currentQCon,
        previousQuarterPositive: prevQPos,
        previousQuarterConstructive: prevQCon,
        lastFeedbackDate: fbs.isNotEmpty ? fbs.first.createdAt : null,
      );
    }).toList()
      ..sort((a, b) => (b.lastFeedbackDate ?? DateTime(2000)).compareTo(a.lastFeedbackDate ?? DateTime(2000)));
  }

  void _showAISuggestions() {
    final text = _commentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter feedback first')),
      );
      return;
    }

    final enhancedText = _correctAndEnhanceText(text);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [Icon(Icons.auto_awesome, color: Colors.purple), SizedBox(width: 8), Text('Enhanced Feedback')],
        ),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enhanced Feedback (${enhancedText.length}/300 characters)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.green[700])),
                const SizedBox(height: 12),
                Text(enhancedText, style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600]),
            onPressed: () {
              _commentController.text = enhancedText;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ Feedback enhanced and applied!')),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  String _correctAndEnhanceText(String text) {
    String corrected = text.trim();

    // Fix common mistakes
    final fixes = {
      'teh ': 'the ',
      'recieve': 'receive',
      'occured': 'occurred',
      'seperate': 'separate',
      'excelent': 'excellent',
      'profesional': 'professional',
      'acheivement': 'achievement',
      'improvment': 'improvement',
      'consistant': 'consistent',
    };

    fixes.forEach((wrong, right) {
      corrected = corrected.replaceAll(wrong, right);
      corrected = corrected.replaceAll(wrong.toUpperCase(), right.toUpperCase());
    });

    // Capitalize first letter
    if (corrected.isNotEmpty) {
      corrected = corrected[0].toUpperCase() + corrected.substring(1);
    }

    // Add enhancement if space allows (max 300 chars)
    const enhancements = [
      'This demonstrates strong commitment to professional excellence.',
      'Consistent effort in this area shows dedication and growth.',
      'Such performance contributes positively to team success.',
      'Notable progress reflects effective skill development.',
      'This work exemplifies professionalism and quality standards.',
    ];

    final currentLength = corrected.length;
    if (currentLength < 250) {
      final enhancement = enhancements[corrected.hashCode % enhancements.length];
      final tempResult = '$corrected. $enhancement';
      if (tempResult.length <= 300) {
        return tempResult;
      }
    }

    return corrected;
  }

  void _showFeedbackForm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.feedback_outlined, size: 24, color: Colors.grey),
                SizedBox(width: 8),
                Text('New Feedback', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child: const Icon(Icons.close, color: Colors.grey),
            ),
          ],
        ),
        content: ClipRRect(
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              // Employee
              const Text('Employee', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: null,
                decoration: InputDecoration(
                  hintText: 'Select employee...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: _buildEmployeeList(),
                onChanged: (value) => setState(() => _nameController.text = value ?? ''),
              ),
              const SizedBox(height: 16),

              // Feedback Type
              const Text('Feedback Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _feedbackType = 'Positive'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: _feedbackType == 'Positive' ? Colors.teal : Colors.grey[300]!, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          color: _feedbackType == 'Positive' ? Colors.teal[50] : Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.trending_up, size: 16, color: _feedbackType == 'Positive' ? Colors.teal : Colors.grey),
                            const SizedBox(width: 4),
                            Text('Positive', style: TextStyle(fontWeight: FontWeight.w600, color: _feedbackType == 'Positive' ? Colors.teal : Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _feedbackType = 'Constructive'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: _feedbackType == 'Constructive' ? Colors.orange : Colors.grey[300]!, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          color: _feedbackType == 'Constructive' ? Colors.orange[50] : Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.feedback, size: 16, color: _feedbackType == 'Constructive' ? Colors.orange : Colors.grey),
                            const SizedBox(width: 4),
                            Text('Constructive', style: TextStyle(fontWeight: FontWeight.w600, color: _feedbackType == 'Constructive' ? Colors.orange : Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Category & Your Name Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _category,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          items: [
                            'Clinical Excellence',
                            'Patient Care',
                            'Team Collaboration',
                            'Leadership',
                            'Communication',
                            'Reliability',
                            'Documentation',
                            'Innovation',
                            'Professionalism',
                            'Safety & Compliance',
                            'Training & Development',
                            'Research & Analysis',
                            'Problem Solving',
                            'Time Management',
                            'Adaptability',
                            'Mentoring',
                            'Quality of Work',
                            'Attendance',
                          ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (value) => setState(() => _category = value ?? 'Clinical Excellence'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _yourNameController,
                          decoration: InputDecoration(
                            hintText: 'Supervisor name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Rating
              const Text('Performance Rating', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (i) =>
                  GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        i < _rating ? Icons.star : Icons.star_outline,
                        color: i < _rating ? Colors.amber : Colors.grey[300],
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Feedback Details
              const Text('Feedback Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                maxLines: 5,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: 'Describe the specific behavior, outcome, or observation...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),

              // Request a Meeting
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.grey[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: const Text('Request a Meeting', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                    Switch(
                      value: _requestMeeting,
                      onChanged: (value) => setState(() => _requestMeeting = value),
                      activeColor: Colors.teal,
                    ),
                  ],
                ),
              ),
            ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _nameController.clear();
              _commentController.clear();
              _yourNameController.clear();
              setState(() {
                _rating = 0;
                _feedbackType = 'Positive';
                _category = 'Clinical Excellence';
                _requestMeeting = false;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Save Feedback'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
            onPressed: () {
              final employeeName = _nameController.text.trim();
              final comment = _commentController.text.trim();

              if (employeeName.isEmpty || comment.isEmpty || _rating == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }

              final newFeedback = FeedbackItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                employeeName: employeeName,
                feedbackType: _feedbackType,
                comment: comment,
                createdAt: DateTime.now(),
              );

              setState(() => _localFeedbacks.insert(0, newFeedback));
              _nameController.clear();
              _commentController.clear();
              _yourNameController.clear();
              setState(() {
                _rating = 0;
                _feedbackType = 'Positive';
                _category = 'Clinical Excellence';
                _requestMeeting = false;
              });
              Navigator.pop(ctx);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Feedback saved for $employeeName ✓')),
              );
            },
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildEmployeeList() {
    final items = <DropdownMenuItem<String>>[];
    for (final org in HealthcareOrganization.all) {
      for (final persona in org.personas) {
        items.add(DropdownMenuItem(value: persona.name, child: Text('${persona.name} (${persona.role})')));
      }
    }
    return items;
  }

  IconData _getRoleIcon(String employeeName) {
    final role = _getEmployeeRole(employeeName);
    switch (role) {
      case 'Doctor':
        return Icons.medical_services_rounded;
      case 'Nurse':
        return Icons.favorite_rounded;
      case 'Admin':
        return Icons.admin_panel_settings_rounded;
      case 'HR Director':
        return Icons.person_rounded;
      default:
        return Icons.badge_rounded;
    }
  }

  Color _getRoleColor(String employeeName) {
    final role = _getEmployeeRole(employeeName);
    switch (role) {
      case 'Doctor':
        return Colors.red[600]!;
      case 'Nurse':
        return Colors.pink[600]!;
      case 'Admin':
        return Colors.purple[600]!;
      case 'HR Director':
        return Colors.indigo[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  Widget _buildPerformanceBox(String label, Color color, String indicator) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(indicator, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[700], fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: color)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w500)),
      ],
    );
  }

  Color _getPerformanceColor(List<FeedbackItem> feedbacks) {
    if (feedbacks.isEmpty) return Colors.grey;
    final positiveRatio = feedbacks.where((f) => f.feedbackType == 'Positive').length / feedbacks.length;
    if (positiveRatio > 0.7) return Colors.green;
    if (positiveRatio > 0.5) return Colors.blue;
    if (positiveRatio > 0.3) return Colors.amber;
    return Colors.red;
  }

  String _getHealthStatus(List<FeedbackItem> feedbacks) {
    if (feedbacks.isEmpty) return 'No Data';
    final positiveRatio = feedbacks.where((f) => f.feedbackType == 'Positive').length / feedbacks.length;
    if (positiveRatio > 0.7) return 'Excellent';
    if (positiveRatio > 0.5) return 'Good';
    if (positiveRatio > 0.3) return 'Fair';
    return 'Poor';
  }

  Color _getHealthColor(List<FeedbackItem> feedbacks) {
    if (feedbacks.isEmpty) return Colors.grey;
    final positiveRatio = feedbacks.where((f) => f.feedbackType == 'Positive').length / feedbacks.length;
    if (positiveRatio > 0.7) return Colors.green;
    if (positiveRatio > 0.5) return Colors.blue;
    if (positiveRatio > 0.3) return Colors.amber;
    return Colors.red;
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: color)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[700])),
      ],
    );
  }

  List<FeedbackItem> _filterFeedbacksByDate(List<FeedbackItem> feedbacks, String filter) {
    final now = DateTime.now();
    return feedbacks.where((f) {
      if (f.createdAt == null) return false;
      switch (filter) {
        case 'This Week':
          return f.createdAt!.isAfter(now.subtract(const Duration(days: 7)));
        case 'This Month':
          return f.createdAt!.isAfter(DateTime(now.year, now.month, 1));
        case 'This Quarter':
          final quarterStart = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1);
          return f.createdAt!.isAfter(quarterStart);
        case 'Previous Quarter':
          final currentQuarterStart = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1);
          final previousQuarterStart = DateTime(now.year, ((now.month - 4) ~/ 3) * 3 + 1);
          return f.createdAt!.isAfter(previousQuarterStart) && f.createdAt!.isBefore(currentQuarterStart);
        default:
          return true;
      }
    }).toList();
  }

  double _calculateAverageRating(List<FeedbackItem> feedbacks) {
    if (feedbacks.isEmpty) return 0.0;
    int totalRating = 0;
    for (var fb in feedbacks) {
      totalRating += fb.feedbackType == 'Positive' ? 5 : 3;
    }
    return totalRating / feedbacks.length;
  }

  Color _getHeatmapColor(double avgRating) {
    if (avgRating >= 4.5) return Colors.green;
    if (avgRating >= 4.0) return Colors.lightGreen;
    if (avgRating >= 3.5) return Colors.blue;
    if (avgRating >= 3.0) return Colors.amber;
    return Colors.red;
  }

  String _getEmployeeRole(String employeeName) {
    const roleMap = {
      'Dr. Mehta': 'Doctor',
      'Dr. Kapoor': 'Doctor',
      'Dr. Patel': 'Doctor',
      'Sarah Chen': 'Nurse',
      'Aisha Khan': 'Nurse',
      'Maria Jose': 'Nurse',
      'James Peterson': 'Admin',
      'Hon Williams': 'Admin',
      'Amit Kumar': 'Admin',
      'Priya Sharma': 'HR Director',
    };
    return roleMap[employeeName] ?? 'Employee';
  }

  String _getEmployeeDept(String employeeName) {
    const deptMap = {
      'Dr. Mehta': 'Clinical',
      'Dr. Kapoor': 'Clinical',
      'Dr. Patel': 'Clinical',
      'Sarah Chen': 'Nursing',
      'Aisha Khan': 'Nursing',
      'Maria Jose': 'Nursing',
      'James Peterson': 'Operations',
      'Hon Williams': 'Operations',
      'Amit Kumar': 'Operations',
      'Priya Sharma': 'HR',
    };
    return deptMap[employeeName] ?? 'Department Unknown';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        automaticallyImplyLeading: false,
        elevation: 2,
        backgroundColor: Colors.blue[600],
      ),
      body: FutureBuilder<List<FeedbackItem>>(
        future: _feedbacksFuture,
        builder: (context, snapshot) {
          final allFeedbacks = [..._localFeedbacks, ...(snapshot.data ?? <FeedbackItem>[])];
          final employees = _aggregateFeedbackByEmployee(allFeedbacks);
          final filtered = employees.where((e) => e.employeeName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

          return Column(
            children: [
              // Date Range Selector - TOP
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All Time', 'Previous Quarter', 'This Quarter', 'This Month', 'This Week']
                        .map((filter) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(filter, style: const TextStyle(fontSize: 12)),
                                selected: _dateFilter == filter,
                                onSelected: (selected) => setState(() => _dateFilter = filter),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              // Performance Heatmap - SECOND LEVEL
              Builder(builder: (context) {
                final filteredFeedbacks = _filterFeedbacksByDate(allFeedbacks, _dateFilter);
                final avgRating = _calculateAverageRating(filteredFeedbacks);
                final heatColor = _getHeatmapColor(avgRating);

                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetric('Overall Avg', '${avgRating.toStringAsFixed(2)}/5.0', heatColor),
                      _buildMetric('Total Feedback', filteredFeedbacks.length.toString(), Colors.blue),
                      _buildMetric('Team Health', _getHealthStatus(filteredFeedbacks), _getHealthColor(filteredFeedbacks)),
                    ],
                  ),
                );
              }),
              // Search
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search employee...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              // Employee list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final emp = filtered[index];

                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeeFeedbackDashboard(employeeName: emp.employeeName, allFeedbacks: allFeedbacks))),
                      child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white, Colors.grey[50]!]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: _getRoleColor(emp.employeeName).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(_getRoleIcon(emp.employeeName), color: _getRoleColor(emp.employeeName), size: 22),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(emp.employeeName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87)),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                Text(_getEmployeeRole(emp.employeeName), style: TextStyle(fontSize: 10, color: Colors.blue[700], fontWeight: FontWeight.w600)),
                                                const SizedBox(width: 8),
                                                Text('• ${_getEmployeeDept(emp.employeeName)}', style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _showFeedbackForm,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue[600]!, Colors.blue[400]!]), borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))]),
                                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem('✓ Positive', emp.positiveCount.toString(), Colors.green),
                                  _buildStatItem('⚡ Constructive', emp.constructiveCount.toString(), Colors.orange),
                                  _buildStatItem('Q4', emp.currentQuarterTotal.toString(), Colors.blue),
                                  _buildStatItem('Q3', emp.previousQuarterTotal.toString(), Colors.grey[700]!),
                                ],
                              ),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFeedbackForm,
        backgroundColor: Colors.blue[600],
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
