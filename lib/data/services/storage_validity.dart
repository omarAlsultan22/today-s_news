import '../../domain/data_sources/cache_helper.dart';
import '../../presentation/constants/storage_keys.dart';


class StorageValidity {
  final CacheHelper _cacheHelper;
  final DateTime Function() _now;

  StorageValidity({
    required CacheHelper cacheHelper,
    DateTime Function()? now,
  })  : _cacheHelper = cacheHelper,
        _now = now ?? DateTime.now;

  static const _dayHours = 24;

  Future<bool> has24HoursPassed() async {
    final savedTimeString = await _cacheHelper.getString(
        key: StorageKeys.savedTime) ?? '';

    if (savedTimeString.isEmpty) {
      return true;
    }

    DateTime savedTime = DateTime.parse(savedTimeString);
    DateTime currentTime = _now();

    Duration difference = currentTime.difference(savedTime);

    return difference.inHours >= _dayHours;
  }
}