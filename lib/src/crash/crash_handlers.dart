import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'crash_reporter.dart';

/// Runs [body] inside a guarded zone whose uncaught errors are forwarded to a
/// [CrashReporter].
///
/// The reporter is provided lazily via [reporter] so the app can build and
/// register it *inside* [body] (e.g. `() => locator<CrashReporter>()`) — that
/// way errors thrown by the app's own setup are still captured, and this
/// package stays free of any service-locator dependency.
///
/// Typical usage in `main`:
/// ```dart
/// void main() {
///   runGuarded(() async {
///     WidgetsFlutterBinding.ensureInitialized();
///     await Firebase.initializeApp(...);
///     final reporter = FirebaseCrashReporter();
///     await reporter.initialize();
///     locator.registerSingleton<CrashReporter>(reporter);
///     installCrashHandlers(reporter);
///     runApp(const MyApp());
///   }, reporter: () => locator<CrashReporter>());
/// }
/// ```
void runGuarded(
  Future<void> Function() body, {
  required CrashReporter? Function() reporter,
}) {
  runZonedGuarded(body, (error, stack) {
    reporter()?.recordError(
      error,
      stack,
      fatal: true,
      reason: 'Uncaught zone error',
    );
  });
}

/// Wires every Flutter/Dart error sink to [reporter].
///
/// Capture points installed here:
///   * `FlutterError.onError`       — framework/build/layout errors
///   * `PlatformDispatcher.onError` — uncaught async errors
///   * `Isolate` error listener     — errors in background isolates (non-web)
///   * `ErrorWidget.builder`        — friendly fallback UI in release
///
/// Pass [releaseErrorBuilder] to render a custom fallback widget instead of the
/// grey/red error box in release builds. The error is already captured via
/// `FlutterError.onError`, so the builder is presentation-only.
void installCrashHandlers(
  CrashReporter reporter, {
  Widget Function(FlutterErrorDetails details)? releaseErrorBuilder,
}) {
  // Framework errors — keep the default handler so the red screen / console
  // logging still works in debug, then forward to Crashlytics.
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    originalOnError?.call(details);
    reporter.recordFlutterError(details);
  };

  // Uncaught async errors not bound to a zone.
  PlatformDispatcher.instance.onError = (error, stack) {
    reporter.recordError(
      error,
      stack,
      fatal: true,
      reason: 'PlatformDispatcher error',
    );
    return true;
  };

  // Errors thrown in background isolates (e.g. compute, plugins). Unsupported
  // on web, so guard against it.
  if (!kIsWeb) {
    Isolate.current.addErrorListener(
      RawReceivePort((dynamic pair) {
        final List<dynamic> errorAndStack = pair as List<dynamic>;
        reporter.recordError(
          errorAndStack.first ?? 'Isolate error',
          errorAndStack.last is String
              ? StackTrace.fromString(errorAndStack.last as String)
              : StackTrace.empty,
          fatal: true,
          reason: 'Background isolate error',
        );
      }).sendPort,
    );
  }

  // Render a friendly fallback instead of the grey/red box in release. The
  // error is already captured by FlutterError.onError above, so we do not
  // re-report here to avoid duplicates.
  if (releaseErrorBuilder != null) {
    final defaultErrorBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (details) {
      if (kReleaseMode) return releaseErrorBuilder(details);
      return defaultErrorBuilder(details);
    };
  }
}
