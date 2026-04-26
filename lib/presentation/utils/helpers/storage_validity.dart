import 'package:todays_news/presentation/constants/storage_keys.dart';
import 'package:todays_news/data/datasources/local/cacheHelper.dart';


class StorageValidity {
  final CacheHelper _cacheHelper;

  StorageValidity({
    required CacheHelper cacheHelper})
      : _cacheHelper = cacheHelper;

  Future<bool> has24HoursPassed() async {
    String? savedTimeString = await _cacheHelper.getString(
        key: StorageKeys.savedTime);

    if (savedTimeString == null) {
      return true;
    }

    DateTime savedTime = DateTime.parse(savedTimeString);
    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(savedTime);

    return difference.inHours >= 24;
  }
}