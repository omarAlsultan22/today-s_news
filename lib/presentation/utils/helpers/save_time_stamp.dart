import '../../constants/storage_keys.dart';
import '../../../data/data_sources/local/cache_helper_impl.dart';


class SaveTimeStamp {
  final CacheHelperImpl _cacheHelper;

  SaveTimeStamp({required CacheHelperImpl cacheHelper})
      : _cacheHelper = cacheHelper;

  Future<void> saveTime() async {
    final now = DateTime.now();
    await _cacheHelper.setString(
        key: StorageKeys.savedTime, value: now.toIso8601String());
  }
}