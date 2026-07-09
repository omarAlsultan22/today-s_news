import 'base/app_states.dart';
import 'base/main_app_state.dart';
import '../../data/models/category_data.dart';
import 'base/category_data_when_strategy.dart';
import 'package:todays_news/constants/app_strings.dart';
import '../../errors/exceptions/base/app_exception.dart';


class SearchState implements CategoryDataWhenStrategy {
  final String query;
  final MainAppState subState;
  final CategoryData categoryData;

  SearchState({
    required this.query,
    required this.subState,
    required this.categoryData,
  });

  factory SearchState.initial(){
    return SearchState(
        categoryData: const CategoryData(),
        subState: InitialState(),
        query: AppStrings.empty
    );
  }

  bool get queryIsEmpty => query.isEmpty;

  bool get hasMore => categoryData.hasMore;

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
