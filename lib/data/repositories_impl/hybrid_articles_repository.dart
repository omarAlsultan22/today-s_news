import '../../providers/connectivity_provider.dart';
import '../../domain/repositories/hive_repository.dart';
import '../../domain/repositories/articles_repository.dart';
import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/presentation/mixins/local_storage_operations.dart';
import 'package:todays_news/data/repositories_impl/hive_articles_repository.dart';


class HybridArticlesRepository with LocalStorageOperations implements ArticlesRepository {
  final HiveRepository _localRepository;
  final ArticlesRepository _apiRepository;
  final ConnectivityProvider _connectivityProvider;

  HybridArticlesRepository({
    required ArticlesRepository apiRepository,
    required HiveArticlesRepository localRepository,
    required ConnectivityProvider connectivityProvider,
  })
      :
        _apiRepository = apiRepository,
        _localRepository = localRepository,
        _connectivityProvider = connectivityProvider;


  @override
  HiveRepository get localRepository => _localRepository;

  late final Map<bool, ArticlesRepository> _map = {
    true: _apiRepository,
    false: _localRepository,
  };

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
    required int currentIndex
  }) async {
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
}