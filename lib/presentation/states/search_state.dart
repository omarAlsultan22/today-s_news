import '../../data/models/tab_data.dart';
import '../../core/errors/exceptions/app_exception.dart';


class SearchState {
  final String query;
  final CategoryData tabData;

  SearchState({required this.query, required this.tabData});

  SearchState copyWith({
    String? query,
    CategoryData? tabData,
  }) {
    return SearchState(
      query: query ?? this.query,
      tabData: tabData ?? this.tabData,
    );
  }

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(CategoryData? tabData) loaded,
    required R Function(AppException error) onError}) {

    if (tabData.error != null) {
      return onError(tabData.error!);
    }
    if (tabData.isLoading && query.isNotEmpty) {
      return loading();
    }
    if (tabData.products.isNotEmpty) {
      return loaded(tabData);
    }
    return initial();
  }
}
