import '../../../domain/data_sources/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todays_news/errors/exceptions/cache_exceptions/shared_prefs_app_exceptions.dart';


class CacheHelperImpl implements CacheHelper{

  static final CacheHelperImpl _instance = CacheHelperImpl._internal();

  factory CacheHelperImpl() => _instance;

  CacheHelperImpl._internal();

  static late SharedPreferences sharedPreferences;

  @override
  Future<void> init() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
    }
    catch (e) {
      throw SharedPrefsInitializeException(error: e);
    }
  }

  @override
  Future<bool> setString({
    required String key,
    required String value
  }) async {
    try {
      return await sharedPreferences.setString(key, value);
    }
    catch (e) {
      throw SharedPrefsSaveException(error: e);
    }
  }

  @override
  Future<String?> getString({
    required String key,
  }) async {
    try {
      return sharedPreferences.getString(key);
    }
    catch (e) {
      throw SharedPrefsReadException(error: e);
    }
  }

  @override
  Future<bool> setInt({
    required String key,
    required int value
  }) async {
    try {
      return await sharedPreferences.setInt(key, value);
    }
    catch (e) {
      throw SharedPrefsSaveException(error: e);
    }
  }

  @override
  Future<int?> getInt({
    required String key,
  }) async {
    try {
      return sharedPreferences.getInt(key);
    }
    catch (e) {
      throw SharedPrefsReadException(error: e);
    }
  }
}