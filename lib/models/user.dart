class Employee {
  final String id;
  final String name;
  final String? department;
  final String? region;

  Employee({
    required this.id,
    required this.name,
    this.department,
    this.region,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      department: json['department'],
      region: json['region'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'region': region,
    };
  }
}
