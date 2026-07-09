import 'base/main_app_state.dart';
import '../../data/models/category_data.dart';
import '../../errors/exceptions/base/app_exception.dart';
import 'package:todays_news/presentation/states/base/app_states.dart';
import 'package:todays_news/presentation/states/base/category_data_when_strategy.dart';


class NewsState implements CategoryDataWhenStrategy {
  final int currentTabIndex;
  final MainAppState subState;
  final List<String> categories;
  final Map<int, CategoryData> tabsData;
  static const List<String> _categoriesKeys = ['business', 'sports', 'science'];

  const NewsState({
    required this.tabsData,
    required this.subState,
    this.categories = const [],
    required this.currentTabIndex,
  });

  factory NewsState.initial(){
    return NewsState(
        currentTabIndex: 0,
        tabsData: {
          for (var i = 0; i < 3; i++)
            i: const CategoryData()
        },
        subState: InitialState(),
        categories: _categoriesKeys
    );
  }

  bool get hasMore => currentTabData!.hasMore;

  bool get productsIsEmpty => currentTabData!.productsIsEmpty;

  CategoryData? get currentTabData => tabsData[currentTabIndex];

  String get categoryStatus => _categoriesKeys[currentTabIndex];

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
    List<String>? categories,
    Map<int, CategoryData>? tabsData,
  }) {
    return NewsState(
      subState: subState ?? this.subState,
      tabsData: tabsData ?? this.tabsData,
      categories: categories ?? this.categories,
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



