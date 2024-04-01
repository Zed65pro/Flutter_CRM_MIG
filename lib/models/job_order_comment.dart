import 'package:crm/models/user.dart';

class JobOrderComment {
  int id;
  String body;
  DateTime createdAt;
  User createdBy;

  JobOrderComment({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.createdBy,
  });

  factory JobOrderComment.fromJson(Map<String, dynamic> json) {
    return JobOrderComment(
      id: json['id'],
      body: json['body'],
      createdAt: DateTime.parse(json['created_at']),
      createdBy: User.fromJson(json['created_by']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'created_at': createdAt.toIso8601String(),
      'uploaded_by': createdBy.toJson(),
    };
  }
}
