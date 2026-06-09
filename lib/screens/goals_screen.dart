import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String _selectedEmployee = 'All Employees';
  String _selectedStatus = 'All';

  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Decrease complaint resolution from 72 hours to 24 hours',
      'status': 'In Progress',
      'owner': 'Aisha Williams',
      'category': 'Customer Success',
      'dueDate': 'Due Dec 31, 2026',
      'progress': 34,
    },
    {
      'title': 'Improve patient satisfaction scores to 95%',
      'status': 'In Progress',
      'owner': 'Dr. Mehta',
      'category': 'Clinical',
      'dueDate': 'Due Jan 15, 2027',
      'progress': 62,
    },
    {
      'title': 'Complete quarterly compliance audit',
      'status': 'Overdue',
      'owner': 'Sarah Chen',
      'category': 'Compliance',
      'dueDate': 'Due Sep 30, 2026',
      'progress': 25,
    },
    {
      'title': 'Reduce medication errors by 50%',
      'status': 'In Progress',
      'owner': 'James Peterson',
      'category': 'Safety',
      'dueDate': 'Due Feb 28, 2027',
      'progress': 45,
    },
    {
      'title': 'Implement new documentation system',
      'status': 'Completed',
      'owner': 'Priya Sharma',
      'category': 'Operations',
      'dueDate': 'Completed Nov 30, 2026',
      'progress': 100,
    },
    {
      'title': 'Update staff training materials',
      'status': 'Overdue',
      'owner': 'Dr. Kapoor',
      'category': 'Training',
      'dueDate': 'Due Oct 15, 2026',
      'progress': 15,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMART Goals'),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SMART Goals',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Track employee goals and progress',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // KPI Cards
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: double.infinity),
              child: Row(
                children: [
                  Expanded(child: _buildKPICard('TOTAL GOALS', _goals.length.toString(), Icons.adjust, Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildKPICard('IN PROGRESS', _goals.where((g) => g['status'] == 'In Progress').length.toString(), Icons.flag, Colors.orange)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildKPICard('COMPLETED', _goals.where((g) => g['status'] == 'Completed').length.toString(), Icons.check_circle, Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildKPICard('OVERDUE', _goals.where((g) => g['status'] == 'Overdue').length.toString(), Icons.schedule, Colors.red)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Filters
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedEmployee,
                  items: ['All Employees', 'Aisha Williams', 'Dr. Mehta', 'Sarah Chen']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedEmployee = value ?? 'All Employees'),
                  underline: SizedBox.shrink(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'In Progress', 'Completed', 'Overdue']
                          .map((status) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(status),
                              selected: _selectedStatus == status,
                              onSelected: (selected) => setState(() => _selectedStatus = status),
                              backgroundColor: Colors.grey[200],
                              selectedColor: Colors.grey[900],
                              labelStyle: TextStyle(
                                color: _selectedStatus == status ? Colors.white : Colors.black,
                              ),
                            ),
                          ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Goals List
            ..._goals.map((goal) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildGoalCard(
                title: goal['title'],
                status: goal['status'],
                owner: goal['owner'],
                category: goal['category'],
                dueDate: goal['dueDate'],
                progress: goal['progress'],
              ),
            )).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGoalDialog,
        backgroundColor: Colors.grey[900],
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Goal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New SMART Goal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Goal title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Due date',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[900]),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Goal added successfully! ✓')),
              );
              Navigator.pop(ctx);
            },
            child: const Text('Add Goal'),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required String status,
    required String owner,
    required String category,
    required String dueDate,
    required int progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
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
                    Row(
                      children: [
                        Icon(Icons.circle, size: 12, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: status == 'Completed'
                                ? Colors.green[50]
                                : status == 'Overdue'
                                    ? Colors.red[50]
                                    : Colors.orange[50],
                            border: Border.all(
                              color: status == 'Completed'
                                  ? Colors.green[200]!
                                  : status == 'Overdue'
                                      ? Colors.red[200]!
                                      : Colors.orange[200]!,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 11,
                              color: status == 'Completed'
                                  ? Colors.green[700]
                                  : status == 'Overdue'
                                      ? Colors.red[700]
                                      : Colors.orange[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(owner, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                        const SizedBox(width: 12),
                        Icon(Icons.tag, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(category, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(dueDate, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () {}, padding: EdgeInsets.zero),
                  IconButton(icon: const Icon(Icons.more_vert, size: 18), onPressed: () {}, padding: EdgeInsets.zero),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 6,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('$progress%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
