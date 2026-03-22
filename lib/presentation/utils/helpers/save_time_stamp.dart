import '../../../data/datasources/local/cacheHelper.dart';


abstract class SaveTimeStamp {
  static Future<void> saveTime(String key) async {
    final now = DateTime.now();
    await CacheHelper.setString(key: key, value: now.toIso8601String());
  }
}