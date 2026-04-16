import 'article_Model.dart';


class CategoryData {
  final List<Article> products;
  final bool hasMore;
  final int page;

  CategoryData({
    this.products = const [],
    this.hasMore = true,
    this.page = 1,
  });

  bool get productsIsEmpty => products.isEmpty;

  CategoryData copyWith({
    List<Article>? products,
    bool? hasMore,
    int? page
  }) {
    return CategoryData(
        products: products ?? this.products,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page
    );
  }
}