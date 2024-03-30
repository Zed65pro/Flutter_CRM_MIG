import 'package:firstapp/pages/map/my_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MarkerPage extends StatefulWidget {
  const MarkerPage({super.key});

  @override
  State<MarkerPage> createState() => _MarkerPageState();
}

class _MarkerPageState extends State<MarkerPage> {
  Alignment selectedAlignment = Alignment.topCenter;
  bool counterRotate = false;
  late final List<Marker> customMarkers = [
    buildPin(const LatLng(31.899, 35.21)),
    buildPin(const LatLng(31.886, 35.208)),
  ];

  final List<LatLng> polylinePoints;

  _MarkerPageState()
      : polylinePoints = [
          const LatLng(31.899, 35.21),
          const LatLng(31.886, 35.208),
        ];

  Marker buildPin(LatLng point) => Marker(
        point: point,
        width: 20,
        height: 20,
        child: GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tapped existing marker'),
              duration: Duration(seconds: 1),
              showCloseIcon: true,
            ),
          ),
          child: const Icon(Icons.location_pin,
              size: 60, color: Color.fromARGB(255, 36, 7, 165)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map location')),
      body: Column(
        children: [
          Flexible(
            child: TheMap(
                customMarkers: customMarkers,
                counterRotate: counterRotate,
                selectedAlignment: selectedAlignment,
                polylinePoints: polylinePoints),
          ),
        ],
      ),
    );
  }
}
