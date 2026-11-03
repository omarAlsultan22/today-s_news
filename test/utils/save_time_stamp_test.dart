import '../fakes/fake_cache_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todays_news/utils/save_time_stamp.dart';
import 'package:todays_news/presentation/constants/storage_keys.dart';


void main() {
  late FakeCacheHelper fakeCache;
  late SaveTimeStamp saveTimeStamp;

  setUp(() {
    fakeCache = FakeCacheHelper();
    saveTimeStamp = SaveTimeStamp(cacheHelper: fakeCache);
  });

  group('saveTime', () {
    test('saves current time to cache under StorageKeys.savedTime', () async {
      await saveTimeStamp.saveTime();

      final saved = await fakeCache.getString(key: StorageKeys.savedTime);

      expect(saved, isNotEmpty);
    });

    test('saves a valid ISO8601 string', () async {
      await saveTimeStamp.saveTime();

      final saved = await fakeCache.getString(key: StorageKeys.savedTime);

      // يجب أن يكون قابلاً للتحليل
      final parsed = DateTime.parse(saved);
      expect(parsed, isA<DateTime>());
    });

    test('saved time is close to DateTime.now()', () async {
      final before = DateTime.now();
      await saveTimeStamp.saveTime();
      final after = DateTime.now();

      final saved = await fakeCache.getString(key: StorageKeys.savedTime);
      final parsed = DateTime.parse(saved);

      // الوقت المحفوظ بين before و after (بفارق ثانية)
      expect(parsed.isAfter(before.subtract(const Duration(seconds: 1))), true);
      expect(parsed.isBefore(after.add(const Duration(seconds: 1))), true);
    });

    test('uses the correct cache key', () async {
      await saveTimeStamp.saveTime();

      // المفتاح الآخر فارغ
      final other = await fakeCache.getString(key: 'other_key');
      expect(other, isEmpty);

      // المفتاح الصحيح غير فارغ
      final correct = await fakeCache.getString(key: StorageKeys.savedTime);
      expect(correct, isNotEmpty);
    });
  });
}