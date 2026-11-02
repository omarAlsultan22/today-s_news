import '../../fixtures/articles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/data/models/category_data.dart';
import 'package:todays_news/domain/use_cases/pagination_state_manager.dart';


void main() {
  late PaginationHandler handler;

  final articleC = Article(
    title: 'Article C',
    description: 'Description C',
    url: 'https://example.com/c',
    urlToImage: 'https://example.com/c.jpg',
    publishedAt: '2024-05-03',
  );

  final articleD = Article(
    title: 'Article D',
    description: 'Description D',
    url: 'https://example.com/d',
    urlToImage: 'https://example.com/d.jpg',
    publishedAt: '2024-05-04',
  );

  setUp(() {
    handler = PaginationHandler();
  });

  group('updateWithNewData', () {
    test('appends new articles after current products (order preserved)', () {
      final current = CategoryData(
        products: [articleA, articleB],
        currentIndex: 2,
        hasMore: true,
        page: 1,
      );
      final newArticles = [articleC, articleD];

      final result = handler.updateWithNewData(current, newArticles);

      expect(result.products, [articleA, articleB, articleC, articleD]);
    });

    test('sets currentIndex to the total length of merged products', () {
      final current = CategoryData(
        products: [articleA, articleB],
        currentIndex: 2,
        hasMore: true,
        page: 1,
      );
      final newArticles = [articleC, articleD];

      final result = handler.updateWithNewData(current, newArticles);

      // 2 (قديمة) + 2 (جديدة) = 4
      expect(result.currentIndex, 4);
    });

    test('sets hasMore to true when newArticles is not empty', () {
      const current = CategoryData(
        products: [],
        currentIndex: 0,
        hasMore: false,
        page: 0,
      );

      final result = handler.updateWithNewData(current, [articleA]);

      expect(result.hasMore, true);
    });

    test('sets hasMore to false when newArticles is empty', () {
      final current = CategoryData(
        products: [articleA, articleB],
        currentIndex: 2,
        hasMore: true,
        page: 1,
      );

      final result = handler.updateWithNewData(current, []);

      expect(result.hasMore, false);
    });

    test('increments page when newArticles is not empty', () {
      final current = CategoryData(
        products: [articleA],
        currentIndex: 1,
        hasMore: true,
        page: 1,
      );

      final result = handler.updateWithNewData(current, [articleB]);

      expect(result.page, 2);  // 1 + 1
    });

    test('keeps page unchanged when newArticles is empty', () {
      final current = CategoryData(
        products: [articleA],
        currentIndex: 1,
        hasMore: true,
        page: 3,
      );

      final result = handler.updateWithNewData(current, []);

      expect(result.page, 3);  // يبقى 3
    });

    test('returns empty products when both lists are empty', () {
      const current = CategoryData(
        products: [],
        currentIndex: 0,
        hasMore: false,
        page: 0,
      );

      final result = handler.updateWithNewData(current, []);

      expect(result.products, isEmpty);
      expect(result.currentIndex, 0);
      expect(result.hasMore, false);
      expect(result.page, 0);
    });

    test('does not modify the original currentData', () {
      final current = CategoryData(
        products: [articleA],
        currentIndex: 1,
        hasMore: true,
        page: 1,
      );
      final originalProducts = List<Article>.from(current.products);

      handler.updateWithNewData(current, [articleB]);

      // current لم يتغير
      expect(current.products, originalProducts);
      expect(current.page, 1);
    });
  });
}