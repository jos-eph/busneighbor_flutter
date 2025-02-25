import 'package:flutter/material.dart';

import 'package:busneighbor_flutter/service/map-marker-service.dart';

class MapConstants {
  static const double LOGICAL_EDGE_HEIGHT = 22;

  static final Image NORTH_ICON =
      MapMarkerService.iconImageFromPath("assets/CompassN.png");
  static final Image SOUTH_ICON =
      MapMarkerService.iconImageFromPath("assets/CompassS.png");
  static final Image EAST_ICON =
      MapMarkerService.iconImageFromPath("assets/CompassE.png");
  static final Image WEST_ICON =
      MapMarkerService.iconImageFromPath("assets/CompassW.png");
  static final Image SMILEY =
      MapMarkerService.iconImageFromPath("assets/Smiley.png");
  static final Icon BUS_ZERO =
      Icon(Icons.directions_bus, color: Colors.blue, size: LOGICAL_EDGE_HEIGHT);
  static final Icon BUS_ONE =
      Icon(Icons.directions_bus, color: Colors.red, size: LOGICAL_EDGE_HEIGHT);
  static final Icon BUS_GENERIC = Icon(Icons.directions_bus,
      color: Colors.black, size: LOGICAL_EDGE_HEIGHT);
  static final Icon LOOP_ICON =
      Icon(Icons.loop, color: Colors.green[800], size: LOGICAL_EDGE_HEIGHT);
}
