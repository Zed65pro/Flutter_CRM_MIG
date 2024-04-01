import 'dart:async';

import 'package:crm/components/appbar/home_appbar.dart';
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

class FullScreenJobMap extends StatefulWidget {
  const FullScreenJobMap({super.key});
  @override
  State<FullScreenJobMap> createState() => _FullScreenJobMapState();
}

class _FullScreenJobMapState extends State<FullScreenJobMap> {
  late final LatLng jobLocation;
  List<LatLng> routePoints = [];
  final LocationController locationController = Get.find();

  @override
  void initState() {
    _requestLocationPermission();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    jobLocation = ModalRoute.of(context)?.settings.arguments as LatLng? ??
        const LatLng(31.886, 35.208);
    super.didChangeDependencies();
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      print('Location permission denied');
    } else {
      print('Location permission granted');
      final userLocation = locationController.userLocation.value;
      if (userLocation != null) {
        await _calculateRoute(userLocation, jobLocation);
      } else {
        print('User location is null');
      }
    }
  }

  Future<void> _calculateRoute(LatLng start, LatLng end) async {
    if (jobLocation == null) {
      return;
    }
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
    return Scaffold(
      appBar: HomeAppBar(title: 'Location'),
      body: Obx(() {
        if (!locationController.loading.value &&
            locationController.userLocation.value != null &&
            routePoints.isNotEmpty) {
          return Stack(children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: locationController.userLocation.value!,
                initialZoom: 16,
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
            Positioned(top: 20, right: 20, child: refreshLocationIndicator())
          ]);
        } else if (locationController.loading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Calculating the route...'),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Route information not available.'),
                const SizedBox(height: 16),
                refreshLocationIndicator(),
              ],
            ),
          );
        }
      }),
    );
  }

  Container refreshLocationIndicator() {
    return Container(
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
    );
  }
}
