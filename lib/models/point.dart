class Point {
  double latitude;
  double longitude;

  Point({required this.latitude, required this.longitude});

  factory Point.fromJson(double longitude, double latitude) {
    return Point(
      latitude: longitude,
      longitude: latitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
