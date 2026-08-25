import 'dart:async';

class SessionExpiredController {
  final StreamController<void> _controller =
      StreamController<void>.broadcast();

  Stream<void> get onSessionExpired => _controller.stream;

  bool _expired = false;

  void notify() {
    if (_expired) return;
    _expired = true;
    _controller.add(null);
  }

  void reset() => _expired = false;

  void dispose() => _controller.close();
}
