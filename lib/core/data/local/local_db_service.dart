import 'dart:convert';
import 'package:flutter_project_core/core/utils/helper_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDbService {
  Future<void> cacheData(String key, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
    printIfDebug("Data cached locally under key '$key': $data");
  }

  Future<Map<String, dynamic>?> getCachedData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dataString = prefs.getString(key);
    if (dataString != null) {
      Map<String, dynamic> data = jsonDecode(dataString);
      printIfDebug("Retrieved cached data for key '$key': $data");
      return data;
    }
    printIfDebug("No cached data found for key '$key'");
    return null;
  }

  Future<void> clearCachedData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    printIfDebug("Cleared cached data for key '$key'");
  }
}
