import 'package:todays_news/data/datasources/local/cacheHelper.dart';


class StorageValidity {
  static Future<bool> has24HoursPassed() async {

    String? savedTimeString = await CacheHelper.getString(key: 'saved_time');

    if (savedTimeString == null) {
      return true;
    }

    DateTime savedTime = DateTime.parse(savedTimeString);
    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(savedTime);

    return difference.inHours >= 24;
  }
}