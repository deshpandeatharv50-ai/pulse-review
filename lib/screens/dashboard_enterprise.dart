import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/feedback.dart';
import 'team_screen.dart';
import 'employee_feedback_log_screen.dart';
import 'goals_screen.dart';
import 'reviews_advanced_classic.dart';

// CALM CLINICAL DASHBOARD
// Light/teal, big 2x2 KPI cards, a "Today's Focus" triage list, and a thin
// recent-activity strip. Everything reacts to the quarter range filter.
enum DashRange { current, last }

class DashboardEnterprise extends StatefulWidget {
  const DashboardEnterprise({Key? key}) : super(key: key);

  @override
  State<DashboardEnterprise> createState() => _DashboardEnterpriseState();
}

class _DashboardEnterpriseState extends State<DashboardEnterprise> {
  DashRange _range = DashRange.current;
  bool _heroShowsTeam = true; // true = Team pulse (3 direct), false = Org pulse (all 10)
  final Set<String> _expandedManagers = {};

  static const Color _teal = Color(0xFF0E7C7B);
  static const Color _green = Color(0xFF1D9E75);
  static const Color _amber = Color(0xFFBA7517);
  static const Color _ink = Color(0xFF16302B);

  // Fixed "today" so demo quarters stay stable.
  static final DateTime _today = DateTime(2026, 6, 10);

  static const List<String> _mon = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  List<FeedbackItem> get _allFeedbacks => [
        // ---- Current quarter (Q2 2026: Apr–Jun) ----
        FeedbackItem(id: '1', employeeName: 'Priya Sharma', feedbackType: 'Positive',
            comment: 'Great job on technical skills and overall performance',
            createdAt: DateTime(2026, 6, 8, 18, 44)),
        FeedbackItem(id: '2', employeeName: 'Carlos Rivera', feedbackType: 'Constructive',
            comment: 'There may have been an issue with your submission. Please share the original notes.',
            createdAt: DateTime(2026, 6, 6, 16, 44)),
        FeedbackItem(id: '3', employeeName: 'Aisha Williams', feedbackType: 'Positive',
            comment: 'Your positive attitude with the VP of Marketing was commendable',
            createdAt: DateTime(2026, 6, 5, 20, 44)),
        FeedbackItem(id: '4', employeeName: 'David Park', feedbackType: 'Constructive',
            comment: 'The redesign could benefit from refinement. There is real potential here.',
            createdAt: DateTime(2026, 6, 2, 9, 12)),
        FeedbackItem(id: '5', employeeName: 'Marcus Johnson', feedbackType: 'Constructive',
            comment: 'Technical skills need work. Please focus on the fundamentals.',
            createdAt: DateTime(2026, 5, 20, 11, 30)),
        // ---- Last quarter (Q1 2026: Jan–Mar) ----
        FeedbackItem(id: '6', employeeName: 'James Bellano', feedbackType: 'Constructive',
            comment: 'Presentation lacked structure. Prepare visuals ahead of time.',
            createdAt: DateTime(2026, 3, 12, 14, 5)),
        FeedbackItem(id: '7', employeeName: 'Nina Patel', feedbackType: 'Positive',
            comment: 'Excellent patient handover and documentation this cycle.',
            createdAt: DateTime(2026, 2, 18, 10, 20)),
        FeedbackItem(id: '8', employeeName: 'Ravi Kumar', feedbackType: 'Positive',
            comment: 'Strong leadership covering the night shift rotation.',
            createdAt: DateTime(2026, 2, 3, 8, 15)),
      ];

  DateTimeRange get _activeRange {
    final qStartMonth = ((_today.month - 1) ~/ 3) * 3 + 1;
    final currentStart = DateTime(_today.year, qStartMonth, 1);
    if (_range == DashRange.current) {
      final end = DateTime(_today.year, qStartMonth + 3, 1).subtract(const Duration(days: 1));
      return DateTimeRange(start: currentStart, end: end);
    } else {
      final lastStart = DateTime(_today.year, qStartMonth - 3, 1);
      final lastEnd = currentStart.subtract(const Duration(days: 1));
      return DateTimeRange(start: lastStart, end: lastEnd);
    }
  }

  String get _rangeLabel {
    final r = _activeRange;
    return '${_mon[r.start.month]} – ${_mon[r.end.month]} ${r.end.year}';
  }

