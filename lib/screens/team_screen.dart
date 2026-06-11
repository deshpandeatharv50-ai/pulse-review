import 'package:flutter/material.dart';
import 'feedback_screen.dart';
import 'employee_feedback_log_screen.dart';

// Two-level org: top tab shows managers (with aggregate stats across
// their reports), tap a manager to drill into that manager's reports.
class TeamScreen extends StatefulWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
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

  static List<Map<String, dynamic>> get managers =>
      roster.where((e) => e['manager'] == null).toList();

  static List<Map<String, dynamic>> reportsOf(String managerName) =>
      roster.where((e) => e['manager'] == managerName).toList();

  static double teamAvgRating(String managerName) {
    final names = [managerName, ...reportsOf(managerName).map((e) => e['name'] as String)];
    final scores = names.map(EmployeeFeedbackLogScreen.averageRating).toList();
    if (scores.isEmpty) return 0;
    return double.parse((scores.reduce((a, b) => a + b) / scores.length).toStringAsFixed(1));
  }

  static int teamFeedbackCount(String managerName) {
    final names = [managerName, ...reportsOf(managerName).map((e) => e['name'] as String)];
    return names.fold<int>(0, (a, n) => a + EmployeeFeedbackLogScreen.logFor(n).length);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mgrs = managers;
    final totalReports = mgrs.fold<int>(0, (a, m) => a + reportsOf(m['name']).length);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // ── Header ──
            Text('Team',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: scheme.onSurface)),
            const SizedBox(height: 4),
            Text('Tap a manager to drill into their reports',
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 20),

            // ── Aggregate strip ──
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  _topStat(scheme, '${mgrs.length}', 'Managers', scheme.primary),
                  _vDiv(scheme),
                  _topStat(scheme, '$totalReports', 'Reports', scheme.tertiary),
                  _vDiv(scheme),
                  _topStat(scheme, '${mgrs.length + totalReports}', 'Total', scheme.secondary),
                ],
              ),
            ),
            const SizedBox(height: 22),

            Text('MANAGERS',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                    color: scheme.onSurfaceVariant, letterSpacing: 0.8)),
            const SizedBox(height: 10),

            ...mgrs.map((m) => Padding(
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

  Widget _topStat(ColorScheme scheme, String value, String label, Color accent) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: accent)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _managerCard(Map<String, dynamic> mgr, ColorScheme scheme) {
    final name = mgr['name'] as String;
    final reports = reportsOf(name);
    final teamRating = teamAvgRating(name);
    final feedbackCount = teamFeedbackCount(name);
    final initials = name.split(' ').map((p) => p.isEmpty ? '' : p[0]).join().toUpperCase();

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ManagerReportsScreen(manager: mgr)),
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
                  _ratingBadge(teamRating, scheme, label: 'Team'),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _aggStat(scheme, '${reports.length}', 'Reports'),
                    _innerDiv(scheme),
                    _aggStat(scheme, mgr['department'], 'Dept'),
                    _innerDiv(scheme),
                    _aggStat(scheme, '$feedbackCount', 'Feedback'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.people_alt_rounded, size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      reports.map((r) => (r['name'] as String).split(' ').last).join(' · '),
                      style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 18, color: scheme.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _innerDiv(ColorScheme scheme) =>
      Container(width: 1, height: 28, color: scheme.outlineVariant);

  Widget _aggStat(ColorScheme scheme, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: scheme.onSurface)),
        Text(label, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

// ─── Shared rating badge (used by Team + ManagerReports + drilldown) ───
Widget _ratingBadge(double score, ColorScheme scheme, {String? label}) {
  final Color c = score >= 4.5
      ? Colors.green.shade700
      : (score >= 4.0 ? Colors.amber.shade800 : scheme.onSurfaceVariant);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: c.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 14, color: c),
        const SizedBox(width: 3),
        Text(score.toStringAsFixed(1),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: c)),
        if (label != null) ...[
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 9, color: c.withOpacity(0.8), fontWeight: FontWeight.w700)),
        ],
      ],
    ),
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
      ..sort((a, b) => EmployeeFeedbackLogScreen.averageRating(b['name'])
          .compareTo(EmployeeFeedbackLogScreen.averageRating(a['name'])));
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
                  _heroStat(teamRating.toStringAsFixed(1), 'Team avg', scheme.onPrimaryContainer),
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
