import '../../data/models/article_Model.dart';
import 'package:todays_news/data/repositories_impl/hive_articles_repository.dart';


mixin LocalStorageOperations {
  HiveArticlesRepository get localRepository;

  Future<void> clearLocalStorage(String key) async {
    await localRepository.clearArticles(key);
  }

  Future<void> saveLocalStorage(String key, List<Article> articles) async {
    await localRepository.saveArticles(key: key, articles: articles);
  }
}
