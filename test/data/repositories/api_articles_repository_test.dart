import 'package:dio/dio.dart';
import '../../fakes/fake_dio_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todays_news/data/config/news_config.dart';
import 'package:todays_news/data/constants/config_keys.dart';
import 'package:todays_news/domain/repositories/articles_repository.dart';
import 'package:todays_news/data/repositories_impl/api_articles_repository.dart';


void main() {
  late FakeDioHelper fakeDio;
  late ArticlesRepository repository;

  setUp(() {
    fakeDio = FakeDioHelper();
    repository = ApiArticlesRepository(dioHelper: fakeDio);
  });

  group('fetchArticles', () {
    test('calls dioHelper with the correct url and query', () async {
      fakeDio.responseToReturn = Response(
        requestOptions: RequestOptions(path: 'v2/top-headlines'),
        statusCode: 200,
        data: {'articles': []},
      );

      await repository.fetchArticles(
        key: 'business',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(fakeDio.lastUrl, 'v2/top-headlines');
      expect(fakeDio.lastQuery, {
        'category': 'business',
        'country': 'us',
        ConfigKeys.page: 1,
        ConfigKeys.sortBy: NewsConfig.sortBy,
        ConfigKeys.apiKey: NewsConfig.apiKey,
        ConfigKeys.pageSize: NewsConfig.pageSize,
      });
    });

    test('passes response.data["articles"] to the parser', () async {
      final articlesJson = [
        {
          'title': 'A',
          'description': 'D',
          'url': 'https://a',
          'urlToImage': 'https://a.jpg',
          'publishedAt': '2024-05-01',
        },
      ];
      fakeDio.responseToReturn = Response(
        requestOptions: RequestOptions(path: 'v2/top-headlines'),
        statusCode: 200,
        data: {'articles': articlesJson},
      );

      final result = await repository.fetchArticles(
        key: 'business',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(result.length, 1);
      expect(result.first.title, 'A');
    });

    test('returns empty list when articles is empty', () async {
      fakeDio.responseToReturn = Response(
        requestOptions: RequestOptions(path: 'v2/top-headlines'),
        statusCode: 200,
        data: {'articles': []},
      );

      final result = await repository.fetchArticles(
        key: 'business',
        currentPage: 1,
        currentIndex: 0,
      );

      expect(result, isEmpty);
    });

    test('propagates errors from dioHelper', () async {
      fakeDio.errorToThrow = DioException(
        requestOptions: RequestOptions(path: 'v2/top-headlines'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
            () =>
            repository.fetchArticles(
              key: 'business',
              currentPage: 1,
              currentIndex: 0,
            ),
        throwsA(isA<DioException>()),
      );
    });
  });
}