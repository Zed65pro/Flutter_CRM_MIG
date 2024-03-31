import 'package:crm/models/user.dart';

class JobOrderImage {
  int id;
  String file;
  DateTime createdAt;
  User uploadedBy;

  JobOrderImage({
    required this.id,
    required this.file,
    required this.createdAt,
    required this.uploadedBy,
  });

  factory JobOrderImage.fromJson(Map<String, dynamic> json) {
    print(json);
    return JobOrderImage(
      id: json['id'],
      file: json['file'],
      createdAt: DateTime.parse(json['created_at']),
      uploadedBy: User.fromJson(json['uploaded_by']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file': file,
      'createdAt': createdAt.toIso8601String(),
      'uploadedBy': uploadedBy.toJson(),
    };
  }
}
