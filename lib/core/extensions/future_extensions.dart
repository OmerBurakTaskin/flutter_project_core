import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

extension IndicatorExtension on Future {
  Future<T> withIndicator<T>({String? message}) async {
    final context = navigatorKey.currentContext!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Placeholder(),
      ),
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
