import '../../domain/repositories/data_repository.dart';
import 'package:todays_news/data/models/article_Model.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';


class HybridArticlesRepository implements DataRepository {
  final DataRepository _remoteDatabase;
  final DataRepository _localDatabase;
  final ConnectivityService _connectivityService;

  HybridArticlesRepository({
    required DataRepository remoteDatabase,
    required DataRepository localDatabase,
    required ConnectivityService connectivityService
  })
      :
        _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _connectivityService = connectivityService;

  @override
  Future<List<Article>> fetchArticles(
      {required String key, required int currentPage}) async {
    final isConnection = await _connectivityService.checkInternetConnection();
    if (isConnection) {
      return _remoteDatabase.fetchArticles(
          key: key, currentPage: currentPage);
    }
    return _localDatabase.fetchArticles(
        key: key, currentPage: currentPage);
  }
}