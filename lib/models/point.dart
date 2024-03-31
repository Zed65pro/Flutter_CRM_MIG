import 'package:latlong2/latlong.dart';

class Point {
  double latitude;
  double longitude;

  Point({required this.latitude, required this.longitude});

  factory Point.fromJson(double longitude, double latitude) {
    return Point(
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static Point fromLatLng(LatLng latLng) {
    return Point(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
