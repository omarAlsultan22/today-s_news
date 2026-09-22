import '../../../data/models/category_data.dart';
import '../../data/repositories_impl/api_articles_repository.dart';
import '../../data/repositories_impl/hive_articles_repository.dart';
import 'package:todays_news/presentation/mixins/local_storage_operations.dart';


class UpdateDateUseCase with LocalStorageOperations {
  final ApiArticlesRepository _apiRepository;
  final HiveArticlesRepository _localRepository;

  UpdateDateUseCase({
    required ApiArticlesRepository apiRepository,
    required HiveArticlesRepository localRepository
  })
      :
        _apiRepository = apiRepository,
        _localRepository = localRepository;

  @override
  HiveArticlesRepository get localRepository => _localRepository;

  Future<CategoryData> execute({
    required int page,
    required String key,
    required CategoryData currentData,
  }) async {
    try {
      final articles = await _apiRepository.fetchArticles(
          key: key,
          currentPage: page,
          currentIndex: currentData.currentIndex
      );

      if (articles.isEmpty) {
        return currentData;
      }

      final firstArticle = articles.first;

      if (currentData.publishedAt == firstArticle.publishedAt) {
        return currentData;
      }

      await clearLocalStorage(key);
      await saveLocalStorage(key, articles);

      return currentData.copyWith(
        currentIndex: articles.length,
        products: articles,
        page: page + 1,
        hasMore: true,
      );
    }
    catch (e) {
      rethrow;
    }
  }
}