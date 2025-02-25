import 'package:busneighbor_flutter/service/constants/direction-map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:busneighbor_flutter/service/gtfs-service.dart';
import 'package:busneighbor_flutter/service/constants/map-constants.dart';

class MapMarkerService {
  static Image iconImageFromPath(String path) {
    return Image.asset(path,
        height: MapConstants.LOGICAL_EDGE_HEIGHT,
        width: MapConstants.LOGICAL_EDGE_HEIGHT);
  }

  static Positioned _positionedText(String text) {
    return Positioned(
        bottom: 19,
        child: Text(text, style: TextStyle(fontWeight: FontWeight.w900)));
  }

  static Widget mapIcon(String route, int direction) {
    return Stack(
        alignment: Alignment.bottomLeft,
        clipBehavior: Clip.none, // Center the text and image
        children: [
          getRouteDirectionIcon(route, direction),
          _positionedText(route)
        ]);
  }

  static Marker labeledPushpin(String route, int direction, LatLng pointLoc) {
    return Marker(point: pointLoc, child: mapIcon(route, direction));
  }

  static Widget getRouteDirectionIcon(String route, int direction) {
    String? directionString = GtfsService.provideDirection(route, direction);
    if (directionString == null) {
      if (direction == 0) return MapConstants.BUS_ZERO;
      if (direction == 1) return MapConstants.BUS_ONE;
      return MapConstants.BUS_GENERIC;
    }

    switch (directionString) {
      case NORTHBOUND:
        return MapConstants.NORTH_ICON;
      case SOUTHBOUND:
        return MapConstants.SOUTH_ICON;
      case EASTBOUND:
        return MapConstants.EAST_ICON;
      case WESTBOUND:
        return MapConstants.WEST_ICON;
      case LOOP:
        return MapConstants.LOOP_ICON;
      default:
        return MapConstants.BUS_GENERIC;
    }
  }
}
