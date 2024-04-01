import 'package:crm/models/job_order_comment.dart';
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
  List<JobOrderComment> comments;

  JobOrder(
      {required this.id,
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
      required this.comments});

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
      comments: json['comments'] != null || json['comments']?.isBlank
          ? (json['comments'] as List<dynamic>)
              .map((e) => JobOrderComment.fromJson(e))
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
      'phone_number': phoneNumber,
      'email': email,
      'location': location.toJson(),
      'feedback': feedback,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy.toJson(),
      'images': images.map((e) => e.toJson()).toList(),
      'comments': comments.map((e) => e.toJson()).toList(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'area': area,
      'description': description,
      'city': city,
      'street': street,
      'phone_number': phoneNumber,
      'email': email,
      'feedback': feedback,
      'status': status,
    };
  }

  JobOrder copy() {
    return JobOrder(
      id: id,
      name: name,
      description: description,
      area: area,
      city: city,
      street: street,
      phoneNumber: phoneNumber,
      email: email,
      location: location,
      feedback: feedback,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      images: List<JobOrderImage>.from(images),
      comments: List<JobOrderComment>.from(comments),
    );
  }
}
