import 'article_Model.dart';
import 'package:todays_news/presentation/states/base/app_states.dart';


class CategoryData {
  final List<Article> products;
  final MainAppState? state;
  final bool hasMore;
  final int page;

  CategoryData({
    this.products = const [],
    this.hasMore = true,
    this.state,
    this.page = 1,
  });

  bool get productsIsEmpty => products.isEmpty;

  CategoryData copyWith({
    List<Article>? products,
    MainAppState? state,
    bool? hasMore,
    int? page
  }) {
    return CategoryData(
        products: products ?? this.products,
        hasMore: hasMore ?? this.hasMore,
        state: state ?? this.state,
        page: page ?? this.page
    );
  }
}