import 'package:dio/dio.dart';

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  final int? statusCode;
  final DioException? dioError;

  bool get isFailure => !isSuccess;

  ApiResponse._({
    this.data,
    this.error,
    this.statusCode,
    this.dioError,
    required this.isSuccess,
  });

  factory ApiResponse.failure(
    String error, {
    int? statusCode,
    DioException? dioError,
  }) {
    return ApiResponse._(
      isSuccess: false,
      error: error,
      statusCode: statusCode,
      dioError: dioError,
    );
  }

  factory ApiResponse.successData(T data) {
    return ApiResponse._(data: data, isSuccess: true);
  }

  factory ApiResponse.successNoData() {
    return ApiResponse._(isSuccess: true);
  }

  R? when<R>({
    required R? Function(T data) onSuccess,
    required R? Function(String error) onError,
  }) {
    if (data != null) {
      return onSuccess(data as T);
    } else {
      return onError(error ?? "Unknown error occured");
    }
  }
}
