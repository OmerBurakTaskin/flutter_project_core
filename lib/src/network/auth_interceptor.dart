import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_project_core/src/config/api_config.dart';
import 'package:flutter_project_core/src/utils/helper_methods.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final Dio _tokenDio;

  AuthInterceptor(this.dio)
      : _tokenDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;

    if (response?.statusCode == 401) {
      final refreshToken = ApiConfig.I.refreshToken;

      if (refreshToken != null) {
        try {
          final newTokens = await _refreshAccessToken(refreshToken);

          if (newTokens != null) {
            ApiConfig.I.accesToken = newTokens["accessToken"];
            final refreshToken = newTokens["refreshToken"];
            if (refreshToken != null) {
              unawaited(ApiConfig.saveRefreshToken(refreshToken));
            }

            final requestOptions = err.requestOptions;
            requestOptions.headers['Authorization'] =
                'Bearer ${newTokens['accessToken']}';

            try {
              final response = await dio.fetch(requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {
              handler.next(err);
              return;
            }
          }
        } catch (refreshError) {
          await _handleRefreshTokenFailure();
        }
      }
    }

    handler.next(err);
  }

  Future<Map<String, String>?> _refreshAccessToken(String refreshToken) async {
    try {
      final response = await _tokenDio.post(
        '/auth/get-access-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return {
          'accessToken': data['accessToken'],
          'refreshToken': data['refreshToken'],
        };
      }
    } catch (e) {
      printIfDebug('Refresh token error: $e');
    }
    return null;
  }

  Future<void> _handleRefreshTokenFailure() async {
    await ApiConfig.clearRefreshToken();
    // TODO: add logic of navigation here
  }
}
