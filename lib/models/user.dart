class User {
  final String username;
  final int id;
  final String email;
  final bool isStaff;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isStaff,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      id: json['id'],
      email: json['email'],
      isStaff: json['is_staff'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
      'email': email,
      'is_staff': isStaff,
    };
  }
}
