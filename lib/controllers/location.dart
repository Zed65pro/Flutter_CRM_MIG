import 'dart:async';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationController extends GetxController {
  Rx<LatLng?> userLocation = Rx<LatLng?>(null);
  final RxBool _loading = true.obs;
  // late Timer _locationTimer;

  @override
  void onInit() async {
    super.onInit();
    await fetchLocation(load: true);
    // _locationTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
    //   fetchLocation(load: true);
    // });
  }

  @override
  void dispose() {
    // _locationTimer.cancel();
    removeLocationFromSharedPreferences();
    super.dispose();
  }

  Future<void> fetchLocation({bool load = false}) async {
    _loading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      double? savedLatitude = prefs.getDouble('latitude');
      double? savedLongitude = prefs.getDouble('longitude');

      if (savedLatitude != null && savedLongitude != null && !load) {
        userLocation.value = LatLng(savedLatitude, savedLongitude);
      } else {
        await _requestLocationPermission();
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 5),
        );
        userLocation.value = LatLng(position.latitude, position.longitude);
        // Save location to shared preferences
        await saveLocationToSharedPreferences(userLocation.value!);
      }
    } catch (e) {
      print('Error getting current location: $e');
    } finally {
      _loading.value = false;
    }
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      print('Location permission denied');
    } else {
      print('Location permission granted');
    }
  }

  Future<void> saveLocationToSharedPreferences(LatLng location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', location.latitude);
    await prefs.setDouble('longitude', location.longitude);
  }

  Future<void> removeLocationFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('latitude');
    await prefs.remove('longitude');
  }

  // Method to update user location
  void updateLocation(LatLng location) {
    userLocation.value = location;
    saveLocationToSharedPreferences(location);
  }

  // Getter for loading state
  RxBool get loading => _loading;
}
