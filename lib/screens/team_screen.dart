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
  static const teal = Color(0xFF0E7C7B);

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

  // Aggregate: avg rating across a manager + all their reports.
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
    final mgrs = managers;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Team', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text('MANAGERS',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[500], letterSpacing: 0.5)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text('Tap a manager to drill into their reports',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: mgrs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _managerCard(mgrs[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _managerCard(Map<String, dynamic> mgr) {
    final name = mgr['name'] as String;
    final reports = reportsOf(name);
    final teamRating = teamAvgRating(name);
    final feedbackCount = teamFeedbackCount(name);
    final initials = name.split(' ').map((p) => p.isEmpty ? '' : p[0]).join().toUpperCase();
    final avatarColor = Colors.primaries[name.hashCode.abs() % Colors.primaries.length];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ManagerReportsScreen(manager: mgr)),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 22, backgroundColor: avatarColor,
                      child: Text(initials,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                        Text(mgr['title'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  _ratingBadge(teamRating, label: 'Team'),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: teal.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _aggStat('${reports.length}', 'Reports'),
                    _divider(),
                    _aggStat(mgr['department'], 'Department'),
                    _divider(),
                    _aggStat('$feedbackCount', 'Feedback'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.people_alt_outlined, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      reports.map((r) => (r['name'] as String).split(' ').last).join(' · '),
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 18, color: Colors.grey[400]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 28, color: Colors.grey[300]);

  Widget _aggStat(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  Widget _ratingBadge(double score, {String? label}) {
    final Color c = score >= 4.5 ? Colors.green[700]! : (score >= 4.0 ? Colors.amber[800]! : Colors.grey[600]!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 13, color: c),
          const SizedBox(width: 3),
          Text(score.toStringAsFixed(1),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c)),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 9, color: c.withOpacity(0.8), fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }
}

// ─── Drilldown: a single manager's direct reports ───
class ManagerReportsScreen extends StatelessWidget {
  final Map<String, dynamic> manager;
  const ManagerReportsScreen({Key? key, required this.manager}) : super(key: key);

  static const teal = Color(0xFF0E7C7B);

  @override
  Widget build(BuildContext context) {
    final mgrName = manager['name'] as String;
    final reports = _TeamScreenState.reportsOf(mgrName)
      ..sort((a, b) => EmployeeFeedbackLogScreen.averageRating(b['name'])
          .compareTo(EmployeeFeedbackLogScreen.averageRating(a['name'])));
    final teamRating = _TeamScreenState.teamAvgRating(mgrName);
    final feedbackCount = _TeamScreenState.teamFeedbackCount(mgrName);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mgrName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            Text("${manager['department']} · ${reports.length} reports",
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Breadcrumb
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Text('Team', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  Icon(Icons.chevron_right, size: 14, color: Colors.grey[400]),
                  Text(mgrName.split(' ').last + "'s team",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            // Aggregate summary
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summary(teamRating.toStringAsFixed(1), 'Team avg', Colors.green),
                  _summary('${reports.length}', 'Reports', Colors.blue),
                  _summary('$feedbackCount', 'Feedback', Colors.orange),
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
                itemBuilder: (_, i) => _staffCard(context, reports[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _staffCard(BuildContext context, Map<String, dynamic> emp) {
    final name = emp['name'] as String;
    final initials = name.split(' ').map((p) => p.isEmpty ? '' : p[0]).join().toUpperCase();
    final rating = EmployeeFeedbackLogScreen.averageRating(name);
    final avatarColor = Colors.primaries[name.hashCode.abs() % Colors.primaries.length];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => EmployeeFeedbackLogScreen(employeeName: name)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.topRight, child: _ratingBadge(rating)),
              Center(
                child: CircleAvatar(radius: 26, backgroundColor: avatarColor,
                    child: Text(initials, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(emp['title'], style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              const Spacer(),
              SizedBox(
                width: double.infinity, height: 30,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => FeedbackScreen(initialEmployee: name),
                  )),
                  icon: const Icon(Icons.add_comment_outlined, size: 13),
                  label: const Text('Feedback', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal, foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingBadge(double score) {
    final Color c = score >= 4.5 ? Colors.green[700]! : (score >= 4.0 ? Colors.amber[800]! : Colors.grey[600]!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 13, color: c),
          const SizedBox(width: 3),
          Text(score.toStringAsFixed(1),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: c)),
        ],
      ),
    );
  }
}
