// import 'package:firstapp/controllers/location.dart';
// import 'package:firstapp/pages/map/map2_input.dart';
// import 'package:firstapp/pages/map/misc/tile_providers.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart'; // Import geolocator package
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:permission_handler/permission_handler.dart';

// class MySecondMap extends StatefulWidget {
//   const MySecondMap({super.key});

//   @override
//   State<MySecondMap> createState() => _MySecondMapState();
// }

// class _MySecondMapState extends State<MySecondMap> {
//   LatLng? _userLocation;
//   final LatLng _jobLocation = const LatLng(31.886, 35.208);
//   List<LatLng> routePoints = [];
//   final LocationController locationController = Get.find();

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     // _getCurrentLocation().then((_) {
//     //   _calculateRoute(_userLocation, _jobLocation);
//     // });
//   }

//   Future<void> _requestLocationPermission() async {
//     final PermissionStatus status = await Permission.location.request();
//     if (status != PermissionStatus.granted) {
//       // Handle permission denied
//       print('Location permission denied');
//     } else {
//       // Permission granted, proceed with getting location
//       print('Location permission granted');
//       _getCurrentLocation().then((_) {
//         _calculateRoute(_userLocation!, _jobLocation);
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         _userLocation = LatLng(position.latitude, position.longitude);
//       });
//     } catch (e) {
//       print('Error getting current location: $e');
//     }
//   }

//   Future<void> _calculateRoute(LatLng start, LatLng end) async {
//     var v1 = start.latitude;
//     var v2 = start.longitude;
//     var v3 = end.latitude;
//     var v4 = end.longitude;

//     var url = Uri.parse(
//         'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
//     var response = await http.get(url);

//     setState(() {
//       routePoints = [];
//       var router =
//           jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
//       for (int i = 0; i < router.length; i++) {
//         var reep = router[i].toString();
//         reep = reep.replaceAll("[", "");
//         reep = reep.replaceAll("]", "");
//         var lat1 = reep.split(',');
//         var long1 = reep.split(",");
//         routePoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Job location',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//           ),
//         ),
//         backgroundColor: Colors.grey[300],
//         body: locationController.obx(
//             (state) => Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 500,
//                         width: 400,
//                         child: FlutterMap(
//                           options: MapOptions(
//                             initialCenter: _userLocation!,
//                             initialZoom: 14,
//                             interactionOptions: const InteractionOptions(
//                               flags: ~InteractiveFlag.doubleTapZoom,
//                             ),
//                           ),
//                           children: [
//                             openStreetMapTileLayer,
//                             MarkerLayer(
//                               markers: [
//                                 Marker(
//                                   point: _userLocation!,
//                                   width: 15,
//                                   height: 15,
//                                   child: const Icon(
//                                     Icons.location_on,
//                                     color: Colors.red,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 Marker(
//                                   point: _jobLocation,
//                                   width: 15,
//                                   height: 15,
//                                   child: const Icon(
//                                     Icons.work,
//                                     color: Colors.green,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             PolylineLayer(
//                               polylineCulling: false,
//                               polylines: [
//                                 Polyline(
//                                   points: routePoints,
//                                   color: Colors.blue,
//                                   strokeWidth: 9,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             onLoading: const Center(child: CircularProgressIndicator())));
//   }
// }
