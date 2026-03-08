import 'package:flutter/material.dart';
import 'package:flutter_project_core/src/config/context_config.dart';

extension IndicatorExtension<T> on Future<T> {
  Future<T> withIndicator(Widget loadingDialog) async {
    final context = navigatorKey.currentContext!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: loadingDialog),
    );

    try {
      final result = await this;
      await Future.delayed(Duration(milliseconds: 100));
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      return result;
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      rethrow;
    }
  }
}
