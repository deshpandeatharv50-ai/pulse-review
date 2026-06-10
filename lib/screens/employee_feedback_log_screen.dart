import 'package:flutter/material.dart';

// Per-employee feedback log — every feedback entry for one person,
// sorted newest first. Opened by tapping a team member's card.
class EmployeeFeedbackLogScreen extends StatelessWidget {
  final String employeeName;
  const EmployeeFeedbackLogScreen({Key? key, required this.employeeName}) : super(key: key);

  static const teal = Color(0xFF0E7C7B);
  static const List<String> _mon = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // Deterministic sample history for this employee (stable per name).
  List<Map<String, dynamic>> get _log {
    final seed = employeeName.hashCode.abs();
    const positives = [
      'Strong clinical judgment and clear patient communication.',
      'Excellent teamwork during the night shift rotation.',
      'Handled a difficult family conversation with real empathy.',
      'Proactively flagged a safety risk before it escalated.',
      'Consistently thorough documentation this cycle.',
    ];
    const constructives = [
      'Documentation was late on two handovers — tighten turnaround.',
      'Consider delegating more during peak load.',
      'Follow up on the pending compliance training module.',
      'Presentation could be more structured next time.',
    ];
    final entries = <Map<String, dynamic>>[];
    final count = 4 + (seed % 3); // 4–6 entries
    var day = DateTime(2026, 6, 8, 9 + (seed % 8), (seed % 60));
    for (var i = 0; i < count; i++) {
      final isPos = ((seed >> i) & 1) == 0;
      final list = isPos ? positives : constructives;
      entries.add({
        'type': isPos ? 'Positive' : 'Constructive',
        'comment': list[(seed + i) % list.length],
        'date': day,
      });
      day = day.subtract(Duration(days: 12 + ((seed + i) % 20)));
    }
    entries.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final log = _log;
    final positive = log.where((e) => e['type'] == 'Positive').length;
    final constructive = log.length - positive;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(employeeName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const Text('Feedback log', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat('Total', log.length.toString(), Colors.blue),
                _stat('Positive', positive.toString(), Colors.green),
                _stat('Constructive', constructive.toString(), Colors.orange),
              ],
            ),
          ),
          Expanded(
            child: log.isEmpty
                ? Center(child: Text('No feedback yet', style: TextStyle(color: Colors.grey[500])))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: log.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _row(log[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _row(Map<String, dynamic> e) {
    final isPositive = e['type'] == 'Positive';
    final accent = isPositive ? Colors.green : Colors.orange;
    final textColor = isPositive ? Colors.green[700]! : Colors.orange[800]!;
    final d = e['date'] as DateTime;
    final when =
        '${_mon[d.month]} ${d.day}, ${d.year} · ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return Container(
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
            width: 4, height: 40,
            decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(e['type'],
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textColor)),
                ),
                const SizedBox(height: 6),
                Text(e['comment'],
                    style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.4)),
                const SizedBox(height: 6),
                Text(when, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