  List<FeedbackItem> get _filtered {
    final r = _activeRange;
    final start = r.start;
    final end = r.end.add(const Duration(days: 1));
    return _allFeedbacks
        .where((f) =>
            f.createdAt != null &&
            f.createdAt!.isAfter(start.subtract(const Duration(seconds: 1))) &&
            f.createdAt!.isBefore(end))
        .toList()
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }

  int get _teamMembers => _range == DashRange.current ? 10 : 8;
  int get _overdueGoals => _range == DashRange.current ? 1 : 0;
  int get _pendingMeetings => _range == DashRange.current ? 2 : 1;

  @override
  Widget build(BuildContext context) {
    // ── Consolidated feedback source: aggregate from roster per active range
    // and active scope (Team = managers only, Org = whole roster).
    final r = _activeRange;
    final scopeNames = _heroShowsTeam
        ? TeamScreen.managers.map((m) => m['name'] as String).toList()
        : TeamScreen.roster.map((m) => m['name'] as String).toList();
    final positive = TeamScreen.rosterFeedbackCount(
        start: r.start,
        end: r.end.add(const Duration(days: 1)),
        type: 'Positive',
        names: scopeNames);
    final constructive = TeamScreen.rosterFeedbackCount(
        start: r.start,
        end: r.end.add(const Duration(days: 1)),
        type: 'Constructive',
        names: scopeNames);
    // Org-wide avg used only by hero (Org pulse). Team pulse uses
    // directReportsAvg() unchanged.
    final fbForAvg = TeamScreen.rosterFeedback(
        start: r.start,
        end: r.end.add(const Duration(days: 1)),
        names: TeamScreen.roster.map((m) => m['name'] as String).toList());
    final totalForAvg = fbForAvg.length;
    final posForAvg =
        fbForAvg.where((e) => e['type'] == 'Positive').length;
    final conForAvg = totalForAvg - posForAvg;
    final avg = totalForAvg == 0
        ? 0.0
        : (posForAvg * 5 + conForAvg * 3) / totalForAvg;
    // For "Wins this quarter" + recent activity strip, we still use the
    // legacy static feedback list filtered by date (those are demo entries
    // with rich comments that the snapshot card doesn't need).
    final fb = _filtered;
    final constructiveList = fb.where((f) => f.feedbackType == 'Constructive').toList();
    final focusName = constructiveList.isNotEmpty
        ? constructiveList.first.employeeName
        : (fb.isNotEmpty ? fb.first.employeeName : 'your team');

    final scheme = Theme.of(context).colorScheme;
    // In team mode, Wins are filtered to people in MY direct line
    // (managers + their reports). In org mode, all positives.
    final teamNames = {
      for (final m in TeamScreen.managers) m['name'] as String,
      for (final m in TeamScreen.managers)
        ...TeamScreen.reportsOf(m['name'] as String).map((r) => r['name'] as String),
    };
    final positives = fb
        .where((f) =>
            f.feedbackType == 'Positive' &&
            (!_heroShowsTeam || teamNames.contains(f.employeeName)))
        .toList();
    // Two distinct pulse scores: Team (direct reports) vs Org (everyone)
    final orgPulse = avg; // org-wide feedback avg
    final teamPulse = TeamScreen.directReportsAvg() ?? 0.0; // direct reports personal avg
    final pulseScore = _heroShowsTeam ? teamPulse : orgPulse;
    // Synthetic last-quarter score so the trend chip has something to say.
    final lastQuarterScore = _range == DashRange.current
        ? (_heroShowsTeam ? 3.7 : 3.6)
        : (_heroShowsTeam ? 3.5 : 3.4);
    final delta = pulseScore - lastQuarterScore;
    final heroZone = _zoneIndex(pulseScore);
    final heroZoneColor = _heatColors[heroZone];
    final heroZoneLabel = _heatLabels[heroZone];
    // Trend semantics: up = good (soft green); down = warning (warm amber).
    final trendUp = delta >= 0;
    final trendColor = trendUp
        ? const Color(0xFF5BB880)
        : const Color(0xFFE6B43A);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Greeting + logout ───
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: scheme.primaryContainer,
                    child: Text('JP',
                        style: TextStyle(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                            fontSize: 14)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Good afternoon, James Peterson',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface)),
                        Text('CMO Admin · Central Medical Group',
                            style: TextStyle(
                                fontSize: 11, color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    onPressed: () async {
                      try { await Supabase.instance.client.auth.signOut(); } catch (_) {}
                      if (mounted) Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ─── Period chip first (timeframe context comes before scope) ──
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_periodChip(scheme)],
              ),
              const SizedBox(height: 10),
              // ─── Then the scope toggle below ──
              _globalScopeToggle(scheme),
              const SizedBox(height: 14),

              // ─── ONE merged "pulse" card: hero + snapshot connected with
              // an internal divider. Top accent = scope color (Team=teal,
              // Org=amber) so the active scope is unmistakable.
              Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                  border: Border(
                      top: BorderSide(
                          color: _heroShowsTeam
                              ? scheme.primary
                              : const Color(0xFF2C3E40),
                          width: 4)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scope label + range
                    Row(
                      children: [
                        Text(_heroShowsTeam ? 'TEAM PULSE' : 'ORG PULSE',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: scheme.onSurfaceVariant)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: heroZoneColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(heroZoneLabel.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0)),
                        ),
                        const Spacer(),
                        Text(_rangeLabel,
                            style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // ── Right-aligned ticker line ──
                    Builder(builder: (_) {
                      final sign = trendUp ? '+' : '−';
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(pulseScore.toStringAsFixed(1),
                              style: TextStyle(
                                  color: scheme.onSurface,
                                  fontSize: 56,
                                  fontWeight: FontWeight.w900,
                                  height: 1.0)),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text('/ 5.0',
                                style: TextStyle(
                                    color: scheme.onSurfaceVariant,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 14),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 9),
                            child: Text(
                              '$sign${delta.abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: trendColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 14),
                    // ── Weight-scale marker: just a small triangle + tiny number
                    LayoutBuilder(builder: (ctx, c) {
                      final frac =
                          ((pulseScore - 1.0) / 4.0).clamp(0.0, 1.0);
                      const bubbleW = 30.0;
                      final left = (frac * c.maxWidth - bubbleW / 2)
                          .clamp(0.0, c.maxWidth - bubbleW);
                      return SizedBox(
                        height: 22,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: left,
                              top: 0,
                              width: bubbleW,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomPaint(
                                    size: const Size(10, 8),
                                    painter: _TrianglePainter(
                                        color: scheme.onSurface),
                                  ),
                                  Text(
                                    pulseScore.toStringAsFixed(1),
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: scheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    // Soft 5-zone gradient bar (no hard segments — feels like
                    // a gauge, not 5 disconnected stripes)
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: _heatColors,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('At-risk',
                            style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                        Text('Excellent',
                            style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // ─── People row, merged inside the hero (saves space) ──
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const TeamScreen())),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            _avatarStack(scheme, teamScope: _heroShowsTeam),
                            const SizedBox(width: 12),
                            Text(
                                _heroShowsTeam
                                    ? '${TeamScreen.managers.length} direct reports'
                                    : '$_teamMembers people',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: scheme.onSurface)),
                            const Spacer(),
                            Icon(Icons.chevron_right_rounded,
                                size: 18, color: scheme.onSurfaceVariant),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                    // ─── Internal divider connecting hero to snapshot ───
                    Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: scheme.outlineVariant.withOpacity(0.6)),
                    // ─── Snapshot section (inlined) ───
                    _teamSnapshotCard(scheme, positive, constructive, avg, _heroShowsTeam),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ─── Cumulative team rollup: org → managers ───
              _teamRollup(scheme, avg),
              const SizedBox(height: 22),

              // ─── Wins this quarter (horizontal celebration row) ───
              if (positives.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.celebration_rounded, size: 18, color: scheme.tertiary),
                    const SizedBox(width: 6),
                    Text('Wins this quarter',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface)),
                    const Spacer(),
                    Text('${positives.length}',
                        style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 124,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: positives.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => _winCard(positives[i], scheme),
                  ),
                ),
                const SizedBox(height: 22),
              ],

              // ─── Priorities today (M3 card) ───
              Container(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bolt_rounded, size: 18, color: scheme.primary),
                        const SizedBox(width: 6),
                        Text('Priorities today',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: scheme.onSurface)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _priorityItem(
                      scheme,
                      Icons.chat_bubble_rounded,
                      'Review $focusName feedback',
                      'Constructive · open ${(constructive == 0 ? 0 : 1)}',
                      () => _showFeedbackPopup('Constructive'),
                    ),
                    _priorityItem(
                      scheme,
                      Icons.flag_rounded,
                      '$_overdueGoals goal${_overdueGoals == 1 ? '' : 's'} overdue',
                      'SMART goals · needs attention',
                      () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GoalsScreen())),
                    ),
                    _priorityItem(
                      scheme,
                      Icons.event_rounded,
                      '$_pendingMeetings 1:1 meeting${_pendingMeetings == 1 ? '' : 's'} pending',
                      'Schedule with team',
                      () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meetings — coming soon'))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ─── Recent pulse strip ───
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showFeedbackPopup(null),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timeline_rounded, size: 18, color: scheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fb.isEmpty
                              ? 'No recent activity'
                              : 'Recent · ${fb.take(3).map((f) => f.employeeName.split(' ').first).join(', ')}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: scheme.onSurface, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text('View all',
                          style: TextStyle(fontSize: 12, color: scheme.primary, fontWeight: FontWeight.w700)),
                      Icon(Icons.chevron_right_rounded, size: 18, color: scheme.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // No-op painter helper class lives at file bottom.

  // ─── Heatmap palette: orange → yellow → green (no red, no blue) ──
  static const List<Color> _heatColors = [
    Color(0xFFE89A6B), // <3.0 At-risk (soft orange)
    Color(0xFFEBB57A), // 3.0-3.5 Watch (warm peach)
    Color(0xFFE0C04A), // 3.5-4.0 Steady (mellow yellow)
    Color(0xFFA8C977), // 4.0-4.5 Healthy (light green)
    Color(0xFF3DA66E), // ≥4.5 Excellent (deep green)
  ];
  static const List<String> _heatLabels = [
    'At-risk', 'Watch', 'Steady', 'Healthy', 'Excellent'
  ];

  int _zoneIndex(double r) {
    if (r >= 4.5) return 4;
    if (r >= 4.0) return 3;
    if (r >= 3.5) return 2;
    if (r >= 3.0) return 1;
    return 0;
  }

  // Single team snapshot card: people composition + feedback breakdown.
  // Replaces the 4 redundant KPI tiles with one richer surface.
  // Period chip: shows the active range (e.g. "Apr–Jun 2026") with a
  // calendar icon and a small dropdown caret. Tapping opens a menu with
  // "This quarter" and "Last quarter" options.
  Widget _periodChip(ColorScheme scheme) {
    return PopupMenuButton<DashRange>(
      tooltip: 'Change period',
      onSelected: (v) => setState(() => _range = v),
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
      itemBuilder: (_) => [
        CheckedPopupMenuItem(
          value: DashRange.current,
          checked: _range == DashRange.current,
          child: const Text('This quarter'),
        ),
        CheckedPopupMenuItem(
          value: DashRange.last,
          checked: _range == DashRange.last,
          child: const Text('Last quarter'),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 14, color: scheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(_rangeLabel,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface)),
            const SizedBox(width: 6),
            Icon(Icons.expand_more_rounded,
                size: 16, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  // Compact quarter chip — small inline pill instead of full-width segmented.
  Widget _quarterChip(String label, DashRange value, ColorScheme scheme) {
    final selected = _range == value;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _range = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w800)),
      ),
    );
  }

  // Large global scope toggle at the top of the dashboard. Drives every card
  // below — Team (3 direct reports) vs Org (whole org).
  Widget _globalScopeToggle(ColorScheme scheme) {
    // No container background — minimalist, sharp for the CHRO demo.
    return Row(
      children: [
          // Team = teal (primary), matches card border in Team mode
          Expanded(child: _scopePill(scheme, 'Team', '',
              icon: Icons.diversity_3_rounded,
              activeColor: scheme.primary,
              active: _heroShowsTeam,
              onTap: () => setState(() => _heroShowsTeam = true))),
          const SizedBox(width: 10),
          // Whole org = dark charcoal (neutral, brand-safe). Warm/cool feedback
          // hues are reserved exclusively for the heatmap/ratings.
          Expanded(child: _scopePill(scheme, 'Whole org', '',
              icon: Icons.apartment_rounded,
              activeColor: const Color(0xFF2C3E40),
              active: !_heroShowsTeam,
              onTap: () => setState(() => _heroShowsTeam = false))),
      ],
    );
  }

  Widget _scopePill(ColorScheme scheme, String label, String sub,
      {required IconData icon,
      required Color activeColor,
      required bool active,
      required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        decoration: BoxDecoration(
          color: active ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: !active
              ? Border.all(color: activeColor.withOpacity(0.35), width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 16,
                color: active ? Colors.white : activeColor),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: active ? Colors.white : scheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  // Toggle pill for the hero — switches between Team pulse and Org pulse.
  Widget _pulseToggle(String label, String sub, bool active, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? Colors.white : Colors.white.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                    color: active ? const Color(0xFF0E7C7B) : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800)),
            const SizedBox(width: 4),
            Text('· $sub',
                style: TextStyle(
                    color: active
                        ? const Color(0xFF0E7C7B).withOpacity(0.7)
                        : Colors.white.withOpacity(0.7),
                    fontSize: 9,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _teamSnapshotCard(ColorScheme scheme, int orgPositive, int orgConstructive, double orgAvg, bool teamScope) {
    // ── Scope-aware composition & feedback aggregation ──
    final orgManagers = _teamMembers >= 8 ? 3 : 2; // derived from roster shape
    final orgReports = _teamMembers - orgManagers;

    // In Team scope, "people" = the 3 direct reports the user manages.
    // Feedback in Team scope = sum of those direct reports' personal logs.
    int teamPositive = 0, teamConstructive = 0;
    for (final m in TeamScreen.managers) {
      final log = EmployeeFeedbackLogScreen.logFor(m['name'] as String);
      teamPositive += log.where((e) => e['type'] == 'Positive').length;
      teamConstructive += log.where((e) => e['type'] == 'Constructive').length;
    }

    final people = teamScope ? TeamScreen.managers.length : _teamMembers;
    final positive = teamScope ? teamPositive : orgPositive;
    final constructive = teamScope ? teamConstructive : orgConstructive;
    final scopeLabel = teamScope ? 'TEAM · DIRECT REPORTS' : 'ORG-WIDE';
    final compositionA = teamScope ? '$people direct' : '$orgManagers direct';
    final compositionB = teamScope ? '0 indirect' : '$orgReports indirect';

    final total = positive + constructive;
    final posPct = total == 0 ? 0.0 : positive / total;
    // Card zone derived from positive ratio
    final cardZone = posPct >= 0.7
        ? 4
        : posPct >= 0.6
            ? 3
            : posPct >= 0.4
                ? 2
                : posPct >= 0.25
                    ? 1
                    : 0;
    final cardZoneColor = _heatColors[cardZone];
    // Soft, calm tones — feedback isn't an alert. Light green for positive,
    // warm yellow/amber for constructive (caution, not danger).
    final posColor = const Color(0xFF5BB880); // light green
    final conColor = const Color(0xFFE6B43A); // warm amber
    // Heatmap row at the bottom: use the rating-based zone for the scope
    // currently selected (team vs org pulse).
    final zone = _zoneIndex(teamScope ? (TeamScreen.directReportsAvg() ?? orgAvg) : orgAvg);

    // Embedded section — no outer Material/border; parent container provides them.
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── CELL A: FEEDBACK (now FIRST — what's been said about them) ───
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.tertiaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: scheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.chat_bubble_rounded,
                          size: 14, color: scheme.onTertiaryContainer),
                    ),
                    const SizedBox(width: 8),
                    Text('FEEDBACK · THIS QUARTER',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: scheme.onTertiaryContainer.withOpacity(0.85))),
                    const Spacer(),
                    Text('$total total',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: scheme.onSurface)),
                  ],
                ),
                const SizedBox(height: 10),
                _feedbackBar(scheme,
                    label: 'Positive',
                    count: positive,
                    total: total,
                    color: posColor,
                    onTap: () => _showFeedbackPopup('Positive')),
                const SizedBox(height: 8),
                _feedbackBar(scheme,
                    label: 'Constructive',
                    count: constructive,
                    total: total,
                    color: conColor,
                    onTap: () => _showFeedbackPopup('Constructive')),
              ],
            ),
          ),
          // People row is now merged INTO the hero above — no second cell needed.
        ],
      ),
    );
  }

  // Overlapping avatar stack — shows up to 5 actual people in the roster,
  // colored by their personal pulse zone. Tonal Material 3 styling.
  Widget _avatarStack(ColorScheme scheme, {required bool teamScope}) {
    final pool = teamScope
        ? TeamScreen.managers
        : TeamScreen.roster;
    final visible = pool.take(5).toList();
    final extra = pool.length - visible.length;
    const avatarSize = 30.0;
    const overlap = 10.0;
    final stackWidth = avatarSize +
        (visible.length - 1) * (avatarSize - overlap) +
        (extra > 0 ? avatarSize - overlap : 0);

    Widget avatar(String name, {bool isPlus = false, int? plus}) {
      final initials = name
          .split(' ')
          .where((p) => p.isNotEmpty)
          .map((p) => p[0])
          .take(2)
          .join()
          .toUpperCase();
      final zone = isPlus
          ? null
          : _zoneIndex(EmployeeFeedbackLogScreen.averageRating(name) ?? 3.5);
      final bg = isPlus
          ? scheme.surfaceContainerHighest
          : _heatColors[zone!].withOpacity(0.35);
      final fg = isPlus
          ? scheme.onSurfaceVariant
          : Colors.black.withOpacity(0.75);
      return Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: scheme.surfaceContainerLow, width: 2.5),
        ),
        alignment: Alignment.center,
        child: Text(
          isPlus ? '+$plus' : initials,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w900, color: fg),
        ),
      );
    }

    return SizedBox(
      width: stackWidth,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * (avatarSize - overlap),
              child: avatar(visible[i]['name'] as String),
            ),
          if (extra > 0)
            Positioned(
              left: visible.length * (avatarSize - overlap),
              child: avatar('', isPlus: true, plus: extra),
            ),
        ],
      ),
    );
  }

  // Single feedback bar: label + count + horizontal bar fill.
  Widget _feedbackBar(ColorScheme scheme,
      {required String label,
      required int count,
      required int total,
      required Color color,
      required VoidCallback onTap}) {
    final pct = total == 0 ? 0.0 : count / total;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 90,
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface)),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  children: [
                    Container(
                        height: 10, color: scheme.surfaceContainerHighest),
                    FractionallySizedBox(
                      widthFactor: pct,
                      child: Container(height: 10, color: color),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 30,
              child: Text('$count',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: scheme.onSurface)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _composChip(ColorScheme scheme, String value, String label, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w900, color: accent)),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: accent.withOpacity(0.85))),
        ],
      ),
    );
  }

  Widget _legend(ColorScheme scheme, Color dot, String label, int count, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text('$count',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w900, color: scheme.onSurface)),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ─── Cumulative averages: org → each manager's team ───
  // Shows the rollup so a manager can see how their org averages, then
  // drill in to see which sub-team is lifting or dragging the number.
  Widget _teamRollup(ColorScheme scheme, double orgAvg) {
    final managers = TeamScreen.managers;
    // Deterministic synthetic prior-quarter avg per manager so the % column
    // has something to render. Replace with real history later.
    double priorFor(String name) {
      final seed = name.hashCode.abs() % 100;
      return 3.2 + (seed / 100) * 1.0; // 3.2–4.2
    }

    Widget row({
      required String label,
      required String sub,
      required double? current,
      required double prior,
      required int depth,
      VoidCallback? onTap,
      bool expandable = false,
      bool expanded = false,
      VoidCallback? onExpand,
    }) {
      // No data → render row with em-dash and muted styling
      final hasData = current != null;
      final zone = hasData ? _zoneIndex(current) : 2;
      final zoneColor = hasData ? _heatColors[zone] : scheme.onSurfaceVariant;
      final delta = hasData ? current - prior : 0.0;
      final up = delta >= 0;
      final tColor =
          up ? const Color(0xFF5BB880) : const Color(0xFFE6B43A);

      return InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            children: [
              // Indent ONLY pushes the dot/name — score column stays right-aligned
              SizedBox(width: depth * 18.0),
              // Tree connector dot
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: hasData ? zoneColor : scheme.outlineVariant,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface)),
                    Text(hasData ? sub : 'No feedback yet',
                        style: TextStyle(
                            fontSize: 11, color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              // ── Fixed-width right column for clean vertical alignment ──
              SizedBox(
                width: 42,
                child: Text(hasData ? current.toStringAsFixed(1) : '—',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: zoneColor)),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 64,
                child: hasData
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: tColor.withOpacity(0.5)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                            '${up ? '+' : '−'}${delta.abs().toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: tColor)),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 24,
                child: expandable
                    ? InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: onExpand,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: AnimatedRotation(
                            turns: expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: Icon(Icons.expand_more_rounded,
                                size: 20, color: scheme.primary),
                          ),
                        ),
                      )
                    : Icon(Icons.chevron_right_rounded,
                        size: 18, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                const Spacer(),
                Text('avg · Δ vs last Q',
                    style: TextStyle(
                        fontSize: 10,
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // In Team mode we skip org rollups — focus is just the directs below.
          if (!_heroShowsTeam) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Text('ORG ROLLUPS',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: scheme.onSurfaceVariant)),
            ),
            row(
              label: 'Whole organization',
              sub: 'avg across all $_teamMembers people',
              current: orgAvg,
              prior: _range == DashRange.current ? 3.6 : 3.4,
              depth: 0,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TeamScreen())),
            ),
            row(
              label: 'My direct reports',
              sub: 'avg across ${managers.length} direct (personal ratings)',
              current: TeamScreen.directReportsAvg(),
              prior: _range == DashRange.current ? 3.7 : 3.5,
              depth: 0,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TeamScreen())),
            ),
          ],
          // ── Per-manager breakdown ──
          Padding(
            padding: EdgeInsets.fromLTRB(12, _heroShowsTeam ? 4 : 12, 12, 4),
            child: Row(
              children: [
                Text(_heroShowsTeam ? 'YOUR DIRECT REPORTS' : 'BY MANAGER',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: scheme.onSurfaceVariant)),
                const SizedBox(width: 6),
                Expanded(
                    child: Container(height: 1, color: scheme.outlineVariant)),
              ],
            ),
          ),
          // ── Per-manager: personal row (always) + team row (when expanded) ──
          ...managers.expand((m) {
            final name = m['name'] as String;
            final personal = EmployeeFeedbackLogScreen.averageRating(name);
            final teamAvg = TeamScreen.teamAvgRating(name);
            final reports = TeamScreen.reportsOf(name).length;
            final expanded = _expandedManagers.contains(name);
            return [
              row(
                label: name,
                sub: '${m['department']} · personal rating',
                current: personal,
                prior: priorFor(name),
                depth: 1,
                expandable: reports > 0,
                expanded: expanded,
                onExpand: reports > 0
                    ? () => setState(() {
                          if (expanded) {
                            _expandedManagers.remove(name);
                          } else {
                            _expandedManagers.add(name);
                          }
                        })
                    : null,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => EmployeeFeedbackLogScreen(employeeName: name))),
              ),
              if (expanded)
                row(
                  label: 'Team avg ($reports)',
                  sub: 'across reports',
                  current: teamAvg,
                  prior: priorFor(name) - 0.1,
                  depth: 2,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ManagerReportsScreen(manager: m)),
                  ),
                ),
            ];
          }),
        ],
      ),
    );
  }

  // Small celebration card for "Wins this quarter".
  Widget _winCard(FeedbackItem f, ColorScheme scheme) {
    final initials = f.employeeName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .take(2)
        .join()
        .toUpperCase();
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: scheme.tertiary,
                child: Text(initials,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(f.employeeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: scheme.onTertiaryContainer)),
              ),
              Icon(Icons.favorite_rounded, size: 14, color: scheme.tertiary),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              f.comment,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11, color: scheme.onTertiaryContainer, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityItem(ColorScheme scheme, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 16, color: scheme.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  void _showFeedbackPopup(String? typeFilter) {
    final items = typeFilter == null
        ? _filtered
        : _filtered.where((f) => f.feedbackType == typeFilter).toList();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(typeFilter == null ? 'Recent Activity' : '$typeFilter Feedback',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              Text(_rangeLabel, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const Divider(),
              Flexible(
                child: items.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(child: Text('Nothing in this quarter', style: TextStyle(color: Colors.grey[500]))),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final f = items[index];
                          final isPositive = f.feedbackType == 'Positive';
                          final d = f.createdAt!;
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
                                Row(children: [
                                  Text(f.employeeName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isPositive ? Colors.green[100] : Colors.orange[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(f.feedbackType,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: isPositive ? Colors.green[700] : Colors.orange[700])),
                                  ),
                                  const Spacer(),
                                  Text('${_mon[d.month]} ${d.day}',
                                      style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                                ]),
                                const SizedBox(height: 8),
                                Text(f.comment, style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.4)),
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
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, p);
  }
  @override
  bool shouldRepaint(covariant _TrianglePainter old) => old.color != color;
}
