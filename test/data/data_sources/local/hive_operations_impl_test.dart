import 'package:mocktail/mocktail.dart';
import '../../../fakes/fake_cache_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/data/data_sources/local/hive_operations_impl.dart';
import 'package:todays_news/errors/exceptions/cache_exceptions/hive_app_exceptions.dart';


class MockHiveInterface extends Mock implements HiveInterface {}
class MockBox extends Mock implements Box<Article> {}
class MockArticleAdapter extends Mock implements ArticleAdapter {}

void main() {
  late MockBox mockSportsBox;
  late MockBox mockScienceBox;
  late MockBox mockBusinessBox;
  late FakeCacheHelper fakeCache;
  late MockHiveInterface mockHive;
  late HiveOperationsImpl operations;

  final articleA = Article(
    title: 'Article A',
    description: 'Description A',
    url: 'https://example.com/a',
    urlToImage: 'https://example.com/a.jpg',
    publishedAt: '2024-05-01',
  );

  final articleB = Article(
    title: 'Article B',
    description: 'Description B',
    url: 'https://example.com/b',
    urlToImage: 'https://example.com/b.jpg',
    publishedAt: '2024-05-02',
  );

  setUpAll(() {
    // لـ mocktail: تسجيل fallback لقيم معقدة
    registerFallbackValue(MockArticleAdapter());
  });

  setUp(() async {
    mockHive = MockHiveInterface();
    mockBusinessBox = MockBox();
    mockScienceBox = MockBox();
    mockSportsBox = MockBox();
    fakeCache = FakeCacheHelper();

    // stub registerAdapter
    when(() => mockHive.registerAdapter<Article>(any()))
        .thenAnswer((_) async {});

    // stub openBox
    when(() => mockHive.openBox<Article>('businessBox'))
        .thenAnswer((_) async => mockBusinessBox);
    when(() => mockHive.openBox<Article>('scienceBox'))
        .thenAnswer((_) async => mockScienceBox);
    when(() => mockHive.openBox<Article>('sportsBox'))
        .thenAnswer((_) async => mockSportsBox);

    operations = HiveOperationsImpl(
      cacheHelper: fakeCache,
      hive: mockHive,
    );
  });

  group('init', () {
    test('registers adapter and opens all three boxes', () async {
      await operations.init();

      verify(() => mockHive.registerAdapter<Article>(any())).called(1);
      verify(() => mockHive.openBox<Article>('businessBox')).called(1);
      verify(() => mockHive.openBox<Article>('scienceBox')).called(1);
      verify(() => mockHive.openBox<Article>('sportsBox')).called(1);
    });

    test('throws HiveInitializeException when openBox fails', () async {
      when(() => mockHive.openBox<Article>('businessBox'))
          .thenThrow(Exception('disk full'));

      expect(() => operations.init(), throwsA(isA<HiveInitializeException>()));
    });

    test('throws HiveInitializeException when boxes accessed before init',
            () {
          // قبل init — أي getter يرمي
          expect(() => operations.businessBox,
              throwsA(isA<HiveInitializeException>()));
        });
  });

  group('putLocalData', () {
    setUp(() async {
      await operations.init(); // لضبط _boxes
    });

    test('puts articles into the correct box with sequential keys', () async {
      when(() => mockBusinessBox.put(any(), any())).thenAnswer((_) async {});

      await operations.putLocalData(
        key: 'business',
        itemsCount: 10,
        articles: [articleA, articleB],
      );

      verify(() => mockBusinessBox.put('item_10', articleA)).called(1);
      verify(() => mockBusinessBox.put('item_11', articleB)).called(1);
    });

    test('throws HiveSaveException when put fails', () async {
      when(() => mockBusinessBox.put(any(), any()))
          .thenThrow(Exception('write failed'));

      expect(
            () => operations.putLocalData(
          key: 'business',
          itemsCount: 0,
          articles: [articleA],
        ),
        throwsA(isA<HiveSaveException>()),
      );
    });
  });

  group('getLocalData', () {
    setUp(() async {
      await operations.init();
    });

    test('returns empty list when itemsCount is zero', () async {
      when(() => fakeCache.getInt(key: 'business-itemsCount'))
          .thenAnswer((_) async => 0);

      final result = await operations.getLocalData(
        key: 'business',
        currentIndex: 0,
      );

      expect(result, isEmpty);
    });

    test('returns articles in range [currentIndex, currentIndex+pageSize)',
            () async {
          // itemsCount = 25، pageSize = 10 → currentPage = 10، length = 10
          when(() => fakeCache.getInt(key: 'business-itemsCount'))
              .thenAnswer((_) async => 25);

          when(() => mockBusinessBox.get('item_0')).thenReturn(articleA);
          when(() => mockBusinessBox.get('item_1')).thenReturn(articleB);
          // الباقي null

          final result = await operations.getLocalData(
            key: 'business',
            currentIndex: 0,
          );

          expect(result.length, 2);
          expect(result[0], articleA);
          expect(result[1], articleB);
        });

    test('caps length at itemsCount when currentPage exceeds it', () async {
      // itemsCount = 3، currentPage = 10 → length = 3
      when(() => fakeCache.getInt(key: 'business-itemsCount'))
          .thenAnswer((_) async => 3);

      when(() => mockBusinessBox.get('item_0')).thenReturn(articleA);
      when(() => mockBusinessBox.get('item_1')).thenReturn(articleB);
      when(() => mockBusinessBox.get('item_2')).thenReturn(articleA);

      final result = await operations.getLocalData(
        key: 'business',
        currentIndex: 0,
      );

      expect(result.length, 3);
    });

    test('skips null articles', () async {
      when(() => fakeCache.getInt(key: 'business-itemsCount'))
          .thenAnswer((_) async => 5);

      when(() => mockBusinessBox.get('item_0')).thenReturn(null);
      when(() => mockBusinessBox.get('item_1')).thenReturn(articleA);
      when(() => mockBusinessBox.get('item_2')).thenReturn(null);
      when(() => mockBusinessBox.get('item_3')).thenReturn(articleB);
      when(() => mockBusinessBox.get('item_4')).thenReturn(null);

      final result = await operations.getLocalData(
        key: 'business',
        currentIndex: 0,
      );

      expect(result.length, 2);
      expect(result, [articleA, articleB]);
    });

    test('throws HiveReadException when box.get fails', () async {
      when(() => fakeCache.getInt(key: 'business-itemsCount'))
          .thenAnswer((_) async => 5);
      when(() => mockBusinessBox.get(any()))
          .thenThrow(Exception('read failed'));

      expect(
            () => operations.getLocalData(key: 'business', currentIndex: 0),
        throwsA(isA<HiveReadException>()),
      );
    });
  });

  group('clearData', () {
    setUp(() async {
      await operations.init();
    });

    test('clears the correct box', () async {
      when(() => mockBusinessBox.clear()).thenAnswer((_) async => 0);

      await operations.clearData('business');

      verify(() => mockBusinessBox.clear()).called(1);
      verifyNever(() => mockScienceBox.clear());
    });

    test('throws HiveClearException when clear fails', () async {
      when(() => mockBusinessBox.clear())
          .thenThrow(Exception('clear failed'));

      expect(
            () => operations.clearData('business'),
        throwsA(isA<HiveClearException>()),
      );
    });
  });
}