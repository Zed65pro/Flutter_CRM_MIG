import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crm/controllers/location.dart';
import 'package:crm/pages/map/misc/tile_providers.dart';
import 'package:permission_handler/permission_handler.dart';

class DirectionMap extends StatefulWidget {
  const DirectionMap({super.key});

  @override
  State<DirectionMap> createState() => _DirectionMapState();
}

class _DirectionMapState extends State<DirectionMap> {
  final LatLng _jobLocation = const LatLng(31.886, 35.208);
  List<LatLng> routePoints = [];
  final LocationController locationController = Get.find();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    // _listenForLocationChanges();
    locationController.removeLocationFromSharedPreferences();
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      print('Location permission denied');
    } else {
      print('Location permission granted');
      _listenForLocationChanges();
    }
  }

  void _listenForLocationChanges() {
    Geolocator.getPositionStream().listen((Position position) {
      print("live tracking: ${locationController.userLocation.value}");
      locationController
          .updateLocation(LatLng(position.latitude, position.longitude));
      _calculateRoute(locationController.userLocation.value!, _jobLocation);
    });
  }

  Future<void> _calculateRoute(LatLng start, LatLng end) async {
    var v1 = start.latitude;
    var v2 = start.longitude;
    var v3 = end.latitude;
    var v4 = end.longitude;

    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);

    setState(() {
      routePoints = [];
      var router =
          jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
      for (int i = 0; i < router.length; i++) {
        var reep = router[i].toString();
        reep = reep.replaceAll("[", "");
        reep = reep.replaceAll("]", "");
        var lat1 = reep.split(',');
        var long1 = reep.split(",");
        routePoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job location',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Obx(() {
        if (!locationController.loading.value &&
            locationController.userLocation.value != null) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: locationController.userLocation.value!,
                initialZoom: 14,
                interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                openStreetMapTileLayer,
                MarkerLayer(
                  markers: [
                    Marker(
                      point: locationController.userLocation.value!,
                      width: 15,
                      height: 15,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    Marker(
                      point: _jobLocation,
                      width: 15,
                      height: 15,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylineCulling: false,
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: Colors.blue,
                      strokeWidth: 4,
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
