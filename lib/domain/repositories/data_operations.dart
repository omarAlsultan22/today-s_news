import 'package:todays_news/data/models/article_Model.dart';


abstract class DataOperations {
  Future<void> saveArticles({
    required String key,
    required int currentIndex,
    required List<Article> articles
  });

  Future<void> clearArticles(String key);
}