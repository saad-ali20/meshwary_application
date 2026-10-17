import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Observes network connectivity state.
/// Registered as a lazy singleton via DI.
class ConnectivityService {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final _controller = StreamController<bool>.broadcast();

  bool _isConnected = true;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// Whether the device currently has network access.
  bool get isConnected => _isConnected;

  /// Stream of connectivity changes (true = connected, false = disconnected).
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Must be called once during app initialization.
  Future<void> initialize() async {
    final result = await _connectivity.checkConnectivity();
    _isConnected = _resultToConnected(result);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final connected = _resultToConnected(results);
      if (connected != _isConnected) {
        _isConnected = connected;
        _controller.add(_isConnected);
      }
    });
  }

  bool _resultToConnected(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
