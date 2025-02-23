import 'package:flutter_test/flutter_test.dart';
import 'package:busneighbor_flutter/markers.dart';

void main() {
  test('Test icon selected matches routes', () {
    expect(getRouteDirectionIcon("45", 0), SOUTH_ICON);
    expect(getRouteDirectionIcon("45", 1), NORTH_ICON);
    expect(getRouteDirectionIcon("64", 0), WEST_ICON);
    expect(getRouteDirectionIcon("64", 1), EAST_ICON);
    expect(getRouteDirectionIcon("35", 0), LOOP_ICON);
    expect(getRouteDirectionIcon("35", 1), BUS_ONE);
    expect(getRouteDirectionIcon("1012", 0), BUS_ZERO);
    expect(getRouteDirectionIcon("1012", 2), BUS_GENERIC);
  });
}
