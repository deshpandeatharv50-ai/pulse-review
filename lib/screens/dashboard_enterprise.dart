import 'package:flutter/material.dart';
import '../models/feedback.dart';

// ENTERPRISE PROFESSIONAL DASHBOARD
// Like Yashoda, Apollo - with collapsible popups for feedback, meetings, goals
class DashboardEnterprise extends StatefulWidget {
  const DashboardEnterprise({Key? key}) : super(key: key);

  @override
  State<DashboardEnterprise> createState() => _DashboardEnterpriseState();
}

class _DashboardEnterpriseState extends State<DashboardEnterprise> {
  late List<FeedbackItem> _localFeedbacks;

  @override
  void initState() {
    super.initState();
    _localFeedbacks = [
      FeedbackItem(
        id: '1',
        employeeName: 'Priya Sharma',
        feedbackType: 'Positive',
        comment: 'Great job on technical skills and overall performance',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FeedbackItem(
        id: '2',
        employeeName: 'Carlos Rivera',
        feedbackType: 'Constructive',
        comment: 'It seems there may have been an issue with your submission. Please provide the original feedback text',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      FeedbackItem(
        id: '3',
        employeeName: 'Aisha Williams',
        feedbackType: 'Positive',
        comment: 'Your positive attitude while interacting with the VP of Marketing was commendable',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      FeedbackItem(
        id: '4',
        employeeName: 'David Park',
        feedbackType: 'Constructive',
        comment: 'The app redesign could benefit from further refinement. I appreciate your efforts and believe there\'s potential',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      FeedbackItem(
        id: '5',
        employeeName: 'Marcus Johnson',
        feedbackType: 'Constructive',
        comment: 'Technical skills need improvement. Please focus on the fundamentals',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      FeedbackItem(
        id: '6',
        employeeName: 'James Bellano',
        feedbackType: 'Constructive',
        comment: 'Presentation was confusing and lacked structure. Needs to make sure he prepares visuals',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  void _showRecentFeedbackPopup() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Feedback', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _localFeedbacks.take(5).length,
                  itemBuilder: (context, index) {
                    final fb = _localFeedbacks[index];
                    final isPositive = fb.feedbackType == 'Positive';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fb.employeeName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isPositive ? Colors.green[100] : Colors.orange[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      fb.feedbackType,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: isPositive ? Colors.green[700] : Colors.orange[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('Meeting', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.blue)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(fb.comment, style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.4)),
                          const SizedBox(height: 6),
                          Text(
                            '${fb.createdAt.day}/${fb.createdAt.month}, ${fb.createdAt.hour}:${fb.createdAt.minute.toString().padLeft(2, '0')} AM',
                            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPendingMeetingsPopup() {
    final meetings = [
      {'name': 'Priya Sharma', 'initials': 'P', 'status': 'Requested by none'},
      {'name': 'David Park', 'initials': 'D', 'status': 'Requested by none'},
      {'name': 'Marcus Johnson', 'initials': 'M', 'status': 'Requested by none'},
      {'name': 'James Bellano', 'initials': 'J', 'status': 'Requested by supervisor'},
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pending Meetings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: meetings.length,
                  itemBuilder: (context, index) {
                    final m = meetings[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                m['initials'] as String,
                                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.purple[700], fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                Text(m['status'] as String, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGoalsSnapshotPopup() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Goals Snapshot', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('1', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28, color: Colors.blue)),
                      const Text('Active', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Goal 1: Improve Performance', style: TextStyle(fontSize: 10, color: Colors.blue[700])),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 80, color: Colors.grey[200]),
                  Column(
                    children: [
                      const Text('0', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28, color: Colors.green)),
                      const Text('Done', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ),
                  Container(width: 1, height: 80, color: Colors.grey[200]),
                  Column(
                    children: [
                      const Text('0', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28, color: Colors.red)),
                      const Text('Overdue', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Decrease complaint resolution from 72 hours to 24...', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.34,
                        minHeight: 6,
                        backgroundColor: Colors.orange[100],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[600]),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('34%', style: TextStyle(fontSize: 10, color: Colors.orange[700], fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPositive = _localFeedbacks.where((f) => f.feedbackType == 'Positive').length;
    final totalConstructive = _localFeedbacks.where((f) => f.feedbackType == 'Constructive').length;
    final totalMembers = 10;
    final avgRating = 3.4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Feedback'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Performance Overview', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                Text('May 31, 2026', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 24),

            // KPI Cards
            Row(
              children: [
                Expanded(
                  child: _buildKPICard('👥 TEAM MEMBERS', totalMembers.toString(), Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKPICard('✓ POSITIVE', totalPositive.toString(), Colors.green),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKPICard('⚡ CONSTRUCTIVE', totalConstructive.toString(), Colors.orange),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKPICard('⭐ AVG RATING', avgRating.toString(), Colors.amber),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recent Feedback (Clickable)
            GestureDetector(
              onTap: _showRecentFeedbackPopup,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recent Feedback', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        GestureDetector(
                          onTap: _showRecentFeedbackPopup,
                          child: Text('View all >', style: TextStyle(fontSize: 12, color: Colors.blue[600], fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._localFeedbacks.take(5).map((fb) {
                      final isPositive = fb.feedbackType == 'Positive';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isPositive ? Colors.green : Colors.orange,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(fb.employeeName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isPositive ? Colors.green[100] : Colors.orange[100],
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    fb.feedbackType,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: isPositive ? Colors.green[700] : Colors.orange[700],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(3)),
                                  child: const Text('Technical Skills', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.blue)),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.purple[100], borderRadius: BorderRadius.circular(3)),
                                  child: Text('${isPositive ? '5' : '2'}/5', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.purple[700])),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              fb.comment,
                              style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${fb.createdAt.day}/${fb.createdAt.month}, ${fb.createdAt.hour}:${fb.createdAt.minute.toString().padLeft(2, '0')} AM',
                                  style: TextStyle(fontSize: 9, color: Colors.grey[500]),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(3)),
                                  child: const Text('Meeting', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.blue)),
                                ),
                              ],
                            ),
                            if (fb != _localFeedbacks.take(5).last) const Divider(height: 14),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bottom Row: Pending Meetings + Goals Snapshot
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showPendingMeetingsPopup,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Pending Meetings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.purple[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('9', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.purple)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildMeetingItem('P', 'Priya Sharma', 'Requested by none'),
                          const SizedBox(height: 8),
                          _buildMeetingItem('D', 'David Park', 'Requested by none'),
                          const SizedBox(height: 8),
                          _buildMeetingItem('M', 'Marcus Johnson', 'Requested by none'),
                          const SizedBox(height: 8),
                          _buildMeetingItem('J', 'James Bellano', 'Requested by supervisor'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _showGoalsSnapshotPopup,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Goals Snapshot', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              GestureDetector(
                                onTap: _showGoalsSnapshotPopup,
                                child: Text('View all >', style: TextStyle(fontSize: 10, color: Colors.blue[600], fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Text('1', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.blue)),
                                  const Text('Active', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10)),
                                ],
                              ),
                              Container(width: 1, height: 40, color: Colors.grey[300]),
                              Column(
                                children: [
                                  const Text('0', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.green)),
                                  const Text('Done', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10)),
                                ],
                              ),
                              Container(width: 1, height: 40, color: Colors.grey[300]),
                              Column(
                                children: [
                                  const Text('0', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.red)),
                                  const Text('Overdue', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.orange[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Decrease complaint resolution from 72 hours to 24...',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.grey[800]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: 0.34,
                                    minHeight: 4,
                                    backgroundColor: Colors.orange[100],
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[600]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F3A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton('👥 View Team', Colors.grey[400]!),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton('🎯 SMART Goals', Colors.grey[400]!),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton('📋 Generate Review', Colors.grey[400]!),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton('📊 Performance Heatmap', Colors.grey[400]!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            label.contains('TEAM') ? 'Active employees' : label.contains('RATING') ? '18 total entries' : 'this week',
            style: TextStyle(fontSize: 9, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingItem(String initial, String name, String status) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(initial, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Colors.purple[700])),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
              Text(status, style: TextStyle(fontSize: 9, color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.white),
        ),
      ),
    );
  }
}
