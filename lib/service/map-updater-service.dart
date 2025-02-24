import 'package:busneighbor_flutter/model/gtfsLocations.dart';
import 'package:busneighbor_flutter/service/map-marker-service.dart';
import 'package:busneighbor_flutter/service/gtfs-service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapUpdaterService {
  GtfsLocations? _gtfsLocations;

  Future<GtfsLocations> useLatestRefresh() async {
    return _gtfsLocations ??= await GtfsService.provideLocationsMap();
  }

  Future<List<Marker>> getMapsForRoutes(Set<String> routeIds) async {
    var locations = await useLatestRefresh();

    List<Marker> collectedMarkers = <Marker>[];
    for (final chosenRoute in routeIds) {
      final routeDirections = locations.locationsMap[chosenRoute] ?? Map();
      for (int directionId in routeDirections?.keys ?? Set<int>()) {
        var vehicleLocations = routeDirections[directionId] ?? Map();
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
}
