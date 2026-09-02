import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  Future<List<ConnectivityResult>> get currentConnectivity =>
      _connectivity.checkConnectivity();

  Future<bool> get isConnected async {
    final result = await currentConnectivity;

    return result.any((connection) => connection != ConnectivityResult.none);
  }
}
