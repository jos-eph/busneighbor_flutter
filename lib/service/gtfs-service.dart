import 'package:http/http.dart';
import 'package:protobuf/protobuf.dart';
import 'package:busneighbor_flutter/model/gtfs-realtime/gtfs-realtime.pb.dart';

final Uri SEPTA_LOCATIONS_GTFS = Uri.parse(
    "https://www3.septa.org/gtfsrt/septa-pa-us/Vehicle/rtVehiclePosition.pb");

class GtfsService {
  List<VehiclePosition> getVehicles(List<int> rawBinaryBuffer) {
    final feedMessage = FeedMessage.fromBuffer(rawBinaryBuffer);
    return feedMessage.entity
        .where((feedEntity) => feedEntity.hasVehicle())
        .map((feedEntity) => feedEntity.vehicle)
        .toList();
  }

  Future<List<VehiclePosition>> getPositions() async {
    List<int> positionsProtoBuf = await getLocationProtoBuf();
    return getVehicles(positionsProtoBuf);
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

  Future<void> printLocationsTest() async {
    List<VehiclePosition> positions = await getPositions();
    for (VehiclePosition position in positions) {
      double lat = position.position.latitude;
      double lng = position.position.longitude;
      int direction = position.trip.directionId;
      String route = position.trip.routeId;
      String vehicleId = position.vehicle.id;

      print("$lat\t$lng\t$direction\t$route\t$vehicleId");
    }
  }


}
