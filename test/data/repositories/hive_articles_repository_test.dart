import '../../fixtures/articles.dart';
import '../../fakes/fake_cache_helper.dart';
import '../../fakes/fake_hive_operations.dart';
import '../../fakes/fake_save_time_stamp.dart';
import '../../fakes/fake_storage_validity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/domain/repositories/hive_repository.dart';
import 'package:todays_news/data/repositories_impl/hive_articles_repository.dart';


void main() {
  late FakeCacheHelper fakeCache;
  late HiveRepository repository;
  late FakeHiveOperations fakeHive;
  late FakeSaveTimeStamp fakeTimeStamp;
  late FakeStorageValidity fakeValidity;

  setUp(() {
    fakeCache = FakeCacheHelper();
    fakeHive = FakeHiveOperations();
    fakeTimeStamp = FakeSaveTimeStamp();
    fakeValidity = FakeStorageValidity();
    repository = HiveArticlesRepository(
      cacheHelper: fakeCache,
      hiveOperations: fakeHive,
      saveTimeStamp: fakeTimeStamp,
      storageValidity: fakeValidity,
    );
  });

  group('fetchArticles', () {
    test('clears storage and returns [] when 24h have passed', () async {
      fakeValidity.hasPassed = true;

      final result = await repository.fetchArticles(
        key: 'business',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(result, isEmpty);
      expect(fakeHive.clearCallCount, 1);
      expect(fakeHive.lastClearKey, 'business');
      // لم يُستدعَ getLocalData
      // (لا يوجد عداد، لكن يمكن إضافة واحد في FakeHive)
    });

    test('returns local data when not expired and data exists', () async {
      fakeValidity.hasPassed = false;
      fakeHive.articlesToReturn = [articleA, articleB];

      final result = await repository.fetchArticles(
        key: 'business',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(result, [articleA, articleB]);
      expect(fakeHive.clearCallCount, 0);
    });

    test('returns [] when not expired and local data is empty', () async {
      fakeValidity.hasPassed = false;
      fakeHive.articlesToReturn = [];

      final result = await repository.fetchArticles(
        key: 'business',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(result, isEmpty);
    });

    test('propagates errors from hive operations', () async {
      fakeValidity.hasPassed = false;
      fakeHive.getError = Exception('hive read failed');

      expect(
            () => repository.fetchArticles(
          key: 'business',
          currentPage: 1,
          currentIndex: 0,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('saveArticles', () {
    test('saves timestamp, updates count, and puts articles', () async {
      await fakeCache.setInt(key: 'business-itemsCount', value: 5);
      final newArticles = [articleA, articleB];

      await repository.saveArticles(
        key: 'business',
        articles: newArticles,
      );

      // 1. تم حفظ timestamp
      expect(fakeTimeStamp.saveTimeCallCount, 1);

      // 2. العداد الجديد = 5 + 2 = 7
      expect(await fakeCache.getInt(key: 'business-itemsCount'), 7);

      // 3. putLocalData استُدعيت بالعداد القديم (5) وليس الجديد
      expect(fakeHive.lastPutKey, 'business');
      expect(fakeHive.lastPutArticles, newArticles);
      expect(fakeHive.lastPutItemsCount, 5);  // ← القديم!
    });

    test('starts from zero when no count is stored', () async {
      // لا setInt — العداد غير موجود
      final newArticles = [articleA];

      await repository.saveArticles(
        key: 'business',
        articles: newArticles,
      );

      expect(await fakeCache.getInt(key: 'business-itemsCount'), 1);
      expect(fakeHive.lastPutItemsCount, 0);  // ← القديم = 0
    });

    test('propagates errors from putLocalData', () async {
      // نجعل putLocalData يرمي
      final failingHive = _FailingHiveOperations();
      final repo = HiveArticlesRepository(
        cacheHelper: fakeCache,
        hiveOperations: failingHive,
        saveTimeStamp: fakeTimeStamp,
        storageValidity: fakeValidity,
      );

      expect(
            () => repo.saveArticles(key: 'business', articles: [articleA]),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('clearArticles', () {
    test('delegates to hive operations with the correct key', () async {
      await repository.clearArticles('business');

      expect(fakeHive.clearCallCount, 1);
      expect(fakeHive.lastClearKey, 'business');
    });
  });
}

class _FailingHiveOperations extends FakeHiveOperations {
  @override
  Future<void> putLocalData({
    required String key,
    required int itemsCount,
    required List<Article> articles,
  }) async {
    throw Exception('put failed');
  }
}