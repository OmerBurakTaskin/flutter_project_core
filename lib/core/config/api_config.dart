import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  ApiConfig._();
  static final _instance = ApiConfig._();
  static ApiConfig get I => _instance;
  static const _refreshTokenKey = 'refresh_token';

  String? accesToken;
  String? refreshToken;

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_refreshTokenKey);
    if (token != null && token.isNotEmpty) {
      _instance.refreshToken = token;
      return token;
    }
    return null;
  }

  static Future<void> clearRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenKey);
  }
}
