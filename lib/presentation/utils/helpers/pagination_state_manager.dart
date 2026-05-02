import '../../../data/models/article_Model.dart';
import '../../../data/models/category_data.dart';


class PaginationHandler {
  CategoryData updateWithNewData(CategoryData currentData,
      List<Article> newArticles) {
    return currentData.copyWith(
      products: [...currentData.products, ...newArticles],
      page: newArticles.isNotEmpty ? currentData.page + 1 : currentData.page,
      hasMore: newArticles.isNotEmpty,
    );
  }
}