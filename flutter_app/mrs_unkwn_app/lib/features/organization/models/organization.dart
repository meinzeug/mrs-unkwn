class Organization {
  final String id;
  final String name;
  final String role;

  Organization({required this.id, required this.name, required this.role});

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
    };
  }
}
