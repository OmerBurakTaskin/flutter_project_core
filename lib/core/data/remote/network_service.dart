import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_project_core/core/config/api_config.dart';
import 'package:flutter_project_core/core/models/api_response.dart';
import 'package:flutter_project_core/core/network/auth_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkService {
  final String baseUrl;
  final Dio dio;

  NetworkService({required this.baseUrl})
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 25),
          receiveTimeout: const Duration(seconds: 25),
          responseType: ResponseType.json,
          validateStatus: (status) {
            return status != null && status < 400;
          },
        ),
      ) {
    dio.interceptors.add(AuthInterceptor(dio));
    dio.interceptors.add(PrettyDioLogger());
  }

  Future<ApiResponse<I>> get<I>({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
    bool useAuth = true,
  }) async {
    final uri = Uri.parse("$baseUrl$endPoint");
    try {
      final result = await dio.getUri<I>(
        uri,
        data: body,
        options: Options(
          headers: header ?? getHeader(useAuth: useAuth),
          responseType: ResponseType.json,
        ),
      );
      if (result.data == null) {
        return ApiResponse.successNoData();
      }

      return ApiResponse.successData(result.data! as I);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      return ApiResponse.failure(
        e.response?.data["message"] ?? "Error: ${e.message ?? "Unknown error"}",
        dioError: e,
        statusCode: statusCode,
      );
    }
  }

  Future<ApiResponse<I>> post<I>({
    required String endPoint,
    required Map<String, dynamic> body,
    Map<String, String>? header,
    bool useAuth = true,
  }) async {
    final uri = Uri.parse("$baseUrl$endPoint");
    try {
      final result = await dio.postUri<I>(
        uri,
        data: body,
        options: Options(headers: header ?? getHeader(useAuth: useAuth)),
      );
      if (result.data == null) {
        return ApiResponse.successNoData();
      }
      return ApiResponse.successData(result.data! as I);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      return ApiResponse.failure(
        e.response?.data?["message"] ??
            "Error: ${e.message ?? "Unknown error"}",
        dioError: e,
        statusCode: statusCode,
      );
    }
  }

  Future<ApiResponse<I>> delete<I>({
    required String endPoint,
    bool useAuth = true,
    Map<String, dynamic>? data,
  }) async {
    final uri = Uri.parse("$baseUrl$endPoint");
    try {
      final result = await dio.deleteUri<I>(
        uri,
        data: data,
        options: Options(headers: getHeader(useAuth: useAuth)),
      );
      if (result.data == null) {
        return ApiResponse.successNoData();
      }

      return ApiResponse.successData(result.data! as I);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      return ApiResponse.failure(
        e.response?.data["message"] ?? "Error: ${e.message ?? "Unknown error"}",
        dioError: e,
        statusCode: statusCode,
      );
    }
  }

  Future<ApiResponse<I>> patch<I>({
    required String endPoint,
    required Map<String, dynamic> body,
    bool useAuth = true,
  }) async {
    final uri = Uri.parse("$baseUrl$endPoint");
    try {
      final result = await dio.patchUri<I>(
        uri,
        data: body,
        options: Options(headers: getHeader(useAuth: useAuth)),
      );
      if (result.data == null) {
        return ApiResponse.successNoData();
      }

      return ApiResponse.successData(result.data! as I);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      return ApiResponse.failure(
        e.response?.data["message"] ?? "Error: ${e.message ?? "Unknown error"}",
        dioError: e,
        statusCode: statusCode,
      );
    }
  }

  Future<ApiResponse<I>> put<I>({
    required String endPoint,
    required Map<String, dynamic> body,
    bool useAuth = true,
  }) async {
    final uri = Uri.parse("$baseUrl$endPoint");
    try {
      final result = await dio.putUri<I>(
        uri,
        data: body,
        options: Options(headers: getHeader(useAuth: useAuth)),
      );
      if (result.data == null) {
        return ApiResponse.successNoData();
      }
      return ApiResponse.successData(result.data! as I);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      return ApiResponse.failure(
        e.response?.data["message"] ?? "Error: ${e.message ?? "Unknown error"}",
        dioError: e,
        statusCode: statusCode,
      );
    }
  }

  Future<ApiResponse<I>> uploadFile<I>({
    required String endPoint,
    required String filePath,
    String fileField = 'file',
    Map<String, dynamic>? extraData,
    bool useAuth = true,
  }) async {
    final uri = Uri.parse("$baseUrl$endPoint");

    try {
      final formData = FormData.fromMap({
        fileField: await MultipartFile.fromFile(filePath),
        if (extraData != null) ...extraData,
      });

      final result = await dio.postUri<I>(
        uri,
        data: formData,
        options: Options(
          headers: {
            ...getHeader(useAuth: useAuth),
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (result.data == null) {
        return ApiResponse.successNoData();
      }

      return ApiResponse.successData(result.data! as I);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      return ApiResponse.failure(
        e.response?.data?["message"] ??
            "File upload failed: ${e.message ?? "Unknown error"}",
        dioError: e,
        statusCode: statusCode,
      );
    }
  }

  Map<String, String> getHeader({bool useAuth = true}) {
    final baseHeader = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
    };
    if (useAuth && ApiConfig.I.accesToken != null) {
      baseHeader.addAll({'Authorization': 'Bearer ${ApiConfig.I.accesToken}'});
    }
    return baseHeader;
  }
}
