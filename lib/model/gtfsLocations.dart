import 'package:latlong2/latlong.dart';
import 'package:busneighbor_flutter/model/gtfs-realtime/gtfs-realtime.pb.dart';

class GtfsLocations {
  final Map<String, Map<int, Map<String, LatLng>>> locationsMap;
  final Map<String, VehiclePosition> vehicleIdToSource;

  GtfsLocations(this.locationsMap, this.vehicleIdToSource);
}
