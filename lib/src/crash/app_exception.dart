import 'package:dio/dio.dart';

/// Severity of a failure, mapped onto both logging and Crashlytics semantics.
enum ErrorSeverity { info, warning, error, fatal }

/// Base type for every classified, app-level failure.
///
/// The goal is that any error flowing through the app can be expressed as one
/// of these subtypes, so three decisions live in exactly one place:
///   1. what the user sees ([message]),
///   2. whether it reaches Crashlytics ([isReportable]),
///   3. at what [severity].
///
/// Use [AppException.from] at the boundaries (network, parsing, catch blocks)
/// to turn raw thrown objects into a classified exception.
///
/// Messages default to Turkish; override [message] (e.g. via localization) at
/// the call site if a consumer app needs another language.
sealed class AppException implements Exception {
  const AppException({
    required this.message,
    this.cause,
    this.stackTrace,
    this.context = const {},
  });

  /// User-facing message. Safe to show in a snackbar/dialog.
  final String message;

  /// The original thrown object (DioException, FormatException, ...).
  final Object? cause;

  final StackTrace? stackTrace;

  /// Structured data attached to Crashlytics reports as custom keys.
  final Map<String, Object> context;

  /// Severity used for log level and Crashlytics fatal/non-fatal weighting.
  ErrorSeverity get severity;

  /// Whether this failure should be sent to Crashlytics.
  ///
  /// Expected, user-driven outcomes (offline, validation errors, 401) are
  /// deliberately *not* reported so the dashboard stays high-signal.
  bool get isReportable;

  /// Stable label used as a Crashlytics custom key and breadcrumb tag.
  String get kind => runtimeType.toString();

  /// Classifies any thrown object into an [AppException].
  factory AppException.from(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) return error;
    if (error is DioException) return _fromDio(error, stackTrace);
    return UnknownException(cause: error, stackTrace: stackTrace);
  }

  static AppException _fromDio(DioException error, StackTrace? stackTrace) {
    final st = stackTrace ?? error.stackTrace;
    final ctx = <String, Object>{
      'method': error.requestOptions.method,
      'path': error.requestOptions.path,
    };

    // A non-exhaustive switch (with `default`) is used deliberately so this
    // compiles across dio versions that add new [DioExceptionType] values
    // (e.g. `transformTimeout` in dio 5.10+) without needing to name them.
    switch (error.type) {
      case DioExceptionType.connectionError:
        return NoConnectionException(cause: error, stackTrace: st, context: ctx);
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return RequestTimeoutException(
          cause: error,
          stackTrace: st,
          context: ctx,
        );
      case DioExceptionType.badResponse:
        return _fromStatusCode(error, st, ctx);
      default:
        // cancel, badCertificate, unknown, and any newer transport-level types.
        return UnknownException(cause: error, stackTrace: st, context: ctx);
    }
  }

  static AppException _fromStatusCode(
    DioException error,
    StackTrace? stackTrace,
    Map<String, Object> ctx,
  ) {
    final status = error.response?.statusCode ?? 0;
    final serverMessage = _extractServerMessage(error.response?.data);
    final context = {...ctx, 'statusCode': status};

    return switch (status) {
      400 || 422 => BadRequestException(
        serverMessage: serverMessage,
        cause: error,
        stackTrace: stackTrace,
        context: context,
      ),
      401 => UnauthorizedException(
        cause: error,
        stackTrace: stackTrace,
        context: context,
      ),
      403 => ForbiddenException(
        cause: error,
        stackTrace: stackTrace,
        context: context,
      ),
      404 => NotFoundException(
        cause: error,
        stackTrace: stackTrace,
        context: context,
      ),
      >= 500 => ServerException(
        statusCode: status,
        cause: error,
        stackTrace: stackTrace,
        context: context,
      ),
      _ => UnknownException(
        cause: error,
        stackTrace: stackTrace,
        context: context,
      ),
    };
  }

  /// Best-effort extraction of a backend-provided error message.
  static String? _extractServerMessage(Object? data) {
    if (data is Map) {
      for (final key in const ['message', 'error', 'detail', 'title']) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) return value;
      }
    }
    if (data is String && data.trim().isNotEmpty) return data;
    return null;
  }

  @override
  String toString() => '$kind: $message';
}

/// No internet / host unreachable. Expected, not reported.
final class NoConnectionException extends AppException {
  const NoConnectionException({super.cause, super.stackTrace, super.context})
    : super(message: 'İnternet bağlantınızı kontrol edip tekrar deneyin.');

  @override
  ErrorSeverity get severity => ErrorSeverity.warning;
  @override
  bool get isReportable => false;
}

/// Request exceeded a timeout. Transient, not reported.
final class RequestTimeoutException extends AppException {
  const RequestTimeoutException({super.cause, super.stackTrace, super.context})
    : super(message: 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.');

  @override
  ErrorSeverity get severity => ErrorSeverity.warning;
  @override
  bool get isReportable => false;
}

/// 400/422 — invalid input or a rejected business rule. Surfaces the backend
/// message when available. Expected, not reported.
final class BadRequestException extends AppException {
  BadRequestException({
    String? serverMessage,
    super.cause,
    super.stackTrace,
    super.context,
  }) : super(message: serverMessage ?? 'Geçersiz istek. Bilgileri kontrol edin.');

  @override
  ErrorSeverity get severity => ErrorSeverity.info;
  @override
  bool get isReportable => false;
}

/// 401 — handled by the auth/refresh flow. Not reported.
final class UnauthorizedException extends AppException {
  const UnauthorizedException({super.cause, super.stackTrace, super.context})
    : super(message: 'Oturumunuzun süresi doldu. Lütfen tekrar giriş yapın.');

  @override
  ErrorSeverity get severity => ErrorSeverity.info;
  @override
  bool get isReportable => false;
}

/// 403 — insufficient permissions. Expected, not reported.
final class ForbiddenException extends AppException {
  const ForbiddenException({super.cause, super.stackTrace, super.context})
    : super(message: 'Bu işlem için yetkiniz bulunmuyor.');

  @override
  ErrorSeverity get severity => ErrorSeverity.warning;
  @override
  bool get isReportable => false;
}

/// 404 — resource missing. Often expected (deleted item), not reported.
final class NotFoundException extends AppException {
  const NotFoundException({super.cause, super.stackTrace, super.context})
    : super(message: 'Aradığınız içerik bulunamadı.');

  @override
  ErrorSeverity get severity => ErrorSeverity.warning;
  @override
  bool get isReportable => false;
}

/// 5xx — backend failure. Reported as a non-fatal so we can track API health.
final class ServerException extends AppException {
  const ServerException({
    required this.statusCode,
    super.cause,
    super.stackTrace,
    super.context,
  }) : super(message: 'Sunucu kaynaklı bir hata oluştu. Lütfen tekrar deneyin.');

  final int statusCode;

  @override
  ErrorSeverity get severity => ErrorSeverity.error;
  @override
  bool get isReportable => true;
}

/// Response could not be parsed into the expected model — a client/server
/// contract mismatch. Reported, since it usually means a real bug.
final class ParsingException extends AppException {
  const ParsingException({super.cause, super.stackTrace, super.context})
    : super(message: 'Beklenmeyen bir veri hatası oluştu.');

  @override
  ErrorSeverity get severity => ErrorSeverity.error;
  @override
  bool get isReportable => true;
}

/// Anything we could not classify. Reported.
final class UnknownException extends AppException {
  const UnknownException({super.cause, super.stackTrace, super.context})
    : super(message: 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.');

  @override
  ErrorSeverity get severity => ErrorSeverity.error;
  @override
  bool get isReportable => true;
}
