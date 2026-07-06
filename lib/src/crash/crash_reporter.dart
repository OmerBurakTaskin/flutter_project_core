import 'package:flutter/foundation.dart';

import 'app_exception.dart';

/// Crash & error reporting contract.
///
/// Consumer apps depend only on this interface (typically resolved via a
/// service locator), never on Firebase directly. That keeps reporting
/// swappable/mockable and lets every call site stay free of provider-specific
/// boilerplate. The concrete implementation (e.g. a `FirebaseCrashReporter`)
/// lives in the app so it can pin its own Firebase version.
abstract interface class CrashReporter {
  /// Configures the backing provider. Must be called once during bootstrap.
  Future<void> initialize();

  /// Records a raw error. Prefer [recordAppException] when you have a
  /// classified failure.
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
    String? reason,
    Map<String, Object> context = const {},
  });

  /// Records a classified [AppException], honouring its
  /// [AppException.isReportable] and attaching its context as custom keys.
  /// Non-reportable failures only leave a breadcrumb.
  Future<void> recordAppException(AppException exception, {bool fatal = false});

  /// Records a Flutter framework error (from `FlutterError.onError`).
  Future<void> recordFlutterError(FlutterErrorDetails details);

  /// Adds a breadcrumb line to the next crash report.
  Future<void> log(String message);

  /// Records a screen view as both a Crashlytics breadcrumb and an Analytics
  /// screen-view event, so a report shows the user's recent navigation.
  Future<void> logScreen(String screenName);

  /// Associates subsequent reports with the signed-in user.
  Future<void> setUser({String? id, String? email, String? role});

  /// Clears user association (on logout).
  Future<void> clearUser();

  /// Attaches a searchable custom key to subsequent reports.
  Future<void> setCustomKey(String key, Object value);
}
