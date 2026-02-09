import '../../../data/models/tab_data.dart';
import '../../repositories/data_repository.dart';
import 'package:todays_news/domain/repositories/data_operations.dart';
import 'package:todays_news/features/home/constants/home_screen_constants.dart';


class LoadDataUseCase {
  final DataRepository repository;
  final DataOperations localDatabase;

  const LoadDataUseCase(this.repository, this.localDatabase);

  Future<CategoryData> execute({
    int? tabIndex,
    String? query,
    required CategoryData currentData,
  }) async {
    if (!currentData.hasMore) return currentData;

    final key = query ?? HomeScreenConstants.categories[tabIndex!];

    final articles = await repository.fetchArticles(
      key: key,
      currentPage: currentData.page,
    );

    return currentData.copyWith(
      products: [...currentData.products, ...articles],
      page: articles.isNotEmpty ? currentData.page + 1 : currentData.page,
      isLoading: false,
      hasMore: articles.isNotEmpty,
    );
  }
}
