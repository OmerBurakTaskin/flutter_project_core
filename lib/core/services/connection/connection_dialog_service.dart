import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../widgets/dialogs/connection_lost_dialog.dart';

class ConnectionDialogService {
  bool isDialogVisible = false;
  Completer<void>? _retryCompleter;

  Completer<void>? get retryCompleter => _retryCompleter;
  final InternetConnection _internetConnection = InternetConnection();

  Future<void> showConnectionDialog(BuildContext context) async {
    if (isDialogVisible) {
      return _retryCompleter?.future;
      
    }
    isDialogVisible = true;
    _retryCompleter = Completer<void>();
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ConnectionLostDialog(onPressed: () async {
            final hasConnection = await _internetConnection.hasInternetAccess;
            if (hasConnection) {
              if (!_retryCompleter!.isCompleted) {
                _retryCompleter!.complete();
              }
              dismissDialog(context);
            }
          });
        });
    return _retryCompleter!.future;
  }

  void dismissDialog(BuildContext context) {
    if (isDialogVisible && context.mounted) {
      Navigator.of(context).pop();
      isDialogVisible=false;

      if (_retryCompleter != null && !_retryCompleter!.isCompleted) {
        _retryCompleter!.complete();
      }
    }
  }
}
