import 'package:todays_news/data/models/article_Model.dart';


abstract class HiveOperations {
  Future<void> saveArticles({
    required String key,
    required List<Article> articles
  });

  Future<void> clearArticles(String key);
}