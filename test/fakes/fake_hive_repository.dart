import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/domain/repositories/hive_repository.dart';


class FakeHiveRepository implements HiveRepository {
  List<Article> fetchResult = [];
  Object? fetchError;
  int fetchCallCount = 0;

  int saveCallCount = 0;
  String? lastSaveKey;
  List<Article>? lastSaveArticles;

  int clearCallCount = 0;
  String? lastClearKey;

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
    required int currentIndex,
  }) async {
    fetchCallCount++;
    if (fetchError != null) throw fetchError!;
    return fetchResult;
  }

  @override
  Future<void> saveArticles({
    required String key,
    required List<Article> articles,
  }) async {
    saveCallCount++;
    lastSaveKey = key;
    lastSaveArticles = articles;
  }

  @override
  Future<void> clearArticles(String key) async {
    clearCallCount++;
    lastClearKey = key;
  }
}