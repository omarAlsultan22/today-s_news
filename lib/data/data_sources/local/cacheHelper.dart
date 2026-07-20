import 'package:shared_preferences/shared_preferences.dart';


class CacheHelper {

  static late SharedPreferences sharedPreferences;

  static final CacheHelper _instance = CacheHelper._internal();

  factory CacheHelper() => _instance;

  CacheHelper._internal();

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> setString({
    required String key,
    required String value
  }) async {
    return await sharedPreferences.setString(key, value);
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
    return await sharedPreferences.setInt(key, value);
  }

  Future<int?> getInt({
    required String key,
  }) async {
    return sharedPreferences.getInt(key);
  }
}