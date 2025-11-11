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

  Future<void> pushNamed<T>(String route, {T? extra}) async =>
      Navigator.of(this).pushNamed(route, arguments: extra);

  Future<void> push<T>(Widget view, {T? extra}) async =>
      Navigator.of(this).push(
        MaterialPageRoute(
          builder: (_) => view,
          settings: RouteSettings(arguments: extra),
        ),
      );

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);

  Future<void> pushReplacementNamed<T>(String route, {T? extra}) async =>
      Navigator.of(this).pushReplacementNamed(route, arguments: extra);

  Future<void> pushUntilNamed<T>(String route, {T? extra}) async =>
      Navigator.of(
        this,
      ).pushNamedAndRemoveUntil(route, (route) => false, arguments: extra);

  Future noAnimationPushReplacemen<T>(Widget view, {T? extra}) async {
    return Navigator.of(this).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => view,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

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
          TextButton(onPressed: () => pop(false), child: Text(cancelText)),
          TextButton(
            onPressed: () => pop(true),
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
