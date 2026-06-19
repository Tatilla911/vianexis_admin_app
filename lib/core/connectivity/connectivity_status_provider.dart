import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityStatusNotifier extends Notifier<bool> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  bool build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });
    _subscription = Connectivity().onConnectivityChanged.listen(_updateFromResults);
    unawaited(_refresh());
    return true;
  }

  Future<void> _refresh() async {
    final results = await Connectivity().checkConnectivity();
    _updateFromResults(results);
  }

  void _updateFromResults(List<ConnectivityResult> results) {
    final online = results.any((result) => result != ConnectivityResult.none);
    if (state != online) {
      state = online;
    }
  }
}

final connectivityOnlineProvider =
    NotifierProvider<ConnectivityStatusNotifier, bool>(
      ConnectivityStatusNotifier.new,
    );
