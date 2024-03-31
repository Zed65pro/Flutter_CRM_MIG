import 'package:crm/models/job_order_image.dart';
import 'package:crm/models/point.dart';
import 'package:crm/models/user.dart';
import 'package:get/get.dart';

class JobOrder {
  int id;
  String name;
  String description;
  String area;
  String city;
  String street;
  String phoneNumber;
  String email;
  Point location;
  String feedback;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  User createdBy;
  List<JobOrderImage> images;

  JobOrder({
    required this.id,
    required this.name,
    required this.description,
    required this.area,
    required this.city,
    required this.street,
    required this.phoneNumber,
    required this.email,
    required this.location,
    required this.feedback,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.images,
  });

  factory JobOrder.fromJson(Map<String, dynamic> json) {
    return JobOrder(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      area: json['area'],
      city: json['city'],
      street: json['street'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      location: Point.fromJson(json['longitude'], json['latitude']),
      feedback: json['feedback'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: User.fromJson(json['created_by']),
      images: json['images'] != null || json['images'].isBlank
          ? (json['images'] as List<dynamic>)
              .map((e) => JobOrderImage.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'area': area,
      'city': city,
      'street': street,
      'phoneNumber': phoneNumber,
      'email': email,
      'location': location.toJson(),
      'feedback': feedback,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy.toJson(),
      'images': images.map((e) => e.toJson()).toList(),
    };
  }
}
