import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/feedback.dart';
import '../models/employee_feedback_summary.dart';
import '../models/healthcare_organization.dart';
import 'employee_feedback_dashboard.dart';

class FeedbackScreen extends StatefulWidget {
  // When set (e.g. opened from a Team card's "Feedback" quick action), the
  // New Feedback dialog auto-opens pre-filled for this employee.
  final String? initialEmployee;
  const FeedbackScreen({Key? key, this.initialEmployee}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _supabaseService = SupabaseService();
  late Future<List<FeedbackItem>> _feedbacksFuture;
  String _searchQuery = '';
  String _dateFilter = 'This Quarter';
  String _typeFilter = 'All'; // All | Positive | Constructive (set by tapping a metric)

  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  final _searchController = TextEditingController();
  final _yourNameController = TextEditingController();
  String _feedbackType = 'Positive';
  String _category = 'Clinical Excellence';
  int _rating = 0;
  bool _requestMeeting = false;
  String? _selectedEmployee;
  bool _isSubmitting = false;

  // Sample feedback data
  late List<FeedbackItem> _localFeedbacks;

  @override
  void initState() {
    super.initState();
    _feedbacksFuture = _supabaseService.getFeedbacks();
    if (widget.initialEmployee != null && widget.initialEmployee!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _showFeedbackForm(employee: widget.initialEmployee));
    }
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

  void _showFeedbackForm({String? employee, FeedbackItem? editItem}) {
    if (editItem != null) {
      // Revise an existing entry — pre-fill every field.
      _selectedEmployee = editItem.employeeName;
      _nameController.text = editItem.employeeName;
      _commentController.text = editItem.comment;
      _feedbackType = editItem.feedbackType;
      _rating = editItem.feedbackType == 'Positive' ? 5 : 3;
    } else {
      // Pre-fill the employee when launched from a specific staff card's "+".
      _selectedEmployee = employee;
      _nameController.text = employee ?? '';
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.feedback_outlined, size: 24, color: Colors.grey),
                const SizedBox(width: 8),
                Text(editItem != null ? 'Edit Feedback' : 'New Feedback', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child: const Icon(Icons.close, color: Colors.grey),
            ),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setSheet) => ClipRRect(
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
                value: _selectedEmployee,
                decoration: InputDecoration(
                  hintText: 'Select employee...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: _buildEmployeeList(),
                onChanged: (value) => setSheet(() {
                  _selectedEmployee = value;
                  _nameController.text = value ?? '';
                }),
              ),
              const SizedBox(height: 16),

              // Feedback Type
              const Text('Feedback Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setSheet(() {
                        _feedbackType = 'Positive';
                        _rating = 5; // Auto-set to 5 stars for Positive
                      }),
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
                      onTap: () => setSheet(() {
                        _feedbackType = 'Constructive';
                        _rating = 3; // Auto-set to 3 stars for Constructive
                      }),
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

              // Category (feedback is implicitly from the logged-in supervisor)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _category,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Clinical Excellence', child: Text('Clinical Excellence')),
                            DropdownMenuItem(value: 'Patient Care', child: Text('Patient Care')),
                            DropdownMenuItem(value: 'Team Collaboration', child: Text('Team Collaboration')),
                            DropdownMenuItem(value: 'Leadership', child: Text('Leadership')),
                            DropdownMenuItem(value: 'Communication', child: Text('Communication')),
                            DropdownMenuItem(value: 'Reliability', child: Text('Reliability')),
                            DropdownMenuItem(value: 'Documentation', child: Text('Documentation')),
                            DropdownMenuItem(value: 'Innovation', child: Text('Innovation')),
                            DropdownMenuItem(value: 'Professionalism', child: Text('Professionalism')),
                            DropdownMenuItem(value: 'Safety & Compliance', child: Text('Safety & Compliance')),
                            DropdownMenuItem(value: 'Training & Development', child: Text('Training & Development')),
                            DropdownMenuItem(value: 'Research & Analysis', child: Text('Research & Analysis')),
                            DropdownMenuItem(value: 'Problem Solving', child: Text('Problem Solving')),
                            DropdownMenuItem(value: 'Time Management', child: Text('Time Management')),
                            DropdownMenuItem(value: 'Adaptability', child: Text('Adaptability')),
                            DropdownMenuItem(value: 'Mentoring', child: Text('Mentoring')),
                            DropdownMenuItem(value: 'Quality of Work', child: Text('Quality of Work')),
                            DropdownMenuItem(value: 'Attendance', child: Text('Attendance')),
                          ],
                          onChanged: (value) => setSheet(() => _category = value ?? 'Clinical Excellence'),
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
              Wrap(
                spacing: 8,
                children: List.generate(5, (i) =>
                  GestureDetector(
                    onTap: () => setSheet(() => _rating = i + 1),
                    child: Icon(
                      i < _rating ? Icons.star : Icons.star_outline,
                      color: i < _rating ? Colors.amber : Colors.grey[300],
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Feedback Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Feedback Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey)),
                  GestureDetector(
                    onTap: () => _showAIFeedbackSuggestions(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.purple[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome, size: 14, color: Colors.purple[600]),
                          const SizedBox(width: 4),
                          Text('AI Polish', style: TextStyle(fontSize: 11, color: Colors.purple[600], fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                      onChanged: (value) => setSheet(() => _requestMeeting = value),
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
                _selectedEmployee = null;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Save Feedback'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E7C7B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              final employeeName = _nameController.text.trim();
              final comment = _commentController.text.trim();

              if (employeeName.isEmpty || comment.isEmpty || _rating == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }

              final updated = FeedbackItem(
                id: editItem?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                employeeName: employeeName,
                feedbackType: _feedbackType,
                comment: comment,
                createdAt: editItem?.createdAt ?? DateTime.now(),
              );

              setState(() {
                if (editItem != null) {
                  final i = _localFeedbacks.indexWhere((f) => f.id == editItem.id);
                  if (i >= 0) {
                    _localFeedbacks[i] = updated;
                  } else {
                    _localFeedbacks.insert(0, updated);
                  }
                } else {
                  _localFeedbacks.insert(0, updated);
                }
              });
              _nameController.clear();
              _commentController.clear();
              _yourNameController.clear();
              setState(() {
                _rating = 0;
                _feedbackType = 'Positive';
                _category = 'Clinical Excellence';
                _requestMeeting = false;
                _selectedEmployee = null;
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

  void _confirmDeleteFeedback(FeedbackItem f) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete feedback?'),
        content: Text('This feedback for ${f.employeeName} will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _localFeedbacks.removeWhere((x) => x.id == f.id));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feedback deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // A single chronological entry in the feedback log.
  Widget _buildLogRow(FeedbackItem f, List<FeedbackItem> allFeedbacks) {
    final isPositive = f.feedbackType == 'Positive';
    final accent = isPositive ? Colors.green : Colors.orange;
    final textColor = isPositive ? Colors.green[700]! : Colors.orange[800]!;
    final d = f.createdAt ?? DateTime.now();
    final when =
        '${d.day}/${d.month}/${d.year} · ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EmployeeFeedbackDashboard(
              employeeName: f.employeeName, allFeedbacks: allFeedbacks),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 42,
              decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(f.employeeName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(f.feedbackType,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textColor)),
                      ),
                      // Manager actions: revise / delete
                      SizedBox(
                        height: 24,
                        width: 28,
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                          onSelected: (v) {
                            if (v == 'edit') {
                              _showFeedbackForm(editItem: f);
                            } else if (v == 'delete') {
                              _confirmDeleteFeedback(f);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 10), Text('Edit / revise')])),
                            PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 10), Text('Delete', style: TextStyle(color: Colors.red))])),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(f.comment,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(when, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildEmployeeList() {
    final items = <DropdownMenuItem<String>>[];
    final seen = <String>{};
    // Include a pre-selected employee even if they aren't an org persona
    // (the Team screen has its own roster) so the dropdown value always matches.
    if (_selectedEmployee != null && _selectedEmployee!.isNotEmpty) {
      items.add(DropdownMenuItem(value: _selectedEmployee, child: Text(_selectedEmployee!)));
      seen.add(_selectedEmployee!);
    }
    for (final org in HealthcareOrganization.all) {
      for (final persona in org.personas) {
        if (seen.add(persona.name)) {
          items.add(DropdownMenuItem(value: persona.name, child: Text('${persona.name} (${persona.role})')));
        }
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

  Widget _buildMetric(String label, String value, Color color, {String? filterKey}) {
    final selected = filterKey != null && _typeFilter == filterKey;
    return GestureDetector(
      onTap: filterKey == null
          ? null
          : () => setState(() => _typeFilter = _typeFilter == filterKey ? 'All' : filterKey),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? color.withOpacity(0.5) : Colors.transparent),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ],
        ),
      ),
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
                      _buildMetric('Overall Avg', '${avgRating.toStringAsFixed(2)}/5.0', heatColor, filterKey: 'Positive'),
                      _buildMetric('Total Feedback', filteredFeedbacks.length.toString(), Colors.blue, filterKey: 'All'),
                      _buildMetric('Team Health', _getHealthStatus(filteredFeedbacks), _getHealthColor(filteredFeedbacks), filterKey: 'Constructive'),
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
              // Feedback log (chronological, newest first)
              Expanded(
                child: Builder(builder: (context) {
                  final q = _searchQuery.toLowerCase();
                  final logItems = _filterFeedbacksByDate(allFeedbacks, _dateFilter)
                      .where((f) =>
                          (_typeFilter == 'All' || f.feedbackType == _typeFilter) &&
                          (f.employeeName.toLowerCase().contains(q) ||
                              f.comment.toLowerCase().contains(q)))
                      .toList()
                    ..sort((a, b) => (b.createdAt ?? DateTime.now())
                        .compareTo(a.createdAt ?? DateTime.now()));
                  final banner = _typeFilter == 'All'
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: InkWell(
                            onTap: () => setState(() => _typeFilter = 'All'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.filter_alt, size: 14, color: Colors.grey[700]),
                                  const SizedBox(width: 6),
                                  Text('Showing $_typeFilter feedback',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[800], fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  const Icon(Icons.close, size: 16, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        );
                  if (logItems.isEmpty) {
                    return Column(children: [
                      banner,
                      Expanded(
                        child: Center(
                          child: Text('No feedback in this period',
                              style: TextStyle(color: Colors.grey[500])),
                        ),
                      ),
                    ]);
                  }
                  return Column(
                    children: [
                      banner,
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: logItems.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) =>
                              _buildLogRow(logItems[index], allFeedbacks),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFeedbackForm(),
        backgroundColor: const Color(0xFF0E7C7B),
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAIFeedbackSuggestions() {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter feedback text first')),
      );
      return;
    }

    final originalText = _commentController.text;
    final suggestions = _analyzeAndSuggestImprovements(originalText);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.purple[600]),
            const SizedBox(width: 8),
            const Text('AI Feedback Polish'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    const Text('Original:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(originalText, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Improved:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(suggestions['improved'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...(suggestions['corrections'] as List<String>).map((correction) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, size: 16, color: Colors.green[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(correction, style: const TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Decline'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _commentController.text = suggestions['improved'] as String;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✓ Feedback polished! You can still edit before saving.'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(ctx);
            },
            icon: const Icon(Icons.check),
            label: const Text('Apply'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _analyzeAndSuggestImprovements(String text) {
    String improved = text;
    final corrections = <String>[];

    // Spelling & Grammar Suggestions
    final commonMistakes = {
      'tlak': 'talk',
      'teh': 'the',
      'adn': 'and',
      'thsi': 'this',
      'taht': 'that',
      'recieve': 'receive',
      'recieved': 'received',
      'occured': 'occurred',
      'occassion': 'occasion',
      'ocasion': 'occasion',
      'exellent': 'excellent',
      'excelent': 'excellent',
      'seperate': 'separate',
      'thier': 'their',
      'wich': 'which',
      'becuase': 'because',
      'untill': 'until',
      'alot': 'a lot',
      'definately': 'definitely',
      'neccessary': 'necessary',
      'necesary': 'necessary',
      'accomodate': 'accommodate',
      'responsibilty': 'responsibility',
      'communcation': 'communication',
      'comunication': 'communication',
      'profesional': 'professional',
      'profesionalism': 'professionalism',
      'acheivement': 'achievement',
      'improvment': 'improvement',
      'consistant': 'consistent',
      'managment': 'management',
      'enviroment': 'environment',
      'knowlege': 'knowledge',
      'collegue': 'colleague',
      'collaegue': 'colleague',
      'recomend': 'recommend',
      'reccomend': 'recommend',
      'commited': 'committed',
      'sucessful': 'successful',
      'succesful': 'successful',
      'experiance': 'experience',
      'paitent': 'patient',
      'pateint': 'patient',
      'beleive': 'believe',
      'wether': 'whether',
      'truely': 'truly',
      'arguement': 'argument',
      'reponsible': 'responsible',
      'punctualy': 'punctually',
      'detial': 'detail',
      'detials': 'details',
      'feedbck': 'feedback',
      'mistke': 'mistake',
    };

    commonMistakes.forEach((mistake, correct) {
      // Whole-word, case-insensitive match so short tokens don't mangle
      // unrelated words (e.g. "the" inside "theory").
      final pattern = RegExp(r'\b' + RegExp.escape(mistake) + r'\b', caseSensitive: false);
      if (pattern.hasMatch(improved)) {
        improved = improved.replaceAll(pattern, correct);
        corrections.add('Fixed: "$mistake" → "$correct"');
      }
    });

    // Grammar & Clarity Suggestions
    if (improved.isNotEmpty && improved[0] == improved[0].toLowerCase()) {
      improved = improved[0].toUpperCase() + improved.substring(1);
      corrections.add('Capitalized first letter');
    }

    if (!improved.endsWith('.') && !improved.endsWith('!') && !improved.endsWith('?')) {
      improved += '.';
      corrections.add('Added period at end');
    }

    // Phrase improvements
    if (improved.contains('very good')) {
      improved = improved.replaceAll('very good', 'excellent');
      corrections.add('Enhanced: "very good" → "excellent"');
    }

    if (improved.contains('really nice')) {
      improved = improved.replaceAll('really nice', 'commendable');
      corrections.add('Enhanced: "really nice" → "commendable"');
    }

    if (improved.contains('not bad')) {
      improved = improved.replaceAll('not bad', 'satisfactory');
      corrections.add('Improved clarity: "not bad" → "satisfactory"');
    }

    // Remove extra spaces
    improved = improved.replaceAll(RegExp(r'\s+'), ' ').trim();

    if (corrections.isEmpty) {
      corrections.add('Text looks great! Clear and professional.');
    }

    return {
      'improved': improved,
      'corrections': corrections,
    };
  }
}
