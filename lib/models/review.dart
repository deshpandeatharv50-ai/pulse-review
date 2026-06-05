class Review {
  final String id;
  final String employeeName;
  final String cycle;
  final double rating;

  Review({
    required this.id,
    required this.employeeName,
    required this.cycle,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      employeeName: json['employee_name'],
      cycle: json['cycle'],
      rating: double.parse(json['rating'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_name': employeeName,
      'cycle': cycle,
      'rating': rating,
    };
  }
}
