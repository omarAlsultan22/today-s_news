import '../../data/models/tab_data.dart';
import '../../core/errors/exceptions/app_exception.dart';
import 'package:todays_news/presentation/states/base/public_states.dart';
import 'package:todays_news/presentation/states/base/category_data_when_strategy.dart';


class NewsState implements CategoryDataWhenStrategy {
  final int currentIndex;
  final Map<int, CategoryData> tabsData;

  NewsState({
    required this.tabsData,
    required this.currentIndex,
  });

  CategoryData? get currentTabData => tabsData[currentIndex];

  bool? get productsIsEmpty => currentTabData!.productsIsEmpty;

  BaseState? get currentState => currentTabData!.state;

  NewsState updateTab(int index, CategoryData newTabData) {
    return copyWith(
      tabsData: {
        ...tabsData,
        index: newTabData,
      },
    );
  }

  NewsState copyWith({
    int? currentIndex,
    Map<int, CategoryData>? tabsData,
  }) {
    return NewsState(
      tabsData: tabsData ?? this.tabsData,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData tabData) onLoaded,
    required R Function(AppException error) onError,
  }) {
    return currentState!.when(
      onInitial: onInitial,
      onLoading: onLoading,
      onLoaded: (currentTabData) => onLoaded(currentTabData),
      onError: (error) => onError(error),
    );
  }
}



