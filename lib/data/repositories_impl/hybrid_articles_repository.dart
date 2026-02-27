import '../../domain/repositories/data_repository.dart';
import 'package:todays_news/data/models/article_Model.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'package:todays_news/data/repositories_impl/hive_articles_repository.dart';


class HybridArticlesRepository implements DataRepository {
  final DataRepository _remoteDatabase;
  final HiveArticlesRepository _localDatabase;
  final ConnectivityService _connectivityService;

  HybridArticlesRepository({
    required DataRepository remoteDatabase,
    required HiveArticlesRepository localDatabase,
    required ConnectivityService connectivityService
  })
      :
        _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _connectivityService = connectivityService;

  @override
  Future<List<Article>> fetchArticles(
      {required String key, required int currentPage}) async {
    try {
      final isConnection = await _connectivityService.checkInternetConnection();
      if (isConnection) {
        final articles = await _remoteDatabase.fetchArticles(
            key: key, currentPage: currentPage);

        if (articles.isNotEmpty) {
          await _localDatabase.saveArticles(
              key: key, currentPage: currentPage, articles: articles);
        }

        return articles;
      }
      return await _localDatabase.fetchArticles(
          key: key, currentPage: currentPage);
    }
    catch(e){
      rethrow;
    }
  }
}