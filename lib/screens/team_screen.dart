import 'package:flutter/material.dart';
import 'feedback_screen.dart';
import 'employee_feedback_log_screen.dart';

// Two-level org: top tab shows managers (with aggregate stats across
// their reports), tap a manager to drill into that manager's reports.
class TeamScreen extends StatefulWidget {
  const TeamScreen({Key? key}) : super(key: key);

  // Public accessors so other screens (dashboard, etc.) can read the org tree
  // without reaching into the private state class.
  // Rating accessors return null when no feedback exists — callers render blank.
  static List<Map<String, dynamic>> get roster => _TeamScreenState.roster;
  static List<Map<String, dynamic>> get managers => _TeamScreenState.managers;
  static List<Map<String, dynamic>> reportsOf(String name) => _TeamScreenState.reportsOf(name);
  static double? teamAvgRating(String name) => _TeamScreenState.teamAvgRating(name);
  static int teamFeedbackCount(String name) => _TeamScreenState.teamFeedbackCount(name);
  static double? directReportsAvg() => _TeamScreenState.directReportsAvg();

  // ─── ONE source of truth for feedback counts/lists across the app ──
  // Filter by date range, type, and a subset of employee names so the
  // same numbers reconcile on Dashboard + Feedback tab + Team screen.
  static List<Map<String, dynamic>> rosterFeedback({
    DateTime? start,
    DateTime? end,
    String? type,
    List<String>? names,
  }) {
    final list = names ?? roster.map((m) => m['name'] as String).toList();
    final out = <Map<String, dynamic>>[];
    for (final n in list) {
      for (final e in _TeamScreenState.feedbackFor(n)) {
        final d = e['date'] as DateTime;
        final t = e['type'] as String;
        if (type != null && t != type) continue;
        if (start != null && d.isBefore(start)) continue;
        if (end != null && d.isAfter(end)) continue;
        out.add(e);
      }
    }
    out.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return out;
  }

  static int rosterFeedbackCount({
    DateTime? start,
    DateTime? end,
    String? type,
    List<String>? names,
  }) =>
      rosterFeedback(start: start, end: end, type: type, names: names).length;

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  // Filter: 'all' or 'needs_feedback' (managers with sparse / stale feedback)
  String _filter = 'all';

  bool _needsAttention(String name) {
    final log = EmployeeFeedbackLogScreen.logFor(name);
    final today = DateTime(2026, 6, 10);
    DateTime? latest;
    for (final e in log) {
      final d = e['date'] as DateTime?;
      if (d != null && (latest == null || d.isAfter(latest))) latest = d;
    }
    final daysSince = latest == null ? 9999 : today.difference(latest).inDays;
    return log.length < 3 || daysSince > 21;
  }

