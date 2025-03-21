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
const SELECTED_ROUTES_NAME = "selectedRoutes"; // retrieve and use data
const DEFAULT_ROUTES = {"4", "29", "45"};
const REFRESH_EVERY_SECS = 8;

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
  late Timer _timer;
  Set<String> routesSelected = {"4", "29", "45"};

  StreamSubscription? userLocationSubscription;

  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _selfInit();
  }

  void showError(String errorText) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
              title: Text("Error"),
              content: Text(errorText),
              actions: <Widget>[
                TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    })
              ]);
        });
  }

  Future<void> _selfInit() async {
    bool locationsOn = await UserLocationService.ensureLocationPermission();
    if (!locationsOn) {
      showError("User locations are off; using default");
    }

    var locationSubscription = UserLocationService.registerForPositions(
        _updateUserPosition,
        onError: handleLocationError);

    var prefsObject = await SharedPreferences.getInstance();
    setState(() {
      userLocationSubscription = locationSubscription;
      prefs = prefsObject;
    });

    Set<String> storedRoutes = retrieveSavedRoutes();

    setState(() {
      if (storedRoutes.isNotEmpty) {
        routesSelected = storedRoutes;
      }
    });

    _updateMarkers();
    _timer = Timer.periodic(Duration(seconds: REFRESH_EVERY_SECS), (timer) {
      _updateMarkers();
    });
  }

  void savePreferredRoutes() async {
    await prefs.setStringList(SELECTED_ROUTES_NAME, routesSelected.toList());
    print("Preferences saved - $routesSelected");
  }

  Set<String> retrieveSavedRoutes() {
    List<String>? storedRoutes;

    try {
      storedRoutes = prefs.getStringList(SELECTED_ROUTES_NAME);
    } catch (ex) {
      showError("Exception for storedRoutes: $ex");
      return {};
    }

    if (storedRoutes == null) {
      print("storedRoutes null");
      return {};
    }

    print("Stored routes retrieved as $storedRoutes");

    return Set.from(storedRoutes);
  }

  void _updateUserPosition(Position position) {
    LatLng convertedToPosition = UserLocationService.positionToLatlng(position);
    print("Obtained updated position $convertedToPosition");

    setState(() {
      userPosition = convertedToPosition;
    });
  }

  void handleLocationError(Object error, StackTrace stacktrace) {
    showError("Error obtaining user location: $error. Stacktrace: $stacktrace");
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

  void selectionUpdate(Set<String> selectedRoutes) {
    setState(() {
      routesSelected = selectedRoutes;
      _updateMarkers();
    });
    savePreferredRoutes();
    print(selectedRoutes);
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: MapComponentService.getMapBox(_markers),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: mainContext,
              builder: (context) => RouteFilterChips(
                    routesSelectedAtCreation: routesSelected,
                    onRoutesSelected: selectionUpdate,
                  ));
        },
        tooltip: 'Settings',
        child: const Icon(Icons.settings),
      ),
    );
  }
}
