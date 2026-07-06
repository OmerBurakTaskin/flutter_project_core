import 'package:dio/dio.dart';

import 'app_exception.dart';
import 'crash_reporter.dart';

/// Classifies every Dio failure into an [AppException] and forwards the
/// reportable ones (5xx, parsing, unknown) to Crashlytics as non-fatals,
/// tagged with method/path/status. Expected outcomes (offline, 4xx, 401) are
/// classified too but skipped by [CrashReporter.recordAppException].
///
/// Placed **last** in the interceptor chain so it only sees errors that
/// survived the auth-refresh and transport-retry interceptors.
class CrashReportingInterceptor extends Interceptor {
  CrashReportingInterceptor(this._reporter);

  final CrashReporter _reporter;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _reporter.recordAppException(AppException.from(err, err.stackTrace));
    handler.next(err);
  }
}
