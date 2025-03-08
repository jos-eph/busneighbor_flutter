import 'dart:convert';
import 'package:busneighbor_flutter/model/gtfsLocations.dart';
import 'package:busneighbor_flutter/service/map-marker-service.dart';
import 'package:busneighbor_flutter/service/gtfs-service.dart';
import 'package:flutter_map/flutter_map.dart';

class MapUpdaterService {
  static List<Marker> getMapsForRoutesSync(
      Set<String> routeIds, GtfsLocations locations) {
    List<Marker> collectedMarkers = <Marker>[];
    for (String chosenRoute in routeIds) {
      final routeDirections = locations.locationsMap[chosenRoute] ?? Map();
      for (int directionId in routeDirections.keys) {
        final vehicleLocations = routeDirections[directionId] ?? Map();
        for (String vehicleId in vehicleLocations.keys) {
          if (vehicleLocations[vehicleId] != null) {
            collectedMarkers.add(MapMarkerService.labeledPushpin(
                chosenRoute, directionId, vehicleLocations[vehicleId]!));
          }
        }
      }
    }

    return collectedMarkers;
  }

  Future<List<Marker>> getMapsForRoutes(Set<String> routeIds) async {
    GtfsLocations locations = await GtfsService.provideLocationsMap();
    var keys = locations.locationsMap.keys.toList();
    var keyString = jsonEncode(keys);
    print(keyString);
    return getMapsForRoutesSync(routeIds, locations);
  }
}
