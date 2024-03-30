import 'package:crm/models/user.dart';

class Service {
  final int id;
  final String name;
  final String description;
  final String price;
  final int durationMonths;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User createdBy;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMonths,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      durationMonths: json['duration_months'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: User.fromJson(json['created_by']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration_months': durationMonths,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy.toJson(), // Convert createdBy to JSON
    };
  }
}
