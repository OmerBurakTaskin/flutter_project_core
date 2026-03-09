import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get getHeight => MediaQuery.sizeOf(this).height;

  double get getWidth => MediaQuery.sizeOf(this).width;

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  NavigatorState get navigator => Navigator.of(this);

  Locale get locale => Localizations.localeOf(this);

  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  double get totalAppBarHeight {
    final appBarHeight = AppBar().preferredSize.height;
    final topPadding = MediaQuery.paddingOf(this).top;
    return appBarHeight + topPadding;
  }

  void unfocusKeyboard() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  /// Alternatif klavye kapatma metodu
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Focus'ı belirli bir node'a verir
  void requestFocus(FocusNode focusNode) {
    FocusScope.of(this).requestFocus(focusNode);
  }

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
              onPressed: () => Navigator.of(this).pop(false),
              child: Text(cancelText)),
          TextButton(
            onPressed: () => Navigator.of(this).pop(true),
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
