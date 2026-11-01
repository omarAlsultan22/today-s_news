import '../../../domain/data_sources/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todays_news/errors/exceptions/cache_exceptions/shared_prefs_app_exceptions.dart';


class CacheHelperImpl implements CacheHelper{
  final SharedPreferences _prefs;

  CacheHelperImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<bool> setString({
    required String key,
    required String value
  }) async {
    try {
      return await _prefs.setString(key, value);
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
      return _prefs.getString(key);
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
      return await _prefs.setInt(key, value);
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
      return _prefs.getInt(key);
    }
    catch (e) {
      throw SharedPrefsReadException(error: e);
    }
  }
}