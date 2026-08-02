import 'api_articles_repository.dart';
import '../../domain/repositories/data_repository.dart';
import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/presentation/mixins/local_storage_operations.dart';
import 'package:todays_news/data/repositories_impl/hive_articles_repository.dart';
import 'package:todays_news/presentation/providers/connectivity_provider.dart';


class HybridArticlesRepository with LocalStorageOperations implements DataRepository {
  final ApiArticlesRepository _apiRepository;
  final HiveArticlesRepository _localRepository;
  final ConnectivityProvider _connectivityProvider;

  HybridArticlesRepository({
    required ApiArticlesRepository apiRepository,
    required HiveArticlesRepository localRepository,
    required ConnectivityProvider connectivityProvider,
  })
      :
        _apiRepository = apiRepository,
        _localRepository = localRepository,
        _connectivityProvider = connectivityProvider;


  @override
  HiveArticlesRepository get localRepository => _localRepository;

  late final Map<bool, DataRepository> _map = {
    true: _apiRepository,
    false: _localRepository,
  };

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
    required int currentIndex
  }) async {
    try {
      final isConnected = _connectivityProvider.isConnected;
      final dataRepository = _map[isConnected];
      final articles = await dataRepository!.fetchArticles(
          key: key,
          currentPage: currentPage,
          currentIndex: currentIndex
      );
      if (articles.isEmpty) {
        return [];
      }

      if (!isConnected) return articles;

      if (currentPage == 1) {
        clearLocalStorage(key);
      }
      saveLocalStorage(key, articles);

      return articles;
    }
    catch (e) {
      rethrow;
    }
  }
}