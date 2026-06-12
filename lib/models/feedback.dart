class FeedbackItem {
  final String id;
  final String employeeName;
  final String feedbackType;
  final String comment;
  final DateTime? createdAt;
  // Half-star rating: 0.5, 1.0, 1.5, ... 5.0. Nullable for legacy rows.
  final double? rating;

  FeedbackItem({
    required this.id,
    required this.employeeName,
    required this.feedbackType,
    required this.comment,
    this.createdAt,
    this.rating,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'].toString(),
      employeeName: json['employee_name'],
      feedbackType: json['feedback_type'],
      comment: json['comment'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      rating: json['rating'] == null
          ? null
          : double.parse(json['rating'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_name': employeeName,
      'feedback_type': feedbackType,
      'comment': comment,
      'created_at': createdAt?.toIso8601String(),
      'rating': rating,
    };
  }
}
