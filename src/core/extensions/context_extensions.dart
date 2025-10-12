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

  //AppLocalizations get tr => AppLocalizations.of(this)!;

  Locale get currentLocale => Localizations.localeOf(this);

  Future<void> toNamed(String routeName) async =>
      await Navigator.pushNamed(this, routeName);

  Future<void> toNamedReplacement(String routeName) async =>
      await Navigator.pushReplacementNamed(this, routeName);

  void pop() => Navigator.pop(this);

  Future<void> toNamedAndRemoveUntil(String routeName) async =>
      await Navigator.pushNamedAndRemoveUntil(
          this, routeName, (route) => false);
}
