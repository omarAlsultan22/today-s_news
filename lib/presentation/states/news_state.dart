import 'base/loaded_states.dart';
import 'base/main_app_sub_state.dart';
import '../../data/models/category_data.dart';
import '../../errors/exceptions/base/app_exception.dart';
import 'package:todays_news/data/models/message_result.dart';
import 'package:todays_news/presentation/states/base/main_app_sup_state.dart';


class NewsState implements MainAppSupState {
  final int currentTabIndex;
  final List<String> categories;
  final MessageResult? messageResult;
  final Map<int, CategoryData> tabsData;
  static const List<String> _categoriesKeys = ['business', 'sports', 'science'];

  const NewsState({
    this.messageResult,
    this.tabsData = const{},
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
        categories: _categoriesKeys,
        messageResult: null
    );
  }

  String get categoryStatus => _categoriesKeys[currentTabIndex];

  CategoryData get currentTabData => tabsData[currentTabIndex] ?? const CategoryData();

  bool get productsIsEmpty => currentTabData.productsIsEmpty;

  MainAppState get subState => currentTabData.subState;

  bool get hasMore => currentTabData.hasMore;

  @override
  DoubleModelSuccessState get dataModels =>
      DoubleModelSuccessState(
      categoryData: currentTabData,
      messageResult: messageResult
  );

  String getCurrentCategoryKey(int index) => _categoriesKeys[index];

  CategoryData? getCurrentCategoryData(int index) => tabsData[index];

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
    MessageResult? messageResult,
    Map<int, CategoryData>? tabsData,
  }) {
    return NewsState(
      categories: categories,
      messageResult: messageResult,
      tabsData: tabsData ?? this.tabsData,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }

  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(DoubleModelSuccessState) onLoaded,
    required R Function(AppException) onError,
  }) {
    return subState.when(
      onInitial: onInitial,
      onLoading: onLoading,
      onLoaded: () => onLoaded(dataModels),
      onError: (error) => onError(error),
    );
  }
}



