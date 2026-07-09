import 'dart:ui';
import 'dart:async';


mixin DebounceMixin {
  Timer? _debounceTimer;
  void runDebounced(Duration duration, VoidCallback action) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, action);
  }

  void disposeDebounce() {
    _debounceTimer?.cancel();
  }
}