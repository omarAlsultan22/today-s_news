import '../../constants/storage_keys.dart';
import '../../../domain/data_sources/cache_helper.dart';


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