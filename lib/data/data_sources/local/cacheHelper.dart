import 'package:shared_preferences/shared_preferences.dart';


class CacheHelper {

  static late SharedPreferences sharedPreferences;

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> setString({
    required String key,
    required String value
  }) async {
    return await sharedPreferences.setString(key , value);
  }

  Future<String?> getString({
    required String key,
  }) async {
    return sharedPreferences.getString(key);
  }

  Future<bool> setInt({
    required String key,
    required int value
  }) async {
    return await sharedPreferences.setInt(key , value);
  }

  Future<int?> getInt({
    required String key,
  }) async {
    return sharedPreferences.getInt(key);
  }
}