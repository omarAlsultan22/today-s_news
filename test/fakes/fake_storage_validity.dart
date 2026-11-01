import 'package:todays_news/data/services/storage_validity.dart';


class FakeStorageValidity implements StorageValidity {
  bool hasPassed = false;
  int callCount = 0;

  @override
  Future<bool> has24HoursPassed() async {
    callCount++;
    return hasPassed;
  }
}