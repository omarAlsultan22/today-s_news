import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {

  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setDate({
    required String key,
    required String value
  }) async {
    return await sharedPreferences.setString(key , value);
  }

  static Future<String?> getDate({
    required String key,
  }) async {
    return sharedPreferences.getString(key);
  }
}