  // Org roster — managers have manager: null, ICs reference their manager by name.
  // Single source of truth for the whole app's team data.
  static final List<Map<String, dynamic>> roster = [
    // ── Managers (level 1) ──
    {
      'id': 'EMP-002', 'name': 'Dr. James Anderson', 'title': 'Senior Cardiologist',
      'specialty': 'Cardiology', 'department': 'Cardiac Care', 'status': 'On-Shift',
      'qualifications': 'MD, Board Certified - Cardiology',
      'email': 'james.anderson@hospital.com', 'phone': '+1-555-0102',
      'yearsExperience': 18, 'manager': null,
    },
    {
      'id': 'EMP-004', 'name': 'Dr. Michael Chen', 'title': 'Pulmonologist',
      'specialty': 'Pulmonology', 'department': 'Respiratory', 'status': 'On-Call',
      'qualifications': 'MD, Board Certified - Pulmonology',
      'email': 'michael.chen@hospital.com', 'phone': '+1-555-0104',
      'yearsExperience': 12, 'manager': null,
    },
    {
      'id': 'EMP-006', 'name': 'Dr. Robert Martinez', 'title': 'Emergency Medicine Lead',
      'specialty': 'Emergency Medicine', 'department': 'ER', 'status': 'On-Shift',
      'qualifications': 'MD, Board Certified - EM',
      'email': 'robert.martinez@hospital.com', 'phone': '+1-555-0106',
      'yearsExperience': 14, 'manager': null,
    },

    // ── Cardiac Care reports → Dr. James Anderson ──
    {
      'id': 'EMP-003', 'name': 'RN. Emily Rodriguez', 'title': 'Charge Nurse',
      'specialty': 'Surgical Nursing', 'department': 'Cardiac Care', 'status': 'Available',
      'qualifications': 'RN, BSN, CNOR',
      'email': 'emily.rodriguez@hospital.com', 'phone': '+1-555-0103',
      'yearsExperience': 10, 'manager': 'Dr. James Anderson',
    },
    {
      'id': 'EMP-005', 'name': 'RN. Jessica Thompson', 'title': 'ICU Nurse',
      'specialty': 'Critical Care', 'department': 'Cardiac Care', 'status': 'Available',
      'qualifications': 'RN, CCRN, MSN',
      'email': 'jessica.thompson@hospital.com', 'phone': '+1-555-0105',
      'yearsExperience': 8, 'manager': 'Dr. James Anderson',
    },
    {
      'id': 'EMP-007', 'name': 'RN. Priya Sharma', 'title': 'Cardiac Nurse',
      'specialty': 'Cardiology', 'department': 'Cardiac Care', 'status': 'On-Shift',
      'qualifications': 'RN, BSN, CCRN',
      'email': 'priya.sharma@hospital.com', 'phone': '+1-555-0107',
      'yearsExperience': 6, 'manager': 'Dr. James Anderson',
    },

    // ── Respiratory reports → Dr. Michael Chen ──
    {
      'id': 'EMP-008', 'name': 'RT. Alex Kim', 'title': 'Respiratory Therapist',
      'specialty': 'Pulmonary Function', 'department': 'Respiratory', 'status': 'Available',
      'qualifications': 'RRT, BSRC',
      'email': 'alex.kim@hospital.com', 'phone': '+1-555-0108',
      'yearsExperience': 5, 'manager': 'Dr. Michael Chen',
    },
    {
      'id': 'EMP-009', 'name': 'RT. Maya Patel', 'title': 'Senior Respiratory Therapist',
      'specialty': 'Critical Care', 'department': 'Respiratory', 'status': 'On-Shift',
      'qualifications': 'RRT-ACCS, BSRC',
      'email': 'maya.patel@hospital.com', 'phone': '+1-555-0109',
      'yearsExperience': 9, 'manager': 'Dr. Michael Chen',
    },

    // ── ER reports → Dr. Robert Martinez ──
    {
      'id': 'EMP-010', 'name': 'RN. Carlos Rivera', 'title': 'ER Triage Nurse',
      'specialty': 'Emergency', 'department': 'ER', 'status': 'On-Shift',
      'qualifications': 'RN, CEN',
      'email': 'carlos.rivera@hospital.com', 'phone': '+1-555-0110',
      'yearsExperience': 7, 'manager': 'Dr. Robert Martinez',
    },
    {
      'id': 'EMP-011', 'name': 'RN. Nina Brooks', 'title': 'ER Charge Nurse',
      'specialty': 'Emergency', 'department': 'ER', 'status': 'On-Call',
      'qualifications': 'RN, CEN, MSN',
      'email': 'nina.brooks@hospital.com', 'phone': '+1-555-0111',
      'yearsExperience': 11, 'manager': 'Dr. Robert Martinez',
    },
  ];

  // Managers, sorted by their team's average rating (top first); managers
  // with no team feedback at all sort to the bottom.
  static List<Map<String, dynamic>> get managers =>
      roster.where((e) => e['manager'] == null).toList()
        ..sort((a, b) {
          final av = teamAvgRating(a['name'] as String);
          final bv = teamAvgRating(b['name'] as String);
          if (av == null && bv == null) return 0;
          if (av == null) return 1;
          if (bv == null) return -1;
          return bv.compareTo(av);
        });

