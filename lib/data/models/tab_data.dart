import 'article_Model.dart';


class TabData {
  final List<Article> products;
  final bool isLoading;
  final bool isConnection;
  final String? error;
  final bool hasMore;
  final int page;

  const TabData({
    this.products = const [],
    this.isLoading = false,
    this.isConnection = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
  });

  TabData copyWith({
    List<Article>? products,
    bool? isConnection,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? page
  }) {
    return TabData(
        products: products ?? this.products,
        isConnection: isConnection ?? this.isConnection,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page
    );
  }
}