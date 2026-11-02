import '../../fixtures/articles.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_pagination_handler.dart';
import '../../fakes/fake_articles_repository.dart';
import 'package:todays_news/constants/app_strings.dart';
import 'package:todays_news/data/models/category_data.dart';
import 'package:todays_news/presentation/states/base/app_sub_states.dart';
import 'package:todays_news/domain/use_cases/tab_use_cases/load_tab_data_use_case.dart';


void main() {
  late LoadDataUseCase useCase;
  late FakeArticlesRepository fakeRepo;
  late FakePaginationHandler fakePagination;

  const currentData = CategoryData(
    page: 2,
    products: [],
    hasMore: true,
    currentIndex: 10,
    subState: InitialState()
  );

  setUp(() {
    fakeRepo = FakeArticlesRepository();
    fakePagination = FakePaginationHandler();
    useCase = LoadDataUseCase(
      repository: fakeRepo,
      paginationHandler: fakePagination,
    );
  });

  group('execute', () {
    test('uses query as key when query is provided', () async {
      await useCase.execute(
        query: 'flutter',
        category: 'tech',
        currentData: currentData,
      );

      expect(fakeRepo.lastKey, 'flutter'); // ← query يفوز
    });

    test('uses category as key when query is null', () async {
      await useCase.execute(
        query: null,
        category: 'tech',
        currentData: currentData,
      );

      expect(fakeRepo.lastKey, 'tech'); // ← category
    });

    test('uses empty string when both query and category are null', () async {
      await useCase.execute(
        query: null,
        category: null,
        currentData: currentData,
      );

      expect(fakeRepo.lastKey, AppStrings.empty); // ← ''
    });

    test('passes currentPage and currentIndex from currentData', () async {
      await useCase.execute(
        query: 'x',
        currentData: currentData,
      );

      expect(fakeRepo.lastCurrentPage, 2);
      expect(fakeRepo.lastCurrentIndex, 10);
    });

    test('passes currentData and newArticles to paginationHandler', () async {
      fakeRepo.articlesToReturn = [articleA, articleB];

      await useCase.execute(
        query: 'x',
        currentData: currentData,
      );

      expect(fakePagination.updateCallCount, 1);
      expect(fakePagination.lastCurrentData, same(currentData));
      expect(fakePagination.lastNewArticles, [articleA, articleB]);
    });

    test('returns the result from paginationHandler', () async {
      const expected = CategoryData(page: 3, currentIndex: 20);
      fakePagination.resultToReturn = expected;

      final result = await useCase.execute(
        query: 'x',
        currentData: currentData,
      );

      expect(result, same(expected));
    });

    test('propagates repository errors', () async {
      fakeRepo.fetchError = Exception('network failed');

      expect(
            () => useCase.execute(query: 'x', currentData: currentData),
        throwsA(isA<Exception>()),
      );

      // paginationHandler لم يُستدعَ
      expect(fakePagination.updateCallCount, 0);
    });
  });
}