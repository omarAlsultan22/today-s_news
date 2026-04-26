import 'base/app_states.dart';
import '../../data/models/tab_data.dart';
import 'base/category_data_when_strategy.dart';
import '../../core/errors/exceptions/base/app_exception.dart';


class SearchState implements CategoryDataWhenStrategy {
  final String query;
  final MainAppState subState;
  final CategoryData categoryData;

  SearchState({
    this.query = '',
    required this.subState,
    required this.categoryData
  });

  bool get queryIsEmpty => query.isEmpty;

  SearchState copyWith({
    String? query,
    MainAppState? subState,
    CategoryData? categoryData,
  }) {
    return SearchState(
      query: query ?? this.query,
      subState: subState ?? this.subState,
      categoryData: categoryData ?? this.categoryData,
    );
  }

  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData) onLoaded,
    required R Function(AppException) onError}) {
    return subState.when(
      onInitial: onInitial,
      onLoading: onLoading,
      onLoaded: () => onLoaded(categoryData),
      onError: (error) => onError(error),
    );
  }
}
