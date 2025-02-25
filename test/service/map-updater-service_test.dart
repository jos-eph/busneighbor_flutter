import 'package:busneighbor_flutter/service/constants/map-constants.dart';
import 'package:test/test.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:busneighbor_flutter/service/gtfs-service.dart';
import 'package:busneighbor_flutter/service/map-updater-service.dart';

import 'package:flutter_map/flutter_map.dart';

void main() {
  final File readData = File("test/stubs/rtVehiclePosition.pb");
  final buffer = readData.readAsBytesSync();
  var vehiclePositions = GtfsService.getVehiclePositions(buffer);
  var locations = GtfsService.vehiclePositionsToGtfsLocations(vehiclePositions);

  test('Dummy data file results in expected marker results', () {
    List<Marker> markers = MapUpdaterService.getMapsForRoutesSync(
        {"47", "35", "310", "1", "29", "10001", "97", "84", "57"},
        locations); // expect missing routes to be simply skipped

    expect(markers.length, 12);

    var resultRoutes = Set<String>();
    var resultIcons = <Widget>[];
    for (Marker marker in markers) {
      Stack stack = marker.child as Stack;
      Widget icon = stack.children[0];
      resultIcons.add(icon);

      Positioned positioned = stack.children[1] as Positioned;
      Text textWidget = positioned.child as Text;
      String text = textWidget.data as String;
      resultRoutes.add(text);
    }
    expect(resultRoutes, {"47", "57", "84", "97"});
    expect(resultIcons, <Widget>[
      MapConstants.NORTH_ICON,
      MapConstants.NORTH_ICON,
      MapConstants.NORTH_ICON,
      MapConstants.SOUTH_ICON,
      MapConstants.SOUTH_ICON,
      MapConstants.WEST_ICON,
      MapConstants.SOUTH_ICON,
      MapConstants.SOUTH_ICON,
      MapConstants.NORTH_ICON,
      MapConstants.NORTH_ICON,
      MapConstants.SOUTH_ICON,
      MapConstants.SOUTH_ICON
    ]);
  });
}
