import 'package:flutter/material.dart';

// SMART Goals — industry-standard measurable goals.
// Each goal is Specific (title+description), Measurable (metric type + current/
// target values -> auto progress), Achievable/Relevant (owner+category) and
// Time-bound (due date). Managers can add, edit, revise and delete.
class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  static const teal = Color(0xFF0E7C7B);
  static const List<String> _mon = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  static const List<String> _statuses = [
    'In Progress', 'At Risk', 'Partially Achieved', 'Completed', 'Overdue'
  ];

  String _selectedEmployee = 'All Employees';
  String _selectedStatus = 'All';
  String _dateRange = 'All Time';

  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Cut complaint resolution time to 24 hours',
      'description': 'Reduce average patient complaint resolution from 72h to 24h via a triage rota.',
      'owner': 'Aisha Williams',
      'category': 'Customer Success',
      'metricType': 'number',
      'unit': 'hours',
      'currentValue': 48,
      'targetValue': 24,
      'startValue': 72,
      'dueDate': 'Dec 31, 2026',
      'status': 'In Progress',
    },
    {
      'title': 'Improve patient satisfaction to 95%',
      'description': 'Raise the quarterly CSAT score across all clinical touchpoints.',
      'owner': 'Dr. Mehta',
      'category': 'Clinical',
      'metricType': 'percentage',
      'unit': '%',
      'currentValue': 88,
      'targetValue': 95,
      'startValue': 80,
      'dueDate': 'Jan 15, 2027',
      'status': 'In Progress',
    },
    {
      'title': 'Complete quarterly compliance audit',
      'description': 'Finish the full Q3 compliance audit across all departments.',
      'owner': 'Sarah Chen',
      'category': 'Compliance',
      'metricType': 'percentage',
      'unit': '%',
      'currentValue': 25,
      'targetValue': 100,
      'startValue': 0,
      'dueDate': 'Sep 30, 2026',
      'status': 'Overdue',
    },
    {
      'title': 'Reduce medication errors by 50%',
      'description': 'Halve reported medication administration errors vs last quarter baseline.',
      'owner': 'James Peterson',
      'category': 'Safety',
      'metricType': 'number',
      'unit': 'errors',
      'currentValue': 14,
      'targetValue': 10,
      'startValue': 20,
      'dueDate': 'Feb 28, 2027',
      'status': 'At Risk',
    },
    {
      'title': 'Grow telehealth revenue to ₹10,00,000',
      'description': 'Scale the new telehealth line to a million in quarterly revenue.',
      'owner': 'Priya Sharma',
      'category': 'Operations',
      'metricType': 'currency',
      'unit': '₹',
      'currentValue': 1000000,
      'targetValue': 1000000,
      'startValue': 200000,
      'dueDate': 'Nov 30, 2026',
      'status': 'Completed',
    },
    {
      'title': 'Update staff training materials',
      'description': 'Refresh onboarding and annual training decks for all clinical roles.',
      'owner': 'Dr. Kapoor',
      'category': 'Training',
      'metricType': 'number',
      'unit': 'modules',
      'currentValue': 3,
      'targetValue': 20,
      'startValue': 0,
      'dueDate': 'Oct 15, 2026',
      'status': 'Partially Achieved',
    },
  ];

  // ---------- helpers ----------
  String _goalYear(String dueDate) =>
      RegExp(r'(\d{4})').firstMatch(dueDate)?.group(1) ?? '';

  double _progress(Map g) {
    final t = (g['targetValue'] as num).toDouble();
    final c = (g['currentValue'] as num).toDouble();
    final s = (g['startValue'] as num?)?.toDouble() ?? 0;
    if (t == s) return c >= t ? 1 : 0;
    return ((c - s) / (t - s)).clamp(0.0, 1.0);
  }

  String _fmtNum(num n) {
    final s = n.toStringAsFixed(0);
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  }

  // The Measurable readout: current vs target with the right unit.
  String _measure(Map g) {
    final type = g['metricType'];
    final c = g['currentValue'] as num;
    final t = g['targetValue'] as num;
    if (type == 'currency') {
      final sym = (g['unit'] ?? '₹').toString();
      return '$sym${_fmtNum(c)} / $sym${_fmtNum(t)}';
    } else if (type == 'percentage') {
      return '${_fmtNum(c)}% / ${_fmtNum(t)}%';
    }
    final unit = (g['unit'] ?? '').toString();
    return '${_fmtNum(c)} / ${_fmtNum(t)}${unit.isEmpty ? '' : ' $unit'}';
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Completed':
        return Colors.green;
      case 'Overdue':
        return Colors.red;
      case 'At Risk':
        return Colors.deepOrange;
      case 'Partially Achieved':
        return Colors.amber[800]!;
      default:
        return Colors.orange; // In Progress
    }
  }

  List<String> get _ownerOptions =>
      {for (final g in _goals) g['owner'] as String}.toList();

  String _fmtDate(DateTime d) => '${_mon[d.month]} ${d.day}, ${d.year}';

  @override
  Widget build(BuildContext context) {
    final scoped = _goals.where((g) {
      final byEmp = _selectedEmployee == 'All Employees' || g['owner'] == _selectedEmployee;
      final byRange = _dateRange == 'All Time' || _goalYear(g['dueDate']) == _dateRange;
      return byEmp && byRange;
    }).toList();
    final total = scoped.length;
    final inProgress = scoped.where((g) => g['status'] == 'In Progress').length;
    final completed = scoped.where((g) => g['status'] == 'Completed').length;
    final overdue = scoped.where((g) => g['status'] == 'Overdue').length;
    final visibleGoals = _selectedStatus == 'All'
        ? scoped
        : scoped.where((g) => g['status'] == _selectedStatus).toList();

    final employeeOptions = ['All Employees', ..._ownerOptions];
    final years = <String>{};
    for (final g in _goals) {
      final y = _goalYear(g['dueDate']);
      if (y.isNotEmpty) years.add(y);
    }
    final yearOptions = ['All Time', ...(years.toList()..sort())];

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        scrolledUnderElevation: 0,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        title: const Text('SMART Goals',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
        actions: [
          IconButton.filledTonal(
            icon: const Icon(Icons.logout_rounded, size: 18),
            tooltip: 'Logout',
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Track team goals and progress',
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 20),

            // ─── AGGREGATE DASHBOARD (tap a card to filter) ───
            Text('OVERVIEW',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: scheme.onSurfaceVariant, letterSpacing: 0.8)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildKPICard('TOTAL', total.toString(), Icons.adjust_rounded, scheme.primaryContainer, scheme.onPrimaryContainer, 'All')),
                const SizedBox(width: 10),
                Expanded(child: _buildKPICard('IN PROGRESS', inProgress.toString(), Icons.flag_rounded, scheme.tertiaryContainer, scheme.onTertiaryContainer, 'In Progress')),
                const SizedBox(width: 10),
                Expanded(child: _buildKPICard('DONE', completed.toString(), Icons.check_circle_rounded, scheme.secondaryContainer, scheme.onSecondaryContainer, 'Completed')),
                const SizedBox(width: 10),
                Expanded(child: _buildKPICard('OVERDUE', overdue.toString(), Icons.schedule_rounded, scheme.errorContainer, scheme.onErrorContainer, 'Overdue')),
              ],
            ),
            const SizedBox(height: 24),

            // ─── TIMEFRAME ───
            Text('TIMEFRAME',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[500], letterSpacing: 0.5)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: yearOptions
                    .map((y) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(y == 'All Time' ? 'All Time' : 'Due $y'),
                            selected: _dateRange == y,
                            onSelected: (_) => setState(() => _dateRange = y),
                            selectedColor: teal,
                            labelStyle: TextStyle(
                                fontSize: 12,
                                color: _dateRange == y ? Colors.white : Colors.grey[800]),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 18),

            // ─── FILTERS ───
            Text('FILTER BY EMPLOYEE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[500], letterSpacing: 0.5)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButton<String>(
                value: _selectedEmployee,
                isExpanded: true,
                items: employeeOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedEmployee = value ?? 'All Employees'),
                underline: const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 14),
            Text('FILTER BY STATUS',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey[500], letterSpacing: 0.5)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButton<String>(
                value: _selectedStatus,
                isExpanded: true,
                items: ['All', ..._statuses]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedStatus = value ?? 'All'),
                underline: const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 20),

            // ─── GOALS LIST ───
            if (visibleGoals.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text('No goals match these filters',
                      style: TextStyle(color: Colors.grey[500])),
                ),
              )
            else
              ...visibleGoals.map((goal) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildGoalCard(goal),
                  )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGoalDialog(),
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add goal', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }

  // ---------- KPI card ----------
  Widget _buildKPICard(String label, String value, IconData icon, Color bg, Color fg, String statusKey) {
    final selected = _selectedStatus == statusKey;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => setState(() => _selectedStatus = statusKey),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: selected
                ? Border.all(color: fg, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: fg.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: fg, size: 14),
              ),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: fg)),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 9, color: fg.withOpacity(0.8), fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Goal card ----------
  Widget _buildGoalCard(Map<String, dynamic> goal) {
    final scheme = Theme.of(context).colorScheme;
    final status = goal['status'] as String;
    final sc = _statusColor(status);
    final progress = _progress(goal);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.surfaceContainerLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4, right: 8),
                width: 10, height: 10,
                decoration: BoxDecoration(color: sc, shape: BoxShape.circle),
              ),
              Expanded(
                child: Text(goal['title'],
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: sc.withOpacity(0.10),
                  border: Border.all(color: sc.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(status,
                    style: TextStyle(fontSize: 11, color: sc, fontWeight: FontWeight.w700)),
              ),
              // edit + 3-dot
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => _showGoalDialog(existing: goal),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.edit, size: 18, color: Colors.grey),
                      ),
                    ),
                    _goalMenu(goal),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Description (editable via the edit dialog)
          Text(goal['description'] ?? '',
              style: TextStyle(fontSize: 12.5, color: Colors.grey[700], height: 1.35),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(goal['owner'], style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              const SizedBox(width: 12),
              Icon(Icons.tag, size: 12, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(goal['category'], style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(status == 'Completed' ? 'Completed ${goal['dueDate']}' : 'Due ${goal['dueDate']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 12),
          // Measurable: current / target + computed progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_measure(goal),
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              Text('${(progress * 100).round()}%',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: sc)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(sc),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalMenu(Map<String, dynamic> goal) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
      onSelected: (value) {
        if (value == 'edit') {
          _showGoalDialog(existing: goal);
        } else if (value == 'complete') {
          setState(() {
            goal['status'] = 'Completed';
            goal['currentValue'] = goal['targetValue'];
          });
        } else if (value == 'delete') {
          _confirmDelete(goal);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 10), Text('Edit / revise')])),
        PopupMenuItem(value: 'complete', child: Row(children: [Icon(Icons.check_circle, size: 18, color: Colors.green), SizedBox(width: 10), Text('Mark complete')])),
        PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 10), Text('Delete', style: TextStyle(color: Colors.red))])),
      ],
    );
  }

  void _confirmDelete(Map<String, dynamic> goal) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete goal?'),
        content: Text('"${goal['title']}" will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _goals.remove(goal));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Goal deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ---------- Add / Edit dialog ----------
  void _showGoalDialog({Map<String, dynamic>? existing}) {
    final isEdit = existing != null;
    final titleC = TextEditingController(text: existing?['title'] ?? '');
    final descC = TextEditingController(text: existing?['description'] ?? '');
    final categoryC = TextEditingController(text: existing?['category'] ?? '');
    final currentC = TextEditingController(text: existing != null ? '${existing['currentValue']}' : '');
    final targetC = TextEditingController(text: existing != null ? '${existing['targetValue']}' : '');
    final unitC = TextEditingController(text: existing?['unit']?.toString() ?? '');
    String metricType = existing?['metricType'] ?? 'percentage';
    String owner = existing?['owner'] ?? (_ownerOptions.isNotEmpty ? _ownerOptions.first : 'Current User');
    String status = existing?['status'] ?? 'In Progress';
    String dueDate = existing?['dueDate'] ?? '';

    final ownerItems = {..._ownerOptions, owner}.toList();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          // Unit hint adapts to the measurement type.
          String unitLabel;
          String valueHint;
          if (metricType == 'currency') {
            unitLabel = 'Currency symbol (e.g. ₹, \$)';
            valueHint = 'Amount';
            if (unitC.text.isEmpty) unitC.text = '₹';
          } else if (metricType == 'percentage') {
            unitLabel = 'Unit';
            valueHint = '0–100';
            unitC.text = '%';
          } else {
            unitLabel = 'Unit (e.g. patients, modules)';
            valueHint = 'Count';
          }

          Widget field(String label, Widget child) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    child,
                  ],
                ),
              );

          OutlineInputBorder border() =>
              OutlineInputBorder(borderRadius: BorderRadius.circular(8));

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(isEdit ? 'Edit goal' : 'New SMART goal'),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    field('Goal title (Specific)', TextField(
                      controller: titleC,
                      decoration: InputDecoration(
                        hintText: 'What is the goal?',
                        border: border(),
                        suffixIcon: IconButton(
                          tooltip: 'Make SMART',
                          icon: const Icon(Icons.auto_awesome_rounded,
                              color: Color(0xFFA855F7), size: 20),
                          onPressed: () {
                            final polished = _smartTitle(titleC.text);
                            titleC.text = polished;
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text('✨ Title rewritten as SMART goal'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    )),
                    field('Description', TextField(
                      controller: descC,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Add detail / context',
                        border: border(),
                        suffixIcon: IconButton(
                          tooltip: 'AI polish',
                          icon: const Icon(Icons.auto_awesome_rounded,
                              color: Color(0xFFA855F7), size: 20),
                          onPressed: () {
                            final polished =
                                _polishDescription(descC.text, titleC.text);
                            descC.text = polished;
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text('✨ Description polished'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    )),
                    Row(children: [
                      Expanded(
                        child: field('Owner', Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]!), borderRadius: BorderRadius.circular(8)),
                          child: DropdownButton<String>(
                            value: owner, isExpanded: true, underline: const SizedBox.shrink(),
                            items: ownerItems.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (v) => setS(() => owner = v ?? owner),
                          ),
                        )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: field('Category', TextField(controller: categoryC, decoration: InputDecoration(hintText: 'e.g. Clinical', border: border())))),
                    ]),
                    // Measurement type
                    field('How is it measured? (Measurable)', Wrap(
                      spacing: 8,
                      children: [
                        ['percentage', 'Percentage'],
                        ['currency', 'Currency'],
                        ['number', 'Number'],
                      ].map((m) => ChoiceChip(
                            label: Text(m[1]),
                            selected: metricType == m[0],
                            selectedColor: teal,
                            labelStyle: TextStyle(color: metricType == m[0] ? Colors.white : Colors.grey[800], fontSize: 12),
                            onSelected: (_) => setS(() => metricType = m[0]),
                          )).toList(),
                    )),
                    Row(children: [
                      Expanded(child: field('Current', TextField(controller: currentC, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: valueHint, border: border())))),
                      const SizedBox(width: 10),
                      Expanded(child: field('Target', TextField(controller: targetC, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: valueHint, border: border())))),
                    ]),
                    if (metricType != 'percentage')
                      field(unitLabel, TextField(controller: unitC, decoration: InputDecoration(hintText: metricType == 'currency' ? '₹' : 'unit', border: border()))),
                    field('Due date (Time-bound)', InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: DateTime(2026, 7, 1),
                          firstDate: DateTime(2026, 1, 1),
                          lastDate: DateTime(2028, 12, 31),
                        );
                        if (picked != null) setS(() => dueDate = _fmtDate(picked));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]!), borderRadius: BorderRadius.circular(8)),
                        child: Row(children: [
                          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 10),
                          Text(dueDate.isEmpty ? 'Select due date' : dueDate,
                              style: TextStyle(color: dueDate.isEmpty ? Colors.grey[500] : Colors.black87)),
                        ]),
                      ),
                    )),
                    field('Status', Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]!), borderRadius: BorderRadius.circular(8)),
                      child: DropdownButton<String>(
                        value: status, isExpanded: true, underline: const SizedBox.shrink(),
                        items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setS(() => status = v ?? status),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: teal, foregroundColor: Colors.white),
                onPressed: () {
                  if (titleC.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a goal title')));
                    return;
                  }
                  if (targetC.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a target value')));
                    return;
                  }
                  final data = {
                    'title': titleC.text.trim(),
                    'description': descC.text.trim(),
                    'owner': owner,
                    'category': categoryC.text.trim().isEmpty ? 'General' : categoryC.text.trim(),
                    'metricType': metricType,
                    'unit': metricType == 'percentage' ? '%' : (unitC.text.trim().isEmpty ? (metricType == 'currency' ? '₹' : '') : unitC.text.trim()),
                    'currentValue': num.tryParse(currentC.text.trim()) ?? 0,
                    'targetValue': num.tryParse(targetC.text.trim()) ?? 0,
                    'startValue': existing?['startValue'] ?? 0,
                    'dueDate': dueDate.isEmpty ? 'TBD' : dueDate,
                    'status': status,
                  };
                  setState(() {
                    if (isEdit) {
                      existing.clear();
                      existing.addAll(data);
                    } else {
                      _goals.insert(0, data);
                    }
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEdit ? 'Goal updated ✓' : 'Goal added ✓'), backgroundColor: Colors.green),
                  );
                },
                child: Text(isEdit ? 'Save changes' : 'Add goal'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Rewrites a vague goal stub into a SMART (specific, measurable, time-bound) sentence.
  String _smartTitle(String input) {
    final raw = input.trim().toLowerCase();
    if (raw.isEmpty) {
      const templates = [
        'Improve patient satisfaction score from 78% to 88% by end of Q3',
        'Reduce medication documentation errors by 30% within 90 days',
        'Increase team training completion rate to 95% by Sep 30',
        'Cut average ER triage time from 12 min to 8 min over next quarter',
      ];
      return templates[DateTime(2026, 6, 12).millisecondsSinceEpoch %
          templates.length];
    }
    // Keyword-driven SMART rewrites
    if (raw.contains('sales') || raw.contains('revenue')) {
      return 'Increase quarterly revenue by 15% through targeted client outreach by end of Q3';
    }
    if (raw.contains('team') || raw.contains('collab')) {
      return 'Improve team collaboration score from 3.6 to 4.2 via weekly sync rituals by end of Q3';
    }
    if (raw.contains('error') || raw.contains('mistake')) {
      return 'Reduce documentation errors by 30% over the next 90 days through checklist adoption';
    }
    if (raw.contains('patient') || raw.contains('satisfaction')) {
      return 'Lift patient satisfaction score from 78% to 88% by end of Q3 via discharge follow-ups';
    }
    if (raw.contains('train') || raw.contains('learn')) {
      return 'Complete advanced certification module with 90%+ score by end of next quarter';
    }
    if (raw.contains('time') || raw.contains('faster') || raw.contains('reduce')) {
      return 'Reduce average task turnaround time by 25% within the next quarter';
    }
    if (raw.contains('improve') || raw.contains('better')) {
      return '${input.trim()} — measured by a 20% lift in the relevant KPI by end of Q3';
    }
    // Generic: append measurable + time-bound suffix
    var out = input.trim();
    if (out.isNotEmpty) out = out[0].toUpperCase() + out.substring(1);
    return '$out — measurable target with completion by end of Q3 2026';
  }

  // Expand a short description into proper context. Uses the title for hints.
  String _polishDescription(String input, String title) {
    final raw = input.trim();
    if (raw.length < 10) {
      const templates = [
        'Drives measurable improvement in a key performance metric, with quarterly checkpoints to track progress and adjust course as needed.',
        'Aligns with department priorities and supports the broader org strategy. Progress to be reviewed bi-weekly with the manager.',
        'Builds on prior-quarter momentum; defines a concrete outcome with clear acceptance criteria and accountable owner.',
        'Addresses a recurring pain point flagged in recent feedback; success measured against a baseline established this month.',
      ];
      return templates[
          title.hashCode.abs() % templates.length];
    }
    var out = raw;
    if (out.isNotEmpty) out = out[0].toUpperCase() + out.substring(1);
    if (out.isNotEmpty && !RegExp(r'[.!?]$').hasMatch(out)) out += '.';
    return out;
  }
}
