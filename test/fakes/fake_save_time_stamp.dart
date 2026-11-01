import 'package:todays_news/utils/save_time_stamp.dart';


class FakeSaveTimeStamp implements SaveTimeStamp {
  int saveTimeCallCount = 0;

  @override
  Future<void> saveTime() async {
    saveTimeCallCount++;
  }
}