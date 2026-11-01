import 'package:dio/dio.dart';
import '../../fakes/fake_dio_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todays_news/data/config/news_config.dart';
import 'package:todays_news/data/constants/config_keys.dart';
import 'package:todays_news/domain/repositories/articles_repository.dart';
import 'package:todays_news/data/repositories_impl/search_repository.dart';


void main() {
  late FakeDioHelper fakeDio;
  late ArticlesRepository repository;

  setUp(() {
    fakeDio = FakeDioHelper();
    repository = SearchRepository(dioHelper: fakeDio);
  });

  group('fetchArticles', () {
    test('calls dioHelper with url "v2/everything"', () async {
      fakeDio.responseToReturn = Response(
        requestOptions: RequestOptions(path: 'v2/everything'),
        statusCode: 200,
        data: {'articles': []},
      );

      await repository.fetchArticles(
        key: 'flutter',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(fakeDio.lastUrl, 'v2/everything');
    });

    test('builds query with "q" and "language" instead of "category"',
            () async {
          fakeDio.responseToReturn = Response(
            requestOptions: RequestOptions(path: 'v2/everything'),
            statusCode: 200,
            data: {'articles': []},
          );

          await repository.fetchArticles(
            key: 'flutter',
            currentPage: 3,
            currentIndex: 20,
          );

          expect(fakeDio.lastQuery, {
            'q': 'flutter',                          // ← 'q' وليس 'category'
            'language': 'en',                        // ← خاص بـ Search
            ConfigKeys.page: 3,
            ConfigKeys.sortBy: NewsConfig.sortBy,
            ConfigKeys.apiKey: NewsConfig.apiKey,
            ConfigKeys.pageSize: NewsConfig.pageSize,
          });

          // تأكيد إضافي: لا يوجد 'category' أو 'country'
          expect(fakeDio.lastQuery!.containsKey('category'), false);
          expect(fakeDio.lastQuery!.containsKey('country'), false);
        });

    test('parses articles from response.data["articles"]', () async {
      final articlesJson = [
        {
          'title': 'Search Result',
          'description': 'D',
          'url': 'https://example.com',
          'urlToImage': 'https://example.com/img.jpg',
          'publishedAt': '2024-05-01',
        },
      ];
      fakeDio.responseToReturn = Response(
        requestOptions: RequestOptions(path: 'v2/everything'),
        statusCode: 200,
        data: {'articles': articlesJson},
      );

      final result = await repository.fetchArticles(
        key: 'flutter',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(result.length, 1);
      expect(result.first.title, 'Search Result');
    });

    test('propagates DioException', () async {
      fakeDio.errorToThrow = DioException(
        requestOptions: RequestOptions(path: 'v2/everything'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
            () => repository.fetchArticles(
          key: 'flutter',
          currentPage: 1,
          currentIndex: 0,
        ),
        throwsA(isA<DioException>()),
      );
    });
  });
}