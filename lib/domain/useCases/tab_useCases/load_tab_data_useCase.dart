import '../../../data/models/tab_data.dart';
import '../../repositories/data_repository.dart';
import '../../../presentation/constants/home_screen_constants.dart';


class LoadDataUseCase {
  final DataRepository repository;

  const LoadDataUseCase(this.repository);

  Future<CategoryData> execute({
    int? tabIndex,
    String? query,
    required CategoryData currentData,
  }) async {
    try {
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
    catch(e){
      rethrow;
    }
  }
}
