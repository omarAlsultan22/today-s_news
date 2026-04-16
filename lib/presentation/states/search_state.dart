import 'base/app_states.dart';
import '../../data/models/tab_data.dart';
import 'base/category_data_when_strategy.dart';
import '../../core/errors/exceptions/app_exception.dart';


class SearchState implements CategoryDataWhenStrategy {
  final String query;
  final bool isConnected;
  final MainAppState subState;
  final CategoryData categoryData;

  SearchState({
    this.query = '',
    this.isConnected = true,
    required this.subState,
    required this.categoryData
  });

  SearchState copyWith({
    String? query,
    bool? isConnected,
    MainAppState? subState,
    CategoryData? categoryData,
  }) {
    return SearchState(
      query: query ?? this.query,
      subState: subState ?? this.subState,
      isConnected: isConnected ?? this.isConnected,
      categoryData: categoryData ?? this.categoryData,
    );
  }

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData) onLoaded,
    required R Function(AppException) onError}) {
    if (onConnection != null && !isConnected) {
      return onConnection();
    }
    return subState.when(
      onInitial: onInitial,
      onLoading: onLoading,
      onLoaded: () => onLoaded(categoryData),
      onError: (error) => onError(error),
    );
  }
}
