import '../../../data/models/tab_data.dart';
import 'package:todays_news/domain/repository/data_repository.dart';
import 'package:todays_news/features/home/constants/home_screen_constants.dart';


class LoadDataUseCase {
  final DataRepository repository;

  const LoadDataUseCase(this.repository);

  Future<TabData> execute({
    int? tabIndex,
    required TabData currentData,
  }) async {
    try {
      if (!currentData.hasMore) return currentData;

      final category = HomeScreenConstants.categories[tabIndex!];

      final articles = await repository.fetchCategoryArticles(
        category: category,
        page: currentData.page,
      );

      return currentData.copyWith(
        products: [...currentData.products, ...articles],
        page: currentData.page + 1,
        isLoading: false,
        hasMore: articles.isNotEmpty,
      );
    } catch (e) {
      return currentData.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
