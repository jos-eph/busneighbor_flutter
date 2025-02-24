import 'package:flutter_test/flutter_test.dart';
import 'package:busneighbor_flutter/service/map-marker-service.dart';
import 'package:busneighbor_flutter/service/constants/map-constants.dart';

void main() {
  test('Test icon selected matches routes', () {
    expect(MapMarkerService.getRouteDirectionIcon("45", 0),
        MapConstants.SOUTH_ICON);
    expect(MapMarkerService.getRouteDirectionIcon("45", 1),
        MapConstants.NORTH_ICON);
    expect(MapMarkerService.getRouteDirectionIcon("64", 0),
        MapConstants.WEST_ICON);
    expect(MapMarkerService.getRouteDirectionIcon("64", 1),
        MapConstants.EAST_ICON);
    expect(MapMarkerService.getRouteDirectionIcon("35", 0),
        MapConstants.LOOP_ICON);
    expect(
        MapMarkerService.getRouteDirectionIcon("35", 1), MapConstants.BUS_ONE);
    expect(MapMarkerService.getRouteDirectionIcon("1012", 0),
        MapConstants.BUS_ZERO);
    expect(MapMarkerService.getRouteDirectionIcon("1012", 2),
        MapConstants.BUS_GENERIC);
  });
}
