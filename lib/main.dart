import 'dart:async';
import 'dart:io';

import 'package:busneighbor_flutter/service/constants/map-constants.dart';
import 'package:busneighbor_flutter/service/map-component-service.dart';
import 'package:busneighbor_flutter/service/map-updater-service.dart';
import 'package:busneighbor_flutter/ui/material/route-selector-chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:busneighbor_flutter/service/map-marker-service.dart';
import 'package:busneighbor_flutter/service/user-location-service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

MapUpdaterService mapUpdaterService = MapUpdaterService();
const SELECTED_ROUTES = "selectedRoutes"; // retrieve and use data

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BusNeighbor Skeleton',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppHome(title: 'BusNeighbor Demo App'),
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({super.key, required this.title});
  final String title;

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _counter = 0;
  LatLng? userPosition;
  late SharedPreferences prefs;
  Set<String> routesSelected = {"4", "29", "45"};

  StreamSubscription? userLocationSubscription;

  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _selfInit();
  }

  Future<void> _selfInit() async {
    bool locationsOn = await UserLocationService.ensureLocationPermission();
    if (!locationsOn) {
      print("Locations off.");
      return;
    }
    print("Locations on!");
    var locationSubscription = UserLocationService.registerForPositions(
        _updateUserPosition,
        onError: handleLocationError);

    var prefsObject = await SharedPreferences.getInstance();
    setState(() {
      userLocationSubscription = locationSubscription;
      prefs = prefsObject;
    });
  }

  void _updateUserPosition(Position position) {
    LatLng convertedToPosition = UserLocationService.positionToLatlng(position);
    print("Obtained updated position $convertedToPosition");

    setState(() {
      userPosition = convertedToPosition;
    });
  }

  void handleLocationError(Object error, StackTrace stacktrace) {
    print("Error obtaining user location: $error. Stacktrace: $stacktrace");
  }

  Future<void> _updateMarkers() async {
    print("Updating markers...");

    List<Marker> newMarkers = [
      ...await mapUpdaterService.getMapsForRoutes(routesSelected),
      userPosition != null
          ? MapMarkerService.getUserLocationIcon(userPosition!)
          : MapMarkerService.getNoUserLocationIcon(MapConstants.CITY_HALL)
    ];
    setState(() => _markers = newMarkers);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void incrementAndUpdate() {
    _incrementCounter();
    _updateMarkers();
  }

  void selectionUpdate(Set<String> selectedRoutes) {
    setState(() {
      routesSelected = selectedRoutes;
      _updateMarkers();
    });
    print(selectedRoutes);
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(mainContext).textTheme.headlineMedium,
            ),
            MapComponentService.getMapBox(_markers)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          incrementAndUpdate();
          showModalBottomSheet(
              context: mainContext,
              builder: (context) => RouteFilterChips(
                    routesSelectedAtCreation: routesSelected,
                    onRoutesSelected: selectionUpdate,
                  ));
        },
        tooltip: 'Increment/update',
        child: const Icon(Icons.add),
      ),
    );
  }
}
