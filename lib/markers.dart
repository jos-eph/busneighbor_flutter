import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Widget mapIcon(String text) {
  return Stack(
    alignment: Alignment.bottomLeft, // Center the text and image
    children: [
      Image.asset("assets/CompassN.png", height: 22, width: 22),
      Positioned(
        // Position the text (adjust as needed)
        bottom: 15, // Or bottom, or other positioning
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    ],
    clipBehavior: Clip.none,
  );
}

Marker labeledPushpin(String label, LatLng pointLoc) {
  return Marker(point: pointLoc, child: mapIcon(label));
}
