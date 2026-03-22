import 'base/app_states.dart';
import '../../data/models/tab_data.dart';
import 'base/category_data_when_strategy.dart';
import '../../core/errors/exceptions/app_exception.dart';


class SearchState implements CategoryDataWhenStrategy {
  final String query;
  final bool isConnected;
  final CategoryData categoryData;

  SearchState({
    this.query = '',
    this.isConnected = true,
    required this.categoryData
  });

  MainAppState? get currentState => categoryData.state;

  SearchState copyWith({
    String? query,
    bool? isConnected,
    CategoryData? categoryData,
  }) {
    return SearchState(
      query: query ?? this.query,
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
    if (!isConnected) {
      return onConnection!();
    }
    return currentState!.when(
      onInitial: onInitial,
      onLoading: onLoading,
      onLoaded: (currentData) => onLoaded(currentData),
      onError: (error) => onError(error),
    );
  }
}
