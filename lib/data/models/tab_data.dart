import 'article_Model.dart';
import 'package:todays_news/core/errors/exceptions/app_exception.dart';


class CategoryData {
  final List<Article> products;
  final AppException? error;
  final bool isLoading;
  final bool hasMore;
  final int page;

  const CategoryData({
    this.products = const [],
    this.isLoading = true,
    this.hasMore = true,
    this.error,
    this.page = 1,
  });

  CategoryData copyWith({
    List<Article>? products,
    AppException? error,
    bool? isLoading,
    bool? hasMore,
    int? page
  }) {
    return CategoryData(
        products: products ?? this.products,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page
    );
  }
}