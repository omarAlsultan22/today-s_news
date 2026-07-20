import '../../../data/models/article_Model.dart';
import '../../../data/models/category_data.dart';


class PaginationHandler {
  CategoryData updateWithNewData(CategoryData currentData,
      List<Article> newArticles) {
    final products = [...currentData.products, ...newArticles];
    return currentData.copyWith(
      products: products,
      currentIndex: products.length,
      hasMore: newArticles.isNotEmpty,
      page: newArticles.isNotEmpty ? currentData.page + 1 : currentData.page,
    );
  }
}