
import 'package:flutter_project_core/src/models/api_response.dart';

extension ApiResponseExtension on ApiResponse<Map<String, dynamic>> {
  ApiResponse<T> convertToModel<T>(
    T Function(Map<String, dynamic>) fromJson, {
    String? select,
  }) {
    if (isSuccess) {
      if (select != null) {
        return ApiResponse.successData(
          fromJson(data![select] as Map<String, dynamic>),
        );
      }
      return ApiResponse.successData(fromJson(data!));
    } else {
      return ApiResponse.failure(
        error ?? "Unknown error",
        dioError: dioError,
        statusCode: statusCode,
      );
    }
  }

  ApiResponse<T> parse<T>(
    T Function(Map<String, dynamic>) parser, {
    String? select,
  }) {
    if (isSuccess) {
      if (select != null) {
        return ApiResponse.successData(
          parser(data![select] as Map<String, dynamic>),
        );
      }
      return ApiResponse.successData(parser(data!));
    } else {
      return ApiResponse.failure(
        error ?? "Unknown error",
        dioError: dioError,
        statusCode: statusCode,
      );
    }
  }
}
