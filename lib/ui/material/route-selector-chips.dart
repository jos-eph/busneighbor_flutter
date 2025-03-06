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

  Widget _getChips() {
    setState(() {
      if (selectedRoutes.isEmpty) {
        selectedRoutes = Set.from(widget.routesSelectedAtCreation);
      }
    });
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

  Widget _getSelectedSummary(TextTheme theme) {
    return Text('Selected: routes ${selectedRoutes.toList().join(', ')}',
        style: theme.labelLarge);
  }

  @override
  Widget build(BuildContext chipFilteringContext) {
    final TextTheme textTheme = Theme.of(chipFilteringContext).textTheme;

    return Center(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(children: <Widget>[
                      Text("Choose your routes for display",
                          style: textTheme.labelLarge),
                      const SizedBox(height: 15.0),
                      _getChips(),
                      const SizedBox(height: 15.0),
                      _getSelectedSummary(textTheme)
                    ])))));
  }
}
