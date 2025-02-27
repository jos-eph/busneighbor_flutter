import 'dart:async';

import 'package:busneighbor_flutter/service/map-component-service.dart';
import 'package:busneighbor_flutter/service/map-updater-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:busneighbor_flutter/service/map-marker-service.dart';
import 'package:busneighbor_flutter/service/gtfs-service.dart';
import 'package:busneighbor_flutter/service/map-updater-service.dart';
import 'package:busneighbor_flutter/service/user-location-service.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

MapUpdaterService mapUpdaterService = MapUpdaterService();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  LatLng userPosition = UserLocationService.CITY_HALL;

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
    var subscription = UserLocationService.registerForPositions(
        updateUserPosition,
        onError: handleLocationError);
    setState(() {
      userLocationSubscription = subscription;
    });
  }

  void updateUserPosition(Position position) {
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

    List<Marker> newMarkers =
        await mapUpdaterService.getMapsForRoutes({"45", "47", "4", "29"});
    setState(() => _markers = newMarkers);
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without callin setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void incrementAndUpdate() {
    _incrementCounter();
    _updateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            MapComponentService.getMapBox(_markers)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementAndUpdate,
        tooltip: 'Increment/update',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
