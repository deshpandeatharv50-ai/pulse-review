class FeedbackItem {
  final String id;
  final String employeeName;
  final String feedbackType;
  final String comment;
  final DateTime? createdAt;

  FeedbackItem({
    required this.id,
    required this.employeeName,
    required this.feedbackType,
    required this.comment,
    this.createdAt,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'],
      employeeName: json['employee_name'],
      feedbackType: json['feedback_type'],
      comment: json['comment'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_name': employeeName,
      'feedback_type': feedbackType,
      'comment': comment,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
