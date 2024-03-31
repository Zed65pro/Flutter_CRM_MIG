import 'package:crm/models/user.dart';

class JobOrderImage {
  int id;
  String file;
  DateTime uploadedAt;
  DateTime createdAt;
  User uploadedBy;

  JobOrderImage({
    required this.id,
    required this.file,
    required this.uploadedAt,
    required this.createdAt,
    required this.uploadedBy,
  });

  factory JobOrderImage.fromJson(Map<String, dynamic> json) {
    print(json);
    return JobOrderImage(
      id: json['id'],
      file: json['file'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      uploadedBy: User.fromJson(json['uploadedBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file': file,
      'uploadedAt': uploadedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'uploadedBy': uploadedBy.toJson(),
    };
  }
}
