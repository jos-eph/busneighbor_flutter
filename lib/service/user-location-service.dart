import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class UserLocationService {
  static LatLng CITY_HALL = LatLng(39.9528, -75.1635);

  static Future<bool> locationServicesEnabled() async {
    return await Geolocator
        .isLocationServiceEnabled(); // device-wide, not app permissions
  }

  static Future<bool> canUseLocation() async {
    return await locationServicesEnabled() && await ensureLocationPermission();
  }

  // location services are automatically requested to be on when we request permission

  static Future<bool> ensureLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
    }

    print("Geolocation permission granted");

    return true;
  }

  static Future<Position> _determinePosition() async {
    if (!await ensureLocationPermission()) {
      return Future.error('Location permissions are denied');
    }

    // If permissions are granted, return the current location
    return await Geolocator.getCurrentPosition();
  }

  static Future<LatLng> provideLocation() async {
    Position position;

    try {
      position = await _determinePosition();
    } catch (e) {
      return CITY_HALL;
    }

    return LatLng(position.latitude, position.longitude);
  }

  static LocationSettings _getLocationSettings() {
    return LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 0);
  }

  static StreamSubscription<Position> registerForPositions(
      Function(Position) onData,
      {Function? onError,
      Function()? onDone,
      bool? cancelOnError}) {
    return Geolocator.getPositionStream(
            locationSettings: _getLocationSettings())
        .listen(onData,
            onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static LatLng positionToLatlng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }
}
