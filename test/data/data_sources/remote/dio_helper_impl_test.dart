import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todays_news/data/data_sources/remote/dio_helper_impl.dart';
import 'package:todays_news/domain/data_sources/dio_helper.dart';


class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late DioHelper dioHelper;

  setUp(() {
    mockDio = MockDio();
    dioHelper = DioHelperImpl(dio: mockDio);
  });

  group('init', () {
    test('sets baseUrl and receiveDataWhenStatusError on Dio options', () async {
      // Dio.options getter/setter — نحتاج stub للـ setter
      final baseOptions = BaseOptions();
      when(() => mockDio.options).thenReturn(baseOptions);

      await dioHelper.init();

      // نتحقق من أن options تم تعديلها
      expect(baseOptions.baseUrl, 'https://newsapi.org/');
      expect(baseOptions.receiveDataWhenStatusError, true);
    });
  });

  group('getData', () {
    test('calls dio.get with the correct url and query', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/top-headlines'),
        statusCode: 200,
        data: {'articles': []},
      );

      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
      )).thenAnswer((_) async => response);

      final result = await dioHelper.getData(
        url: '/top-headlines',
        query: {'country': 'us', 'category': 'business'},
      );

      expect(result.statusCode, 200);
      expect(result.data, {'articles': []});

      verify(() => mockDio.get(
        '/top-headlines',
        queryParameters: {'country': 'us', 'category': 'business'},
      )).called(1);
    });

    test('propagates DioException when request fails', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/top-headlines'),
        response: Response(
          requestOptions: RequestOptions(path: '/top-headlines'),
          statusCode: 500,
        ),
      );

      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
      )).thenThrow(exception);

      expect(
            () => dioHelper.getData(
          url: '/top-headlines',
          query: {'country': 'us'},
        ),
        throwsA(isA<DioException>()),
      );
    });

    test('propagates DioException of type connectionTimeout', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.connectionTimeout,
      );

      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
      )).thenThrow(exception);

      expect(
            () => dioHelper.getData(url: '/x', query: {}),
        throwsA(
          isA<DioException>()
              .having((e) => e.type, 'type', DioExceptionType.connectionTimeout),
        ),
      );
    });
  });
}