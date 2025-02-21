import 'package:test/test.dart';
import 'dart:io';
import 'package:busneighbor_flutter/service/gtfs-service.dart';

void main() {
  test('Dummy test', () {
    expect(1, 1);
    var service = GtfsService();

    File readData = File("test/stubs/rtVehiclePosition.pb");
    var bytes = readData.readAsBytesSync();
    var feedMessage = service.getVehicles(bytes);
    print("$feedMessage");
  });
}
