import 'package:flutter/material.dart';
import 'team_screen.dart';

// Per-employee feedback log — every feedback entry for one person,
// sorted newest first. Opened by tapping a team member's card.
// If the person manages others, surfaces a "My team" drilldown card.
class EmployeeFeedbackLogScreen extends StatelessWidget {
  final String employeeName;
  const EmployeeFeedbackLogScreen({Key? key, required this.employeeName}) : super(key: key);

  static const teal = Color(0xFF0E7C7B);
  static const List<String> _mon = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // Single source of truth for sample feedback per employee — used by
  // the team card rating badge AND this log so they stay in sync.
  static List<Map<String, dynamic>> logFor(String employeeName) {
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
      final r = isPos
          ? 4.2 + ((seed + i * 7) % 9) / 10.0
          : 2.5 + ((seed + i * 11) % 13) / 10.0;
      entries.add({
        'type': isPos ? 'Positive' : 'Constructive',
        'comment': list[(seed + i) % list.length],
        'date': day,
        'rating': double.parse(r.toStringAsFixed(1)),
      });
      day = day.subtract(Duration(days: 12 + ((seed + i) % 20)));
    }
    entries.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return entries;
  }

  // Returns null when the employee has no feedback yet — callers should
  // render a blank ("—") and exclude this person from any roll-up average.
  static double? averageRating(String employeeName) {
    final l = logFor(employeeName);
    if (l.isEmpty) return null;
    final sum = l.fold<double>(0, (a, e) => a + (e['rating'] as double));
    return double.parse((sum / l.length).toStringAsFixed(1));
  }

  List<Map<String, dynamic>> get _log => logFor(employeeName);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final log = _log;
    final positive = log.where((e) => e['type'] == 'Positive').length;
    final constructive = log.length - positive;
    final avg = averageRating(employeeName);
    final initials = employeeName.split(' ').map((p) => p.isEmpty ? '' : p[0]).join().toUpperCase();

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        title: const Text('Feedback log',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // ── M3 hero card for the employee ──
          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primaryContainer,
                  Color.lerp(scheme.primaryContainer, scheme.tertiaryContainer, 0.5)!,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: scheme.primary,
                      child: Text(initials,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employeeName,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: scheme.onPrimaryContainer)),
                          Text('Career feedback timeline',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: scheme.onPrimaryContainer.withOpacity(0.75))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              size: 14, color: scheme.onPrimaryContainer),
                          const SizedBox(width: 3),
                          Text(avg?.toStringAsFixed(1) ?? '—',
                              style: TextStyle(
                                  color: scheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _heroStat('${log.length}', 'Total', scheme.onPrimaryContainer),
                    _heroDiv(scheme),
                    _heroStat('$positive', 'Positive', scheme.onPrimaryContainer),
                    _heroDiv(scheme),
                    _heroStat('$constructive', 'Constructive', scheme.onPrimaryContainer),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('TIMELINE',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 0.8)),
          const SizedBox(height: 10),
          if (log.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text('No feedback yet',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
              ),
            )
          else
            ...log.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _row(e, scheme),
                )),
        ],
      ),
    );
  }

  Widget _heroDiv(ColorScheme scheme) => Container(
      width: 1,
      height: 28,
      color: scheme.onPrimaryContainer.withOpacity(0.2));

  Widget _heroStat(String value, String label, Color fg) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, color: fg)),
          Text(label,
              style: TextStyle(fontSize: 11, color: fg.withOpacity(0.75))),
        ],
      ),
    );
  }

  Widget _row(Map<String, dynamic> e, ColorScheme scheme) {
    final isPositive = e['type'] == 'Positive';
    final accentBg = isPositive ? scheme.secondaryContainer : scheme.errorContainer;
    final accentFg = isPositive ? scheme.onSecondaryContainer : scheme.onErrorContainer;
    final d = e['date'] as DateTime;
    final when =
        '${_mon[d.month]} ${d.day}, ${d.year} · ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isPositive ? Icons.favorite_rounded : Icons.lightbulb_rounded,
                        size: 12, color: accentFg),
                    const SizedBox(width: 4),
                    Text(e['type'],
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: accentFg)),
                  ],
                ),
              ),
              const Spacer(),
              Text(when,
                  style: TextStyle(
                      fontSize: 10, color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 10),
          Text(e['comment'],
              style: TextStyle(
                  fontSize: 13.5, color: scheme.onSurface, height: 1.4)),
        ],
      ),
    );
  }
}
