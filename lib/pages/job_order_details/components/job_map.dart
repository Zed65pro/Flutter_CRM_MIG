import 'dart:async';

import 'package:crm/components/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crm/controllers/location.dart';
import 'package:crm/pages/map/misc/tile_providers.dart';
import 'package:permission_handler/permission_handler.dart';

class JobMap extends StatefulWidget {
  const JobMap({super.key, required this.jobLocation});
  final LatLng jobLocation;
  @override
  State<JobMap> createState() => _JobMapState();
}

class _JobMapState extends State<JobMap> {
  late final LatLng jobLocation;
  // final LatLng jobLocation = const LatLng(31.886, 35.208);
  List<LatLng> routePoints = [];
  final LocationController locationController = Get.find();

  @override
  void initState() {
    super.initState();
    jobLocation = widget.jobLocation;
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      print('Location permission denied');
    } else {
      print('Location permission granted');
      await _calculateRoute(
          locationController.userLocation.value!, jobLocation);
    }
  }

  Future<void> _calculateRoute(LatLng start, LatLng end) async {
    var v1 = start.latitude;
    var v2 = start.longitude;
    var v3 = end.latitude;
    var v4 = end.longitude;

    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var router =
          jsonResponse['routes'][0]['geometry']['coordinates'] as List<dynamic>;

      setState(() {
        routePoints = router
            .map((coord) => LatLng(coord[1] as double, coord[0] as double))
            .toList();
      });
    } else {
      showFailureDialog(
          'Failed to calculate the route to the specified location.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!locationController.loading.value &&
          locationController.userLocation.value != null &&
          routePoints.isNotEmpty) {
        return Stack(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: locationController.userLocation.value!,
                initialZoom: 18,
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
                      point: jobLocation,
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
          ),
          Positioned(
            top: 20,
            right: 20,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await locationController.fetchLocation(load: true);
                    await _calculateRoute(
                        locationController.userLocation.value!, jobLocation);
                  },
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Tooltip(
                      message: 'Refresh Location',
                      child: Icon(
                        Icons.refresh,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]);
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
