import '../domain/data_sources/cache_helper.dart';
import '../presentation/constants/storage_keys.dart';


class SaveTimeStamp {
  final CacheHelper _cacheHelper;

  SaveTimeStamp({required CacheHelper cacheHelper})
      : _cacheHelper = cacheHelper;

  Future<void> saveTime() async {
    final now = DateTime.now();
    await _cacheHelper.setString(
        key: StorageKeys.savedTime, value: now.toIso8601String());
  }
}