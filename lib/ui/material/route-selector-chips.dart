import 'package:flutter/material.dart';
import 'package:busneighbor_flutter/service/constants/possible-routes.dart';

class RouteFilterChips extends StatefulWidget {
  final void Function(Set<String>) onRoutesSelected;
  final Set<String> routesSelectedAtCreation;

  const RouteFilterChips(
      {super.key,
      required Set<String> this.routesSelectedAtCreation,
      required this.onRoutesSelected});

  @override
  State<RouteFilterChips> createState() => _RouteFilterChipsState();
}

class _RouteFilterChipsState extends State<RouteFilterChips> {
  Set<String> selectedRoutes = {};
  bool initialRun = true;

  Widget _getChips() {
    if (initialRun) {
      setState(() {
        selectedRoutes = Set.from(widget.routesSelectedAtCreation);
        initialRun = false;
      });
    }

    assert(selectedRoutes != null);
    print("Selected routes inside selector: $selectedRoutes");
    return Wrap(
        spacing: 12.0,
        runSpacing: 8.0,
        runAlignment: WrapAlignment.spaceBetween,
        children: [
          ...POSSIBLE_ROUTES.map((String routeText) {
            return FilterChip(
              label: Text(routeText),
              selected: selectedRoutes.contains(routeText),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedRoutes.add(routeText);
                  } else {
                    selectedRoutes.remove(routeText);
                  }
                  widget.onRoutesSelected(selectedRoutes);
                });
              },
            );
          }).toList()
        ]);
  }

  @override
  Widget build(BuildContext chipFilteringContext) {
    final TextTheme textTheme = Theme.of(chipFilteringContext).textTheme;

    return Center(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 2, 25, 0),
                    child: Column(children: <Widget>[
                      Text("Choose your routes for display",
                          style: textTheme.labelLarge),
                      const SizedBox(height: 15.0),
                      _getChips(),
                      const SizedBox(height: 15.0)
                    ])))));
  }
}
