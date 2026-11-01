import '../../fakes/fake_cache_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todays_news/data/services/storage_validity.dart';
import 'package:todays_news/presentation/constants/storage_keys.dart';


void main() {
  late FakeCacheHelper fakeCache;
  late DateTime fixedNow;

  StorageValidity buildService() => StorageValidity(
    cacheHelper: fakeCache,
    now: () => fixedNow,
  );

  setUp(() {
    fakeCache = FakeCacheHelper();
    fixedNow = DateTime(2024, 5, 15, 12, 0); // 15 May 2024, 12:00
  });

  group('has24HoursPassed', () {
    test('returns true when no saved time exists', () async {
      // لا نضع شيئاً في fakeCache
      final service = buildService();

      final result = await service.has24HoursPassed();

      expect(result, true);
    });

    test('returns true when saved time is empty string', () async {
      await fakeCache.setString(key: StorageKeys.savedTime, value: '');
      final service = buildService();

      final result = await service.has24HoursPassed();

      expect(result, true);
    });

    test('returns false when less than 24 hours have passed', () async {
      // حفظنا الوقت قبل 12 ساعة
      final saved = fixedNow.subtract(const Duration(hours: 12));
      await fakeCache.setString(
        key: StorageKeys.savedTime,
        value: saved.toIso8601String(),
      );
      final service = buildService();

      final result = await service.has24HoursPassed();

      expect(result, false);
    });

    test('returns false when less than 1 hour has passed', () async {
      final saved = fixedNow.subtract(const Duration(minutes: 30));
      await fakeCache.setString(
        key: StorageKeys.savedTime,
        value: saved.toIso8601String(),
      );
      final service = buildService();

      final result = await service.has24HoursPassed();

      expect(result, false);
    });

    test('returns true when exactly 24 hours have passed', () async {
      final saved = fixedNow.subtract(const Duration(hours: 24));
      await fakeCache.setString(
        key: StorageKeys.savedTime,
        value: saved.toIso8601String(),
      );
      final service = buildService();

      final result = await service.has24HoursPassed();

      // مهم: >= (وليس >)
      expect(result, true);
    });

    test('returns true when more than 24 hours have passed', () async {
      final saved = fixedNow.subtract(const Duration(hours: 25));
      await fakeCache.setString(
        key: StorageKeys.savedTime,
        value: saved.toIso8601String(),
      );
      final service = buildService();

      final result = await service.has24HoursPassed();

      expect(result, true);
    });

    test('returns true when saved time is 48 hours ago', () async {
      final saved = fixedNow.subtract(const Duration(hours: 48));
      await fakeCache.setString(
        key: StorageKeys.savedTime,
        value: saved.toIso8601String(),
      );
      final service = buildService();

      final result = await service.has24HoursPassed();

      expect(result, true);
    });

    test('reads from StorageKeys.savedTime key', () async {
      // نضع وقتاً في مفتاح مختلف — يجب ألا يُقرأ
      final saved = fixedNow.subtract(const Duration(hours: 1));
      await fakeCache.setString(key: 'other_key', value: saved.toIso8601String());
      final service = buildService();

      final result = await service.has24HoursPassed();

      // المفتاح الصحيح فارغ → true
      expect(result, true);
    });
  });
}