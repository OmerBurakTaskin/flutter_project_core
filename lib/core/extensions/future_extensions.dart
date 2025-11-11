import 'package:flutter/material.dart';
import 'package:flutter_project_core/core/config/context_config.dart';

extension IndicatorExtension on Future {
  Future<T> withIndicator<T>(Widget loadingDialog) async {
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

      return result as T;
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      rethrow;
    }
  }
}
