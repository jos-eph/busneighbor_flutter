import 'package:busneighbor_flutter/service/direction-map.dart';
import 'package:http/http.dart';
import 'package:busneighbor_flutter/model/gtfs-realtime/gtfs-realtime.pb.dart';
import 'package:latlong2/latlong.dart';
import 'package:busneighbor_flutter/model/gtfsLocations.dart';
import 'package:busneighbor_flutter/service/gtfs-service.dart';

final Uri SEPTA_LOCATIONS_GTFS = Uri.parse(
    "https://www3.septa.org/gtfsrt/septa-pa-us/Vehicle/rtVehiclePosition.pb");

const NORTHBOUND = "Northbound";
const SOUTHBOUND = "Southbound";
const EASTBOUND = "Eastbound";
const WESTBOUND = "Westbound";
const LOOP = "Loop";

class GtfsService {
  List<VehiclePosition> getVehiclePositions(List<int> rawBinaryBuffer) {
    final feedMessage = FeedMessage.fromBuffer(rawBinaryBuffer);
    return feedMessage.entity
        .where((feedEntity) => feedEntity.hasVehicle())
        .map((feedEntity) => feedEntity.vehicle)
        .toList();
  }

  Future<List<VehiclePosition>> retrieveVehiclePositions() async {
    List<int> positionsProtoBuf = await getLocationProtoBuf();
    return getVehiclePositions(positionsProtoBuf);
  }

  Future<List<int>> getLocationProtoBuf() async {
    Response response;
    try {
      response = await get(SEPTA_LOCATIONS_GTFS);
      if (response.statusCode != 200) {
        throw Exception("Status code was ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching data: $e");
      throw Exception(e);
    }

    return response.bodyBytes;
  }

  Map<int, Map<String, LatLng>> createDirectionIdLevel() {
    return Map<int, Map<String, LatLng>>();
  }

  Map<String, LatLng> createVehicleLocationLevel() {
    return Map<String, LatLng>();
  }

  GtfsLocations vehiclePositionsToGtfsLocations(
      List<VehiclePosition> positions) {
    var locationsMap = Map<String, Map<int, Map<String, LatLng>>>();
    var vehicleIdToSource = Map<String, VehiclePosition>();

    for (VehiclePosition vehiclePosition in positions) {
      double lat = vehiclePosition.position.latitude;
      double lng = vehiclePosition.position.longitude;
      int direction = vehiclePosition.trip.directionId;
      String route = vehiclePosition.trip.routeId;
      String vehicleId = vehiclePosition.vehicle.id;

      vehicleIdToSource[vehicleId] = vehiclePosition; // set source

      locationsMap.putIfAbsent(route, createDirectionIdLevel).putIfAbsent(
          direction, createVehicleLocationLevel)[vehicleId] = LatLng(lat, lng);
    }

    return GtfsLocations(locationsMap, vehicleIdToSource);
  }

  Future<GtfsLocations> provideLocationsMap() async {
    List<VehiclePosition> positions = await retrieveVehiclePositions();
    var gtfsLocations = vehiclePositionsToGtfsLocations(positions);
    print(gtfsLocations.locationsMap);
    return gtfsLocations;
  }

  String? provideDirection(String route, int direction) {
    return routeDirectionIdDirection?[route]?[direction];
  }
}
