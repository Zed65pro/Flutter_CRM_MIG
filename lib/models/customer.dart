import 'package:firstapp/models/service.dart';
import 'package:firstapp/models/user.dart';

class Customer {
  final int id;
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User createdBy;
  final List<Service> services;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.services,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: User.fromJson(json['created_by']),
      services: (json['services'] as List<dynamic>)
          .map((serviceJson) => Service.fromJson(serviceJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy.toJson(),
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}
