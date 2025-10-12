import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../providers/connection_provider.dart';
import '../../routes/navigator_key.dart';
import '../../utils/helper_methods.dart';
import 'connection_dialog_service.dart';
import 'connection_service.dart';


class ConectionDialogController {
  //final BuildContext buildContext;
  final Ref _ref;
  final InternetConnection _internetConnection = InternetConnection();

  StreamSubscription? _connectionSubscription;
  bool _wasConnected = false;

  ConectionDialogController(this._ref) {
    _checkConection();
    _listenConnection();
  }

  Future<void> _checkConection() async {
    _wasConnected = await locator<ConnectionService>().checkConnection();
    await checkConnectionAndShowDialog();
  }

  void _listenConnection() {
    final dialogService = locator<ConnectionDialogService>();
    _ref.listen(connectionProvider, (previous, next) async {
      final isConnected = next.value == InternetStatus.connected;
      if (!isConnected) {
        printIfDebug("Connection Gone");
        await dialogService.showConnectionDialog(navigatorKey.currentContext!);
        printIfDebug("Connection came back");
      }
      _wasConnected = isConnected;
    });
  }

  Future<void> checkConnectionAndShowDialog() async {
    final dialogService = locator<ConnectionDialogService>();

    while (true) {
      final hasConnection = await _internetConnection.hasInternetAccess;
      if (hasConnection) return;

      if (!dialogService.isDialogVisible) {
        await dialogService.showConnectionDialog(navigatorKey.currentContext!);
      }

      await dialogService.retryCompleter?.future;
    }
  }

  void dipose() {
    _connectionSubscription?.cancel();
  }
}

final connectionDialogControllerProvider = Provider<ConectionDialogController>(
  (ref) {
    final controller = ConectionDialogController(ref);
    ref.onDispose(() => controller.dipose());
    return controller;
  },
);
