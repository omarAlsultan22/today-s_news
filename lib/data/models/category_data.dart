import 'article_Model.dart';
import '../../presentation/states/base/app_sub_states.dart';
import '../../presentation/states/base/main_app_sub_state.dart';


class CategoryData {
  final List<Article> products;
  final MainAppState subState;
  final int currentIndex;
  final bool hasMore;
  final int page;

  const CategoryData({
    this.subState = const InitialState(),
    this.products = const [],
    this.currentIndex = 0,
    this.hasMore = true,
    this.page = 1
  });

  Article get firstArticle => products.first;

  bool get productsIsEmpty => products.isEmpty;

  String get publishedAt => firstArticle.publishedAt;

  CategoryData copyWith({
    List<Article>? products,
    MainAppState? subState,
    int? currentIndex,
    bool? hasMore,
    int? page
  }) {
    return CategoryData(
        currentIndex: currentIndex ?? this.currentIndex,
        subState: subState ?? this.subState,
        products: products ?? this.products,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page
    );
  }
}