import '../../../data/models/category_data.dart';
import '../../repositories/articles_repository.dart';
import 'package:todays_news/constants/app_strings.dart';
import 'package:todays_news/presentation/utils/helpers/pagination_state_manager.dart';


class LoadDataUseCase {
  final ArticlesRepository _repository;
  final PaginationHandler _paginationHandler;

  const LoadDataUseCase({
    required ArticlesRepository repository,
    required PaginationHandler paginationHandler
  })
      : _repository = repository,
        _paginationHandler = paginationHandler;

  Future<CategoryData> execute({
    String? query,
    String? category,
    required CategoryData currentData,
  }) async {
    final key = query ?? category ?? AppStrings.empty;

    final newArticles = await _repository.fetchArticles(
        key: key,
        currentPage: currentData.page,
        currentIndex: currentData.currentIndex
    );

    return _paginationHandler.updateWithNewData(currentData, newArticles);
  }
}
