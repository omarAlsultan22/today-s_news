import 'package:todays_news/domain/use_cases/update_date_use_case.dart';
import 'package:todays_news/data/models/category_data.dart';
import '../../fakes/fake_articles_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_hive_repository.dart';
import '../../fixtures/articles.dart';


void main() {
  late FakeArticlesRepository fakeApi;
  late FakeHiveRepository fakeLocal;
  late UpdateDateUseCase useCase;

  final currentData = CategoryData(
    products: [articleA],
    currentIndex: 1,
    hasMore: true,
    page: 1,
  );

  setUp(() {
    fakeApi = FakeArticlesRepository();
    fakeLocal = FakeHiveRepository();
    useCase = UpdateDateUseCase(
      apiRepository: fakeApi,
      localRepository: fakeLocal,
    );
  });

  group('execute', () {
    test('returns currentData unchanged when api returns empty', () async {
      fakeApi.articlesToReturn = [];

      final result = await useCase.execute(
        page: 1,
        key: 'business',
        currentData: currentData,
      );

      expect(result, same(currentData));
      expect(fakeLocal.clearCallCount, 0);
      expect(fakeLocal.saveCallCount, 0);
    });

    test('returns currentData unchanged when publishedAt is the same',
            () async {
          fakeApi.articlesToReturn = [articleA];  // ← نفس publishedAt

          final result = await useCase.execute(
            page: 1,
            key: 'business',
            currentData: currentData,
          );

          expect(result, same(currentData));
          expect(fakeLocal.clearCallCount, 0);
          expect(fakeLocal.saveCallCount, 0);
        });

    test('passes correct params to apiRepository.fetchArticles', () async {
      fakeApi.articlesToReturn = [articleB];

      await useCase.execute(
        page: 3,
        key: 'science',
        currentData: currentData,
      );

      expect(fakeApi.lastKey, 'science');
      expect(fakeApi.lastCurrentPage, 3);
      expect(fakeApi.lastCurrentIndex, 1);
    });

    test('clears and saves local storage when data changed', () async {
      fakeApi.articlesToReturn = [articleB];  // ← تاريخ مختلف

      await useCase.execute(
        page: 1,
        key: 'business',
        currentData: currentData,
      );

      expect(fakeLocal.clearCallCount, 1);
      expect(fakeLocal.lastClearKey, 'business');
      expect(fakeLocal.saveCallCount, 1);
      expect(fakeLocal.lastSaveKey, 'business');
      expect(fakeLocal.lastSaveArticles, [articleB]);
    });

    test('returns updated CategoryData when data changed', () async {
      fakeApi.articlesToReturn = [articleB, articleA];

      final result = await useCase.execute(
        page: 2,
        key: 'business',
        currentData: currentData,
      );

      expect(result.products, [articleB, articleA]);
      expect(result.currentIndex, 2);
      expect(result.page, 3);
      expect(result.hasMore, true);
    });

    test('currentIndex uses articles.length (not accumulated)', () async {
      final currentWithIndex = currentData.copyWith(currentIndex: 10);
      fakeApi.articlesToReturn = [articleB, articleA];

      final result = await useCase.execute(
        page: 2,
        key: 'business',
        currentData: currentWithIndex,
      );

      expect(result.currentIndex, 2);
    });

    test('page uses the passed page + 1 (not currentData.page + 1)', () async {
      final currentWithPage = currentData.copyWith(page: 5);
      fakeApi.articlesToReturn = [articleB];

      final result = await useCase.execute(
        page: 2,
        key: 'business',
        currentData: currentWithPage,
      );

      expect(result.page, 3);
    });

    test('propagates errors from apiRepository', () async {
      fakeApi.fetchError = Exception('network failed');

      expect(
            () => useCase.execute(
          page: 1,
          key: 'business',
          currentData: currentData,
        ),
        throwsA(isA<Exception>()),
      );

      expect(fakeLocal.clearCallCount, 0);
      expect(fakeLocal.saveCallCount, 0);
    });
  });
}