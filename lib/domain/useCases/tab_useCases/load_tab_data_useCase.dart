import '../../../data/models/category_data.dart';
import '../../repositories/data_repository.dart';
import 'package:todays_news/constants/app_texts.dart';
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
    required CategoryData currentData,
  }) async {
    try {
      final key = query ?? category ?? AppTexts.empty;

      final newArticles = await _repository.fetchArticles(
        key: key,
        currentPage: currentData.page,
      );

      return _paginationHandler.updateWithNewData(currentData, newArticles);
    }
    catch (e) {
      rethrow;
    }
  }
}
