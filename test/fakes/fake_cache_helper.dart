import 'package:todays_news/domain/data_sources/cache_helper.dart';


class FakeCacheHelper implements CacheHelper {
  final Map<String, dynamic> _storage = {};

  // للتحكم في القيم المعادة في الاختبار
  final Map<String, dynamic> _stubbedInts = {};

  /// يتيح لك تحديد ما يعيده getInt لمفتاح معين.
  void stubInt({required String key, required int? value}) {
    _stubbedInts[key] = value;
  }

  @override
  Future<bool> setString({required String key, required String value}) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<String> getString({required String key}) async {
    return _storage[key] as String;
  }

  @override
  Future<bool> setInt({required String key, required int value}) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<int?> getInt({required String key}) async {
    // أولوية للـ stubbed، ثم القيمة المخزنة
    if (_stubbedInts.containsKey(key)) {
      return _stubbedInts[key] as int?;
    }
    return _storage[key] as int?;
  }
}