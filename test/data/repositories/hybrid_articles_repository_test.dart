import '../../fixtures/articles.dart';
import '../../fakes/fake_hive_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_articles_repository.dart';
import 'package:todays_news/providers/connectivity_provider.dart';
import 'package:todays_news/domain/repositories/articles_repository.dart';
import 'package:todays_news/data/repositories_impl/hybrid_articles_repository.dart';


void main() {
  late FakeHiveRepository fakeLocal;
  late ArticlesRepository repository;
  late FakeArticlesRepository fakeApi;
  late ConnectivityProvider fakeConnectivity;

  setUp(() {
    fakeApi = FakeArticlesRepository();
    fakeLocal = FakeHiveRepository();
    fakeConnectivity = ConnectivityProvider.forTesting();
    repository = HybridArticlesRepository(
      apiRepository: fakeApi,
      localRepository: fakeLocal,
      connectivityProvider: fakeConnectivity,
    );
  });

  tearDown(() {
    ConnectivityProvider.resetForTesting();
  });

  group('fetchArticles - offline', () {
    test('uses local repository when not connected', () async {
      fakeConnectivity.setConnectedForTesting(false);
      fakeLocal.fetchResult = [articleA, articleB];

      final result = await repository.fetchArticles(
        key: 'business',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(result, [articleA, articleB]);
      expect(fakeLocal.fetchCallCount, 1);
      expect(fakeApi.fetchCallCount, 0);
    });

    test('returns [] without saving when local is empty', () async {
      fakeConnectivity.setConnectedForTesting(false);
      fakeLocal.fetchResult = [];

      final result = await repository.fetchArticles(
        key: 'business',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(result, isEmpty);
      expect(fakeLocal.saveCallCount, 0);
    });
  });

  group('fetchArticles - online', () {
    test('uses api repository when connected', () async {
      fakeConnectivity.setConnectedForTesting(true);
      fakeApi.articlesToReturn = [articleA];

      final result = await repository.fetchArticles(
        key: 'business',
        currentPage: 2,
        currentIndex: 10,
      );

      expect(result, [articleA]);
      expect(fakeApi.fetchCallCount, 1);
      expect(fakeLocal.fetchCallCount, 0);
    });

    test('saves to local storage after successful api fetch', () async {
      fakeConnectivity.setConnectedForTesting(true);
      fakeApi.articlesToReturn = [articleA, articleB];

      await repository.fetchArticles(
        key: 'business',
        currentPage: 2,
        currentIndex: 10,
      );

      expect(fakeLocal.saveCallCount, 1);
      expect(fakeLocal.lastSaveKey, 'business');
      expect(fakeLocal.lastSaveArticles, [articleA, articleB]);
    });

    test('clears local storage before saving when currentPage == 1',
            () async {
          fakeConnectivity.setConnectedForTesting(true);
          fakeApi.articlesToReturn = [articleA];

          await repository.fetchArticles(
            key: 'business',
            currentPage: 1,
            currentIndex: 0,
          );

          expect(fakeLocal.clearCallCount, 1);
          expect(fakeLocal.lastClearKey, 'business');
          expect(fakeLocal.saveCallCount, 1);
        });

    test('does NOT clear local storage when currentPage > 1', () async {
      fakeConnectivity.setConnectedForTesting(true);
      fakeApi.articlesToReturn = [articleA];

      await repository.fetchArticles(
        key: 'business',
        currentPage: 2,
        currentIndex: 10,
      );

      expect(fakeLocal.clearCallCount, 0);
      expect(fakeLocal.saveCallCount, 1);
    });

    test('does not save when api returns empty', () async {
      fakeConnectivity.setConnectedForTesting(true);
      fakeApi.articlesToReturn = [];

      final result = await repository.fetchArticles(
        key: 'business',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(result, isEmpty);
      expect(fakeLocal.saveCallCount, 0);
      expect(fakeLocal.clearCallCount, 0);
    });

    test('propagates api errors', () async {
      fakeConnectivity.setConnectedForTesting(true);
      fakeApi.fetchError = Exception('network failed');

      expect(
            () => repository.fetchArticles(
          key: 'business',
          currentPage: 1,
          currentIndex: 0,
        ),
        throwsA(isA<Exception>()),
      );

      // لم يُحفظ شيء
      expect(fakeLocal.saveCallCount, 0);
    });
  });

  group('fetchArticles - local errors', () {
    test('propagates local repository errors when offline', () async {
      fakeConnectivity.setConnectedForTesting(false);
      fakeLocal.fetchError = Exception('hive failed');

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
}