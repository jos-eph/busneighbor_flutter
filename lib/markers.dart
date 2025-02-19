import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const double LOGICAL_EDGE_HEIGHT = 22;

Image _iconImageFromPath(String path) {
  return Image.asset(path,
      height: LOGICAL_EDGE_HEIGHT, width: LOGICAL_EDGE_HEIGHT);
}

Image _NORTH_ICON = _iconImageFromPath("assets/CompassN.png");
Image _SOUTH_ICON = _iconImageFromPath("assets/CompassS.png");
Image _EAST_ICON = _iconImageFromPath("assets/CompassE.png");
Image _WEST_ICON = _iconImageFromPath("assets/CompassW.png");
Image _SMILEY = _iconImageFromPath("assets/Smiley.png");

Positioned _positionedText(String text) {
  return Positioned(
      bottom: 19,
      child: Text(text, style: TextStyle(fontWeight: FontWeight.w900)));
}

Widget mapIcon(String text) {
  return Stack(
      alignment: Alignment.bottomLeft,
      clipBehavior: Clip.none, // Center the text and image
      children: [_NORTH_ICON, _positionedText(text)]);
}

Marker labeledPushpin(String label, LatLng pointLoc) {
  return Marker(point: pointLoc, child: mapIcon(label));
}
