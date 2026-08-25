import 'dart:async';

class SessionExpiredController {
  final StreamController<void> _controller =
      StreamController<void>.broadcast();

  Stream<void> get onSessionExpired => _controller.stream;

  bool _isNotifying = false;

  void notify() {
    if (_isNotifying) return;
    _isNotifying = true;
    _controller.add(null);
  }

  void reset() {
    _isNotifying = false;
  }

  void dispose() => _controller.close();
}
