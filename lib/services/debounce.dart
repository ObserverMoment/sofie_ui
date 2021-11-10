import 'dart:async';

class Debouncer {
  Timer? _debounceTimer;
  int ms;
  Debouncer({this.ms = 500});

  void run(void Function() fn) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(Duration(milliseconds: ms), fn);
  }

  void dispose() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
  }
}
