import 'package:firstapp/pages/map/misc/tile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TheMap extends StatelessWidget {
  const TheMap({
    super.key,
    required this.customMarkers,
    required this.counterRotate,
    required this.selectedAlignment,
    required this.polylinePoints,
  });

  final List<Marker> customMarkers;
  final bool counterRotate;
  final Alignment selectedAlignment;
  final List<LatLng> polylinePoints;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(31.9038, 35.2034),
        initialZoom: 15,
        interactionOptions: InteractionOptions(
          flags: ~InteractiveFlag.doubleTapZoom,
        ),
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(
          markers: customMarkers,
          rotate: counterRotate,
          // alignment: selectedAlignment,
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: polylinePoints,
              color: Colors.blue,
              strokeWidth: 4,
            ),
          ],
        ),
      ],
    );
  }
}