  static List<Map<String, dynamic>> reportsOf(String managerName) =>
      roster.where((e) => e['manager'] == managerName).toList();

  // Returns the per-employee feedback log with employeeName attached on
  // each entry — used to aggregate across the roster consistently.
  static List<Map<String, dynamic>> feedbackFor(String name) {
    return EmployeeFeedbackLogScreen.logFor(name)
        .map((e) => {...e, 'employeeName': name})
        .toList();
  }

  // Team avg = average across the manager's REPORTS only (not the manager
  // themselves). Reports with no feedback yet are excluded from the avg —
  // returns null if NO report has any feedback.
  static double? teamAvgRating(String managerName) {
    final scores = reportsOf(managerName)
        .map((e) => EmployeeFeedbackLogScreen.averageRating(e['name'] as String))
        .whereType<double>()
        .toList();
    if (scores.isEmpty) return null;
    return double.parse((scores.reduce((a, b) => a + b) / scores.length).toStringAsFixed(1));
  }

  // Feedback count across the manager's reports only.
  static int teamFeedbackCount(String managerName) {
    final reports = reportsOf(managerName).map((e) => e['name'] as String);
    return reports.fold<int>(0, (a, n) => a + EmployeeFeedbackLogScreen.logFor(n).length);
  }

  // Avg across just the top-level managers (your direct line if you're James).
  // Managers with no feedback yet are excluded; null if none have any.
  static double? directReportsAvg() {
    final scores = managers
        .map((m) => EmployeeFeedbackLogScreen.averageRating(m['name'] as String))
        .whereType<double>()
        .toList();
    if (scores.isEmpty) return null;
    return double.parse((scores.reduce((a, b) => a + b) / scores.length).toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mgrs = managers;
    final totalReports = mgrs.fold<int>(0, (a, m) => a + reportsOf(m['name']).length);

    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        // Tab use → no leading; pushed (from rollup) → back arrow appears.
        automaticallyImplyLeading: canPop,
        title: const Text('Team',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text("Tap a direct report to see their feedback or their team",
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 20),

            // ── Aggregate strip ──
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Builder(builder: (_) {
                final teamAvg = directReportsAvg();
                final teamAvgLabel = teamAvg?.toStringAsFixed(1) ?? '—';
                return Row(
                  children: [
                    _topStat(scheme, '${mgrs.length}', 'Direct', scheme.primary),
                    _vDiv(scheme),
                    _topStat(scheme, '$totalReports', 'Indirect', scheme.tertiary),
                    _vDiv(scheme),
                    _topStat(scheme, '${mgrs.length + totalReports}', 'Total', scheme.secondary),
                    _vDiv(scheme),
                    _topStat(scheme, teamAvgLabel, 'Team avg',
                        const Color(0xFFE0C04A), withStar: true),
                  ],
                );
              }),
            ),
            const SizedBox(height: 22),

            Row(
              children: [
                Text('YOUR DIRECT REPORTS',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                        color: scheme.onSurfaceVariant, letterSpacing: 0.8)),
                const Spacer(),
                if (mgrs.any((m) => _needsAttention(m['name'] as String)))
                  Text(
                      '${mgrs.where((m) => _needsAttention(m['name'] as String)).length} need attention',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFB07E1B))),
              ],
            ),
            const SizedBox(height: 8),
            // ── Filter chips ──
            Row(
              children: [
                _filterChip(scheme, 'All', 'all'),
                const SizedBox(width: 6),
                _filterChip(scheme, 'Needs feedback', 'needs_feedback'),
              ],
            ),
            const SizedBox(height: 12),

            ...mgrs
                .where((m) =>
                    _filter == 'all' || _needsAttention(m['name'] as String))
                .map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _managerCard(m, scheme),
                    )),
          ],
        ),
      ),
    );
  }

  Widget _vDiv(ColorScheme scheme) =>
      Container(width: 1, height: 36, color: scheme.outlineVariant);

  Widget _filterChip(ColorScheme scheme, String label, String value) {
    final selected = _filter == value;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _filter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: selected ? scheme.onPrimary : scheme.onSurfaceVariant)),
      ),
    );
  }

  Widget _topStat(ColorScheme scheme, String value, String label, Color accent,
      {bool withStar = false}) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (withStar) ...[
                Icon(Icons.star_rounded, size: 16, color: accent),
                const SizedBox(width: 2),
              ],
              Text(value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: accent)),
            ],
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _managerCard(Map<String, dynamic> mgr, ColorScheme scheme) {
    final name = mgr['name'] as String;
    final reports = reportsOf(name);
    final teamRating = teamAvgRating(name);
    final personalRating = EmployeeFeedbackLogScreen.averageRating(name);
    final personalLog = EmployeeFeedbackLogScreen.logFor(name);
    final feedbackCount = teamFeedbackCount(name);
    final initials = name.split(' ').map((p) => p.isEmpty ? '' : p[0]).join().toUpperCase();

    // ── "Needs attention" computation ──
    // Demo today is 2026-06-10. Flag if last feedback > 21 days or < 3 entries.
    final today = DateTime(2026, 6, 10);
    DateTime? latest;
    for (final e in personalLog) {
      final d = e['date'] as DateTime?;
      if (d != null && (latest == null || d.isAfter(latest))) latest = d;
    }
    final daysSince = latest == null ? 9999 : today.difference(latest).inDays;
    final needsAttention =
        personalLog.length < 3 || daysSince > 21;
    final flagReason = personalLog.length < 3
        ? 'Only ${personalLog.length} feedback ${personalLog.length == 1 ? "entry" : "entries"}'
        : 'Last feedback $daysSince days ago';

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        // Tap manager card → manager's OWN feedback log (primary).
        // Team drilldown is a secondary action from inside that log.
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => EmployeeFeedbackLogScreen(employeeName: name)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: scheme.primaryContainer,
                    child: Text(initials,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                            color: scheme.onPrimaryContainer)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: scheme.onSurface)),
                        Text(mgr['title'], style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Personal rating — primary (what's most important per user)
                      _ratingBadge(personalRating, scheme, label: 'Personal'),
                      const SizedBox(height: 4),
                      // Team avg — secondary, smaller
                      _ratingBadge(teamRating, scheme, label: 'Team avg'),
                    ],
                  ),
                ],
              ),
              if (needsAttention) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6B43A).withOpacity(0.14),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE6B43A).withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flag_circle_rounded,
                          size: 16, color: Color(0xFFB07E1B)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Needs feedback · $flagReason',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFB07E1B)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Tappable → drill into reports list
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => ManagerReportsScreen(manager: mgr)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: _aggStat(scheme,
                            '${reports.length}', 'Reports',
                            interactive: true),
                      ),
                    ),
                    _innerDiv(scheme),
                    _aggStat(scheme, mgr['department'], 'Dept'),
                    _innerDiv(scheme),
                    _aggStat(scheme, '$feedbackCount',
                        feedbackCount == 1 ? 'Feedback' : 'Feedbacks'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _innerDiv(ColorScheme scheme) =>
      Container(width: 1, height: 28, color: scheme.outlineVariant);

  Widget _aggStat(ColorScheme scheme, String value, String label,
      {bool interactive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: interactive ? scheme.primary : scheme.onSurface)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: interactive
                        ? scheme.primary.withOpacity(0.8)
                        : scheme.onSurfaceVariant,
                    fontWeight: interactive ? FontWeight.w700 : FontWeight.w500)),
            if (interactive)
              Icon(Icons.chevron_right_rounded,
                  size: 12, color: scheme.primary),
          ],
        ),
      ],
    );
  }
}

