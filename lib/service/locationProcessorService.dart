import 'package:protobuf/protobuf.dart';
import 'package:busneighbor_flutter/model/gtfs-realtime/gtfs-realtime.pb.dart';

class GtfsProcessorService {
  List<VehiclePosition> getVehicles(List<int> rawBinaryBuffer) {
    final feedMessage = FeedMessage.fromBuffer(rawBinaryBuffer);
    return feedMessage.entity
        .where((feedEntity) => feedEntity.hasVehicle())
        .map((feedEntity) => feedEntity.vehicle)
        .toList();
  }

  
}
