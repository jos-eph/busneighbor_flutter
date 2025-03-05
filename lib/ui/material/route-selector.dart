import 'package:busneighbor_flutter/service/constants/possible-routes.dart';
import 'package:flutter/material.dart';

Widget? _getRouteTile(BuildContext routeListContext, int index) {
  String route;
  try {
    route = POSSIBLE_ROUTES[index];
  } catch (err) {
    return null;
  }

  return ListTile(
    title: Text("${route}"),
    selected: true,
    selectedTileColor: Colors.deepPurple,
    onTap: () {
      // logic for route selection
      Navigator.pop(routeListContext);
    },
  );
}

Widget buildMaterialRouteSelector(BuildContext contextOfRouteSelector) {
  return Column(
    children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
                labelText: "Search Routes", prefixIcon: Icon(Icons.search)),
          )),
      Expanded(
          child: ClipRect(
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: POSSIBLE_ROUTES.length,
                  itemBuilder: _getRouteTile)))
    ],
  );
}
