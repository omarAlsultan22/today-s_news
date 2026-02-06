import '../../../data/models/tab_data.dart';
import '../../repositories/data_repository.dart';
import 'package:todays_news/features/home/constants/home_screen_constants.dart';


class LoadDataUseCase {
  final DataRepository repository;

  const LoadDataUseCase(this.repository);

  Future<CategoryData> execute({
    int? tabIndex,
    String? query,
    required CategoryData currentData,
  }) async {
    if (!currentData.hasMore) return currentData;

    final value = query ?? HomeScreenConstants.categories[tabIndex!];

    final articles = await repository.fetchArticles(
      key: value,
      currentPage: currentData.page,
    );

    return currentData.copyWith(
      products: [...currentData.products, ...articles],
      page: currentData.page + 1,
      isLoading: false,
      hasMore: articles.isNotEmpty,
    );
  }
}
