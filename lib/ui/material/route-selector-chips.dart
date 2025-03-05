import 'package:flutter/material.dart';
import 'package:busneighbor_flutter/service/constants/possible-routes.dart';

class RouteFilterChips extends StatefulWidget {
  const RouteFilterChips({super.key});

  @override
  State<RouteFilterChips> createState() => _RouteFilterChipsState();
}

class _RouteFilterChipsState extends State<RouteFilterChips> {
  Set<String> selectedRoutes = <String>{};

  @override
  Widget build(BuildContext chipFilteringContext) {
    final TextTheme textTheme = Theme.of(chipFilteringContext).textTheme;

    return FlutterLogo();
  }
}
