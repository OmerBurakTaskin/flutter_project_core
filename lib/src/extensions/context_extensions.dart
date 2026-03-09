import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get getHeight => MediaQuery.sizeOf(this).height;

  double get getWidth => MediaQuery.sizeOf(this).width;

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  NavigatorState get navigator => Navigator.of(this);

  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  Color get primaryContainer => ColorScheme.of(this).primaryContainer;

  T? getArguments<T>() => ModalRoute.of(this)?.settings.arguments as T?;

  Future<bool?> showAlertDialog({
    String? title,
    String? content,
    String cancelText = 'İptal',
    String confirmText = 'Onayla',
    bool isDestructiveAction = false,
  }) async {
    return await showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDestructiveAction
                ? TextButton.styleFrom(foregroundColor: colorScheme.error)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
