import '../repositories/hive_repository.dart';
import '../../../data/models/category_data.dart';
import '../repositories/articles_repository.dart';
import 'package:todays_news/presentation/mixins/local_storage_operations.dart';


class UpdateDateUseCase with LocalStorageOperations {
  final HiveRepository _localRepository;
  final ArticlesRepository _apiRepository;

  UpdateDateUseCase({
    required HiveRepository localRepository,
    required ArticlesRepository apiRepository
  })
      :
        _apiRepository = apiRepository,
        _localRepository = localRepository;

  @override
  HiveRepository get localRepository => _localRepository;

  Future<CategoryData> execute({
    required int page,
    required String key,
    required CategoryData currentData,
  }) async {
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
}