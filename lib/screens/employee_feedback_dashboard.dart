import 'package:flutter/material.dart';
import '../models/feedback.dart';

class EmployeeFeedbackDashboard extends StatefulWidget {
  final String employeeName;
  final List<FeedbackItem> allFeedbacks;

  const EmployeeFeedbackDashboard({
    required this.employeeName,
    required this.allFeedbacks,
  });

  @override
  State<EmployeeFeedbackDashboard> createState() => _EmployeeFeedbackDashboardState();
}

class _EmployeeFeedbackDashboardState extends State<EmployeeFeedbackDashboard> {
  String _dateFilter = 'All Time';
  final _editController = TextEditingController();
  FeedbackItem? _editingFeedback;

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _deleteFeedback(FeedbackItem fb) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Feedback'),
        content: const Text('Are you sure you want to delete this feedback? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              widget.allFeedbacks.removeWhere((f) => f.id == fb.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ Feedback deleted!'), backgroundColor: Colors.red),
              );
              setState(() {});
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(FeedbackItem fb) {
    _editController.text = fb.comment;
    _editingFeedback = fb;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Feedback'),
        content: TextField(
          controller: _editController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Edit your feedback...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_editingFeedback != null && _editController.text.isNotEmpty) {
                final updatedFeedback = FeedbackItem(
                  id: _editingFeedback!.id,
                  employeeName: _editingFeedback!.employeeName,
                  feedbackType: _editingFeedback!.feedbackType,
                  comment: _editController.text,
                  createdAt: _editingFeedback!.createdAt,
                );

                final index = widget.allFeedbacks.indexWhere((f) => f.id == _editingFeedback!.id);
                if (index != -1) {
                  widget.allFeedbacks[index] = updatedFeedback;
                }

                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✓ Feedback updated!')),
                );
                setState(() {});
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feedbacks = widget.allFeedbacks.where((f) => f.employeeName == widget.employeeName).toList();
    final positive = feedbacks.where((f) => f.feedbackType == 'Positive').length;
    final constructive = feedbacks.where((f) => f.feedbackType == 'Constructive').length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employeeName),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // Summary stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[50]!, Colors.blue[100]!],
              ),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('$positive', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 26, color: Colors.green)),
                    const Text('Positive', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                  ],
                ),
                Column(
                  children: [
                    Text('$constructive', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 26, color: Colors.orange)),
                    const Text('Constructive', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                  ],
                ),
                Column(
                  children: [
                    Text('${feedbacks.length}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 26, color: Colors.blue)),
                    const Text('Total', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                  ],
                ),
              ],
            ),
          ),

          // Date filter
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All Time', 'This Year', 'This Quarter', 'This Month']
                    .map((filter) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: _dateFilter == filter,
                            onSelected: (selected) => setState(() => _dateFilter = filter),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),

          // Feedback list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final fb = feedbacks[index];
                final isPositive = fb.feedbackType == 'Positive';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isPositive ? [Colors.green[50]!, Colors.green[100]!] : [Colors.orange[50]!, Colors.orange[100]!],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isPositive ? Colors.green[200]! : Colors.orange[200]!, width: 1),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isPositive ? Colors.green : Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [BoxShadow(color: (isPositive ? Colors.green : Colors.orange).withOpacity(0.3), blurRadius: 6)],
                              ),
                              child: Text(
                                isPositive ? '✓ Positive' : '⚡ Constructive',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  fb.createdAt?.toString().split('.')[0] ?? '',
                                  style: TextStyle(fontSize: 11, color: Colors.grey[700], fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _showEditDialog(fb),
                                  child: Icon(Icons.edit, size: 18, color: isPositive ? Colors.green[700] : Colors.orange[700]),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _deleteFeedback(fb),
                                  child: Icon(Icons.delete_outline, size: 18, color: Colors.red[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(fb.comment, style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
