class Goal {
  final String id;
  final String name;
  final double progress;

  Goal({
    required this.id,
    required this.name,
    required this.progress,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      name: json['name'],
      progress: (json['progress'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'progress': progress,
    };
  }
}
