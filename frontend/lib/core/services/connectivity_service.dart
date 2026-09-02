import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum ConnectionStatus { connected, disconnected }

class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();

  StreamController<ConnectionStatus>? _controller;

  Stream<ConnectionStatus> get connectionStream {
    _controller ??= StreamController<ConnectionStatus>.broadcast();

    _connectivity.onConnectivityChanged.listen((_) async {
      final hasInternet = await InternetConnection().hasInternetAccess;

      _controller?.add(
        hasInternet
            ? ConnectionStatus.connected
            : ConnectionStatus.disconnected,
      );
    });

    return _controller!.stream;
  }

  Future<bool> hasInternet() async {
    return InternetConnection().hasInternetAccess;
  }

  void dispose() {
    _controller?.close();
  }
}
