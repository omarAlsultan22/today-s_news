import 'article_Model.dart';


class CategoryData {
  final List<Article> products;
  final int currentIndex;
  final bool hasMore;
  final int page;

  const CategoryData({
    this.products = const [],
    this.currentIndex = 0,
    this.hasMore = true,
    this.page = 1
  });

  bool get productsIsEmpty => products.isEmpty;

  String get publishedAt => products.first.publishedAt;

  CategoryData copyWith({
    List<Article>? products,
    int? currentIndex,
    bool? hasMore,
    int? page
  }) {
    return CategoryData(
        currentIndex: currentIndex ?? this.currentIndex,
        products: products ?? this.products,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page
    );
  }
}