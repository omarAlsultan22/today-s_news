import '../../data/models/tab_data.dart';
import '../../core/errors/exceptions/base/app_exception.dart';
import 'package:todays_news/presentation/states/base/app_states.dart';
import 'package:todays_news/presentation/states/base/category_data_when_strategy.dart';


class NewsState implements CategoryDataWhenStrategy {
  final int currentTabIndex;
  final MainAppState subState;
  final Map<int, CategoryData> tabsData;

  NewsState({
    required this.tabsData,
    required this.subState,
    required this.currentTabIndex,
  });

  CategoryData? get currentTabData => tabsData[currentTabIndex];

  bool get productsIsEmpty => currentTabData!.productsIsEmpty;

  bool get hasMore => currentTabData!.hasMore;

  NewsState updateTab(int index, CategoryData newTabData) {
    return copyWith(
        tabsData: {
          ...tabsData,
          index: newTabData,
        }
    );
  }

  NewsState copyWith({
    int? currentTabIndex,
    MainAppState? subState,
    Map<int, CategoryData>? tabsData,
  }) {
    return NewsState(
      subState: subState ?? this.subState,
      tabsData: tabsData ?? this.tabsData,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }

  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData) onLoaded,
    required R Function(AppException) onError,
  }) {
    return subState.when(
      onInitial: onInitial,
      onLoading: onLoading,
      onLoaded: () => onLoaded(currentTabData!),
      onError: (error) => onError(error),
    );
  }
}