// ─── Shared rating badge — no background pill; color tells the story ───
// Color thresholds match the 5-zone heatmap palette:
//   >=4.5 deep green (Excellent), >=4.0 light green (Healthy),
//   >=3.5 sky blue (Steady), >=3.0 warm amber (Watch), <3.0 soft coral.
Widget _ratingBadge(double? score, ColorScheme scheme, {String? label}) {
  if (score == null) {
    final c = scheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.remove_rounded, size: 13, color: c),
        const SizedBox(width: 4),
        Text('No feedback',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: c)),
      ],
    );
  }
  Color c;
  if (score >= 4.5) {
    c = const Color(0xFF3DA66E); // Excellent (deep green)
  } else if (score >= 4.0) {
    c = const Color(0xFFA8C977); // Healthy (light green)
  } else if (score >= 3.5) {
    c = const Color(0xFFE0C04A); // Steady (mellow yellow)
  } else if (score >= 3.0) {
    c = const Color(0xFFEBB57A); // Watch (warm peach)
  } else {
    c = const Color(0xFFE89A6B); // At-risk (soft orange)
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.star_rounded, size: 15, color: c),
      const SizedBox(width: 4),
      Text(score.toStringAsFixed(1),
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w900, color: c)),
      if (label != null) ...[
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
                fontSize: 10,
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600)),
      ],
    ],
  );
}

