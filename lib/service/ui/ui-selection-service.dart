import 'dart:io';

class UiSelectionService {
  static bool useCupertino() {
    return Platform.isIOS || Platform.isMacOS;
  }

  static Function buildMain() {
    return () => {};
  }
}
