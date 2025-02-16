import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Widget mapIcon(String text) {
  return Column(
    children: [
      Text(text),
      ImageIcon(AssetImage('assets/Smiley.png'), size: 36),
    ],
  );
}

Marker labeledPushpin(String label, LatLng pointLoc) {
  return Marker(point: pointLoc, child: mapIcon(label));
}