// ─── Drilldown: a single manager's direct reports ───
class ManagerReportsScreen extends StatelessWidget {
  final Map<String, dynamic> manager;
  const ManagerReportsScreen({Key? key, required this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mgrName = manager['name'] as String;
    final reports = _TeamScreenState.reportsOf(mgrName)
      ..sort((a, b) {
        final av = EmployeeFeedbackLogScreen.averageRating(a['name'] as String);
        final bv = EmployeeFeedbackLogScreen.averageRating(b['name'] as String);
        if (av == null && bv == null) return 0;
        if (av == null) return 1;
        if (bv == null) return -1;
        return bv.compareTo(av);
      });
    final teamRating = _TeamScreenState.teamAvgRating(mgrName);
    final feedbackCount = _TeamScreenState.teamFeedbackCount(mgrName);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mgrName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            Text("${manager['department']} · ${reports.length} reports",
                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Breadcrumb
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: [
                  Text('Team', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                  Icon(Icons.chevron_right_rounded, size: 14, color: scheme.onSurfaceVariant),
                  Text("${mgrName.split(' ').last}'s team",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: scheme.onSurface)),
                ],
              ),
            ),
            // Aggregate hero
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
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
              child: Row(
                children: [
                  _heroStat(teamRating?.toStringAsFixed(1) ?? '—', 'Team avg', scheme.onPrimaryContainer),
                  _heroDiv(scheme),
                  _heroStat('${reports.length}', 'Reports', scheme.onPrimaryContainer),
                  _heroDiv(scheme),
                  _heroStat('$feedbackCount', 'Feedback', scheme.onPrimaryContainer),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.78,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: reports.length,
                itemBuilder: (_, i) => _staffCard(context, reports[i], scheme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroDiv(ColorScheme scheme) =>
      Container(width: 1, height: 32, color: scheme.onPrimaryContainer.withOpacity(0.2));

  Widget _heroStat(String value, String label, Color fg) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: fg)),
          Text(label, style: TextStyle(fontSize: 11, color: fg.withOpacity(0.75))),
        ],
      ),
    );
  }

  Widget _staffCard(BuildContext context, Map<String, dynamic> emp, ColorScheme scheme) {
    final name = emp['name'] as String;
    final initials = name.split(' ').map((p) => p.isEmpty ? '' : p[0]).join().toUpperCase();
    final rating = EmployeeFeedbackLogScreen.averageRating(name);

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => EmployeeFeedbackLogScreen(employeeName: name)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.topRight, child: _ratingBadge(rating, scheme)),
              Center(
                child: CircleAvatar(
                    radius: 26,
                    backgroundColor: scheme.secondaryContainer,
                    child: Text(initials,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800,
                            color: scheme.onSecondaryContainer))),
              ),
              const SizedBox(height: 8),
              Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: scheme.onSurface),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(emp['title'], style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              const Spacer(),
              SizedBox(
                width: double.infinity, height: 34,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => FeedbackScreen(initialEmployee: name),
                  )),
                  icon: const Icon(Icons.add_comment_rounded, size: 13),
                  label: const Text('Feedback', style: TextStyle(fontSize: 11)),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
