import '../../data/models/tab_data.dart';
import '../../core/errors/exceptions/app_exception.dart';


class SearchState {
  final String query;
  final CategoryData categoryData;

  SearchState({required this.query, required this.categoryData});

  bool get isCategoryData => categoryData.products.isNotEmpty;

  SearchState copyWith({
    String? query,
    CategoryData? categoryData,
  }) {
    return SearchState(
      query: query ?? this.query,
      categoryData: categoryData ?? this.categoryData,
    );
  }

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(CategoryData? tabData) loaded,
    required R Function(AppException error) onError}) {

    if (categoryData.error != null) {
      return onError(categoryData.error!);
    }
    if (categoryData.isLoading && query.isNotEmpty) {
      return loading();
    }
    if (isCategoryData) {
      return loaded(categoryData);
    }
    return initial();
  }
}
