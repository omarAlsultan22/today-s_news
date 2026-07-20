import 'api_articles_repository.dart';
import '../data_sources/local/hive.dart';
import '../data_sources/local/cacheHelper.dart';
import '../data_sources/remote/dio_helper.dart';
import '../../domain/repositories/data_repository.dart';
import 'package:todays_news/data/models/article_Model.dart';
import '../../presentation/utils/helpers/save_time_stamp.dart';
import '../../presentation/utils/helpers/storage_validity.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'package:todays_news/data/repositories_impl/hive_articles_repository.dart';


class HybridArticlesRepository implements DataRepository {
  final ConnectivityService _connectivityService;

  HybridArticlesRepository({
    required ConnectivityService connectivityService
  })
      :
        _connectivityService = connectivityService;

  static final _dioHelper = DioHelper();
  static final _cacheHelper = CacheHelper();
  static final _hiveOperations = HiveOperations(cacheHelper: _cacheHelper);
  static final _saveTimeStamp = SaveTimeStamp(cacheHelper: _cacheHelper);
  static final _storageValidity = StorageValidity(cacheHelper: _cacheHelper);
  static final _localDatabase = HiveArticlesRepository(
      cacheHelper: _cacheHelper,
      saveTimeStamp: _saveTimeStamp,
      hiveOperations: _hiveOperations,
      storageValidity: _storageValidity
  );

  static final Map<bool, DataRepository> _map = {
    false: _localDatabase,
    true: ApiArticlesRepository(dioHelper: _dioHelper)
  };

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
    required int currentIndex
  }) async {
    try {
      final isConnection = await _connectivityService.checkInternetConnection();
      final dataRepository = _map[isConnection];
      final articles = await dataRepository!.fetchArticles(
          key: key,
          currentPage: currentPage,
          currentIndex: currentIndex
      );

      if (articles.isNotEmpty) {
        await _localDatabase.saveArticles(
            key: key,
            articles: articles,
            currentIndex: currentIndex
        );
      }
      return articles;
    }
    catch (e) {
      rethrow;
    }
  }
}