import 'package:busneighbor_flutter/service/direction-map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:busneighbor_flutter/service/gtfs-service.dart';

const double LOGICAL_EDGE_HEIGHT = 22;

final gtfs = GtfsService();

Image _iconImageFromPath(String path) {
  return Image.asset(path,
      height: LOGICAL_EDGE_HEIGHT, width: LOGICAL_EDGE_HEIGHT);
}

Image NORTH_ICON = _iconImageFromPath("assets/CompassN.png");
Image SOUTH_ICON = _iconImageFromPath("assets/CompassS.png");
Image EAST_ICON = _iconImageFromPath("assets/CompassE.png");
Image WEST_ICON = _iconImageFromPath("assets/CompassW.png");
Image SMILEY = _iconImageFromPath("assets/Smiley.png");
Icon BUS_ZERO =
    Icon(Icons.directions_bus, color: Colors.blue, size: LOGICAL_EDGE_HEIGHT);
Icon BUS_ONE =
    Icon(Icons.directions_bus, color: Colors.red, size: LOGICAL_EDGE_HEIGHT);
Icon BUS_GENERIC =
    Icon(Icons.directions_bus, color: Colors.black, size: LOGICAL_EDGE_HEIGHT);
Icon LOOP_ICON =
    Icon(Icons.loop, color: Colors.green[800], size: LOGICAL_EDGE_HEIGHT);

Positioned _positionedText(String text) {
  return Positioned(
      bottom: 19,
      child: Text(text, style: TextStyle(fontWeight: FontWeight.w900)));
}

Widget mapIcon(String route, int direction) {
  return Stack(
      alignment: Alignment.bottomLeft,
      clipBehavior: Clip.none, // Center the text and image
      children: [
        getRouteDirectionIcon(route, direction),
        _positionedText(route)
      ]);
}

Marker labeledPushpin(String route, int direction, LatLng pointLoc) {
  return Marker(point: pointLoc, child: mapIcon(route, direction));
}

Widget getRouteDirectionIcon(String route, int direction) {
  String? directionString = gtfs.provideDirection(route, direction);
  if (directionString == null) {
    if (direction == 0) return BUS_ZERO;
    if (direction == 1) return BUS_ONE;
    return BUS_GENERIC;
  }

  switch (directionString) {
    case NORTHBOUND:
      return NORTH_ICON;
    case SOUTHBOUND:
      return SOUTH_ICON;
    case EASTBOUND:
      return EAST_ICON;
    case WESTBOUND:
      return WEST_ICON;
    case LOOP:
      return LOOP_ICON;
    default:
      return BUS_GENERIC;
  }
}
