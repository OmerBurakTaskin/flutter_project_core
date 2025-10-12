import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/api_response.dart';
import '../../utils/helper_methods.dart';

class ApiService {
  final String baseUrl;
  String? accessToken;
  final Dio dio;
  Timer? tokenRefresher;

  ApiService({required this.baseUrl, this.tokenRefresher})
      : dio = Dio(BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 25),
            receiveTimeout: const Duration(seconds: 25),
            responseType: ResponseType.json,
            validateStatus: (status) {
              return status != null && status < 400;
            }))
          ..interceptors.add(PrettyDioLogger());

  Future<ApiResponse<I>> get<I>(
      {required String endPoint, Map<String, dynamic>? body}) async {
    final uri = Uri.parse("$baseUrl$endPoint");
    try {
      final result = await dio.getUri<I>(uri,
          data: body,
          options:
              Options(headers: getHeader(), responseType: ResponseType.json));
      return ApiResponse.success(result.data! as I);
    } on DioException catch (e) {
      printIfDebug("Error on GET request. Error: $e");
      return ApiResponse.failure("Dio Error: $e");
    } catch (e) {
      return ApiResponse.failure("Error: $e");
    }
  }

  //checks if pintra sever is working
  Future<bool> ping() async {
    final result = await get(endPoint: "ping");
    if ((result.data?.data ?? {} as Map<String, dynamic>)["message"] ==
        "pong") {
      return true;
    }
    return false;
  }

  Future<ApiResponse<I>> post<I>(
      {required String endPoint, required Map<String, dynamic> body}) async {
    final uri = Uri.parse("$baseUrl$endPoint");
    try {
      final result = await dio.postUri<I>(uri,
          data: body, options: Options(headers: getHeader()));
      return ApiResponse.success(result.data! as I);
    } on DioException catch (e) {
      printIfDebug("Error on POST request. Error: $e");
      return ApiResponse.failure("Dio Error: $e");
    } catch (e) {
      return ApiResponse.failure("Error: $e");
    }
  }

  Map<String, String> getHeader() {
    final baseHeader = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    };
    if (accessToken != null) {
      baseHeader.addAll({'Authorization': 'Bearer $accessToken'});
    }
    return baseHeader;
  }
}
