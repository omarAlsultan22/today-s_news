import 'package:todays_news/core/errors/exceptions/app_exception.dart';

import 'article_Model.dart';


class TabData {
  final List<Article> products;
  final AppException? error;
  final bool isLoading;
  final bool hasMore;
  final int page;

  const TabData({
    this.products = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.page = 1,
  });

  TabData copyWith({
    List<Article>? products,
    AppException? error,
    bool? isLoading,
    bool? hasMore,
    int? page
  }) {
    return TabData(
        products: products ?? this.products,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page
    );
  }
}