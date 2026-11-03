abstract interface class SessionClock {
  int get elapsedMilliseconds;
  void start();
  void pause();
  void reset();
}

/// Stopwatch uses elapsed time instead of counting UI ticks or wall-clock changes.
class MonotonicSessionClock implements SessionClock {
  final _watch = Stopwatch();
  @override
  int get elapsedMilliseconds => _watch.elapsedMilliseconds;
  @override
  void start() => _watch.start();
  @override
  void pause() => _watch.stop();
  @override
  void reset() {
    _watch.stop();
    _watch.reset();
  }
}
