class EmployeeFeedbackSummary {
  final String employeeName;
  final int positiveCount;
  final int constructiveCount;
  final double averageRating;
  final int currentQuarterPositive;
  final int currentQuarterConstructive;
  final int previousQuarterPositive;
  final int previousQuarterConstructive;
  final DateTime? lastFeedbackDate;

  EmployeeFeedbackSummary({
    required this.employeeName,
    required this.positiveCount,
    required this.constructiveCount,
    required this.averageRating,
    required this.currentQuarterPositive,
    required this.currentQuarterConstructive,
    required this.previousQuarterPositive,
    required this.previousQuarterConstructive,
    required this.lastFeedbackDate,
  });

  int get totalFeedback => positiveCount + constructiveCount;
  int get currentQuarterTotal => currentQuarterPositive + currentQuarterConstructive;
  int get previousQuarterTotal => previousQuarterPositive + previousQuarterConstructive;

  double get positivePercentage => totalFeedback == 0 ? 0 : (positiveCount / totalFeedback) * 100;
}
