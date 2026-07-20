import '../../../data/models/category_data.dart';
import '../../repositories/data_repository.dart';
import 'package:todays_news/constants/app_strings.dart';
import 'package:todays_news/presentation/utils/helpers/pagination_state_manager.dart';


class LoadDataUseCase {
  final DataRepository _repository;
  final PaginationHandler _paginationHandler;

  const LoadDataUseCase({
    required DataRepository repository,
    required PaginationHandler paginationHandler
  })
      : _repository = repository,
        _paginationHandler = paginationHandler;

  Future<CategoryData> execute({
    String? query,
    String? category,
    int? currentPage,
    required CategoryData currentData,
  }) async {
    try {
      final key = query ?? category ?? AppStrings.empty;

      final newArticles = await _repository.fetchArticles(
          key: key,
          currentPage: currentPage ?? currentData.page,
          currentIndex: currentData.currentIndex
      );

      if (!currentData.productsIsEmpty) {
        if (currentData.publishedAt != newArticles.first.publishedAt) {
          return currentData.copyWith(
            products: newArticles,
            currentIndex: newArticles.length,
            hasMore: newArticles.isNotEmpty,
            page: newArticles.isNotEmpty ? currentPage! + 1 : currentPage,
          );
        }
      }

      return _paginationHandler.updateWithNewData(currentData, newArticles);
    }
    catch (e) {
      rethrow;
    }
  }
}
