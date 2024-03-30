class Point {
  double latitude;
  double longitude;

  Point({required this.latitude, required this.longitude});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
