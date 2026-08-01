import 'base/app_sub_states.dart';
import 'base/main_app_state.dart';
import '../../data/models/category_data.dart';
import 'base/category_data_when_strategy.dart';
import 'package:todays_news/constants/app_strings.dart';
import '../../errors/exceptions/base/app_exception.dart';
import 'package:todays_news/data/models/message_result.dart';
import 'package:todays_news/presentation/states/base/loaded_states.dart';


class SearchState implements MainAppSupState {
  final String query;
  final MainAppState subState;
  final CategoryData categoryData;
  final MessageResult? messageResult;

  SearchState({
    this.messageResult,
    required this.query,
    required this.subState,
    required this.categoryData,
  });

  factory SearchState.initial(){
    return SearchState(
      categoryData: const CategoryData(),
      subState: const InitialState(),
      query: AppStrings.empty,
      messageResult: null,
    );
  }

  @override
  TripleModelSuccessState get dataModels =>
      TripleModelSuccessState(
          query: query,
          categoryData: categoryData,
          messageResult: messageResult
      );

  bool get hasMore => dataModels.hasMore;

  bool get queryIsNotEmpty => dataModels.queryIsNotEmpty;

  bool get productsIsEmpty => dataModels.productsIsEmpty;

  SearchState copyWith({
    String? query,
    MainAppState? subState,
    CategoryData? categoryData,
    MessageResult? messageResult
  }) {
    return SearchState(
      query: query ?? this.query,
      messageResult: messageResult,
      subState: subState ?? this.subState,
      categoryData: categoryData ?? this.categoryData,
    );
  }

  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(TripleModelSuccessState) onLoaded,
    required R Function(AppException) onError}) {
    return subState.when(
      onInitial: onInitial,
      onLoading: onLoading,
      onLoaded: () => onLoaded(dataModels),
      onError: (error) => onError(error),
    );
  }
}
