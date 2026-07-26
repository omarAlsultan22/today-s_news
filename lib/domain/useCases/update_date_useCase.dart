import '../repositories/data_repository.dart';
import '../../../data/models/category_data.dart';


class UpdateDateUseCase {
  final DataRepository _repository;

  const UpdateDateUseCase({required DataRepository repository})
      : _repository = repository;

  Future<CategoryData> execute({
    required int page,
    required String category,
    required CategoryData currentData,
  }) async {
    try {
      final newArticles = await _repository.fetchArticles(
          key: category,
          currentPage: 1,
          currentIndex: currentData.currentIndex
      );

      if (newArticles.isEmpty) {
        return currentData;
      }

      final firstArticle = newArticles.first;

      if (currentData.publishedAt == firstArticle.publishedAt) {
        return currentData;
      }

      return currentData.copyWith(
        products: newArticles,
        currentIndex: newArticles.length,
        hasMore: true,
        page: page + 1,
      );
    }
    catch (e) {
      rethrow;
    }
  }
}