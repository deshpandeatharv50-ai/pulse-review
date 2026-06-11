// Verifies that feedback counts reconcile across the app — Dashboard +
// Feedback tab + Team rollup all derive from TeamScreen.rosterFeedback.
import 'package:flutter_test/flutter_test.dart';
import 'package:pulsereview_mobile/screens/team_screen.dart';
import 'package:pulsereview_mobile/screens/employee_feedback_log_screen.dart';

void main() {
  group('rosterFeedback consolidation', () {
    test('total feedback equals sum of per-person logs', () {
      var perPersonSum = 0;
      for (final m in TeamScreen.roster) {
        perPersonSum += EmployeeFeedbackLogScreen.logFor(m['name'] as String).length;
      }
      final total = TeamScreen.rosterFeedbackCount();
      expect(total, perPersonSum,
          reason: 'rosterFeedbackCount must equal sum of per-person logs');
    });

    test('positive + constructive = total', () {
      final total = TeamScreen.rosterFeedbackCount();
      final pos = TeamScreen.rosterFeedbackCount(type: 'Positive');
      final con = TeamScreen.rosterFeedbackCount(type: 'Constructive');
      expect(pos + con, total);
    });

    test('Team scope (managers only) is a strict subset of org scope', () {
      final orgTotal = TeamScreen.rosterFeedbackCount();
      final mgrNames =
          TeamScreen.managers.map((m) => m['name'] as String).toList();
      final teamTotal = TeamScreen.rosterFeedbackCount(names: mgrNames);
      expect(teamTotal <= orgTotal, true,
          reason: 'Team subset cannot exceed org-wide total');
    });

    test('Q1 + Q2 2026 entries reconcile with full log', () {
      final q2Start = DateTime(2026, 4, 1);
      final q2End = DateTime(2026, 7, 1);
      final q1Start = DateTime(2026, 1, 1);
      final q1End = DateTime(2026, 4, 1);
      final q2Count =
          TeamScreen.rosterFeedbackCount(start: q2Start, end: q2End);
      final q1Count =
          TeamScreen.rosterFeedbackCount(start: q1Start, end: q1End);
      final pre2026Count =
          TeamScreen.rosterFeedbackCount(end: q1Start);
      final total = TeamScreen.rosterFeedbackCount();
      expect(q1Count + q2Count + pre2026Count, total,
          reason: 'Time-bucketed counts must sum to the unfiltered total');
    });

    test('Same call returns the same number twice (deterministic)', () {
      final a = TeamScreen.rosterFeedbackCount(type: 'Positive');
      final b = TeamScreen.rosterFeedbackCount(type: 'Positive');
      expect(a, b);
    });

    test('Per-employee log is a subset of the org log for that employee', () {
      for (final m in TeamScreen.roster) {
        final name = m['name'] as String;
        final perPerson = EmployeeFeedbackLogScreen.logFor(name).length;
        final fromAggregator =
            TeamScreen.rosterFeedbackCount(names: [name]);
        expect(fromAggregator, perPerson,
            reason: 'Aggregator must agree with per-employee log for $name');
      }
    });
  });
}
