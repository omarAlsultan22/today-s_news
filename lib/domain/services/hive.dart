import '../../data/models/article_Model.dart';


abstract class HiveOperations {

  Future<void> init();

  Future<void> putLocalData({
    required String key,
    required int itemsCount,
    required List<Article> articles
  });

  Future<List<Article>> getLocalData({
    required String key,
    required int currentIndex
  });

  Future<void> clearData(String key);
}

