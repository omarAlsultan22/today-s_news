import '../../data/models/article_Model.dart';
import '../../domain/repositories/hive_repository.dart';


mixin LocalStorageOperations {
  HiveRepository get localRepository;

  Future<void> clearLocalStorage(String key) async {
    await localRepository.clearArticles(key);
  }

  Future<void> saveLocalStorage(String key, List<Article> articles) async {
    await localRepository.saveArticles(key: key, articles: articles);
  }
}
