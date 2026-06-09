import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String _selectedEmployee = 'All Employees';
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMART Goals'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ClipRRect(
        clipBehavior: Clip.hardEdge,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Set SMART Goal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // KPI Cards
            Row(
              children: [
                Expanded(child: _buildKPICard('TOTAL GOALS', '1', Icons.adjust, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildKPICard('IN PROGRESS', '1', Icons.flag, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildKPICard('COMPLETED', '0', Icons.check_circle, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildKPICard('OVERDUE', '0', Icons.schedule, Colors.red)),
              ],
            ),
            const SizedBox(height: 32),

            // Filters
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedEmployee,
                  items: ['All Employees', 'Aisha Williams', 'James Peterson']
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
                      children: ['All', 'Not Started', 'In Progress', 'Completed', 'Cancelled']
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
            _buildGoalCard(
              title: 'Decrease complaint resolution from 72 hours to 24 hours',
              status: 'In Progress',
              owner: 'Aisha Williams',
              category: 'Customer Success',
              dueDate: 'Due Dec 31, 2026',
              progress: 34,
            ),
          ],
            ),
          ),
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
                            color: Colors.orange[50],
                            border: Border.all(color: Colors.orange[200]!),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(fontSize: 11, color: Colors.orange[700], fontWeight: FontWeight.w600),
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
