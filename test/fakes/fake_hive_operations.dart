import 'package:todays_news/domain/data_sources/hive.dart';
import 'package:todays_news/data/models/article_Model.dart';


class FakeHiveOperations implements HiveOperations {
  // ما يعيده getLocalData
  List<Article> articlesToReturn = [];
  Object? getError;

  // ما يسجله putLocalData
  String? lastPutKey;
  List<Article>? lastPutArticles;
  int? lastPutItemsCount;

  // ما يسجله clearData
  int clearCallCount = 0;
  String? lastClearKey;

  @override
  Future<void> init() async {}

  @override
  Future<List<Article>> getLocalData({
    required String key,
    required int currentIndex,
  }) async {
    if (getError != null) throw getError!;
    return articlesToReturn;
  }

  @override
  Future<void> putLocalData({
    required String key,
    required int itemsCount,
    required List<Article> articles,
  }) async {
    lastPutKey = key;
    lastPutArticles = articles;
    lastPutItemsCount = itemsCount;
  }

  @override
  Future<void> clearData(String key) async {
    clearCallCount++;
    lastClearKey = key;
  }
}