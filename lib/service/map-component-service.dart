import 'dart:async';

import 'package:busneighbor_flutter/service/map-updater-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:busneighbor_flutter/service/map-marker-service.dart';
import 'package:busneighbor_flutter/service/gtfs-service.dart';
import 'package:busneighbor_flutter/service/map-updater-service.dart';
import 'package:busneighbor_flutter/service/user-location-service.dart';

class MapComponentService {
  static const String OSM_TILE_TEMPLATE =
      "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
  static const String PACKAGE_NAME = "org.dydx.busneighbor";

  static Widget getMapBox(List<Marker> markers, {BoxConstraints? constraints}) {
    return FlutterMap(
        options: MapOptions(
            initialZoom: 14, initialCenter: LatLng(39.9522, -75.1637)),
        children: [
          TileLayer(
              urlTemplate: OSM_TILE_TEMPLATE,
              userAgentPackageName: PACKAGE_NAME),
          MarkerLayer(
            markers: markers,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RichAttributionWidget(
              alignment: AttributionAlignment.bottomLeft,
              permanentHeight: 19,
              showFlutterMapAttribution: false,
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(Uri.parse(
                      'https://openstreetmap.org/copyright')), // (external)
                ),
              ],
            ),
          ),
        ]);
  }
}
