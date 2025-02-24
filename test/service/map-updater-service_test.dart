import 'package:busneighbor_flutter/service/map-updater-service.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:busneighbor_flutter/service/gtfs-service.dart';
import 'package:flutter_map/flutter_map.dart';

void main() {
  final File readData = File("test/stubs/rtVehiclePosition.pb");
  final buffer = readData.readAsBytesSync();
  var vehiclePositions = GtfsService.getVehiclePositions(buffer);
  var locations = GtfsService.vehiclePositionsToGtfsLocations(vehiclePositions);

  test('Placeholder', () {
    List<Marker> markers =
        MapUpdaterService.getMapsForRoutesSync({"1", "47", "10001"}, locations);
    print(markers);
    return true;
  });
}
