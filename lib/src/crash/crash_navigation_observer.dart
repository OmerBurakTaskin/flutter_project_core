import 'package:flutter/widgets.dart';

import 'crash_reporter.dart';

/// A [NavigatorObserver] that records each navigation as a Crashlytics
/// breadcrumb + Analytics screen view (both handled by
/// [CrashReporter.logScreen]), so a crash report shows the trail of screens the
/// user visited beforehand.
///
/// Framework-agnostic: attach it via `GoRouter(observers: [...])` or
/// `MaterialApp(navigatorObservers: [...])`. The screen name comes from
/// `route.settings.name`; for path-based routers that don't set a name,
/// pass [nameExtractor] to derive one (e.g. from the current location).
class CrashNavigationObserver extends NavigatorObserver {
  CrashNavigationObserver(
    this._reporter, {
    String? Function(Route<dynamic> route)? nameExtractor,
  }) : _nameExtractor = nameExtractor ?? _defaultNameExtractor;

  final CrashReporter _reporter;
  final String? Function(Route<dynamic> route) _nameExtractor;

  String? _lastScreen;

  static String? _defaultNameExtractor(Route<dynamic> route) =>
      route.settings.name;

  void _report(Route<dynamic>? route) {
    if (route == null) return;
    final name = _nameExtractor(route);
    if (name == null || name.isEmpty || name == _lastScreen) return;
    _lastScreen = name;
    _reporter.logScreen(name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _report(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _report(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _report(previousRoute);
  }
}
