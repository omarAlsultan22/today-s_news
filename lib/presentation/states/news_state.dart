import '../../core/errors/exceptions/app_exception.dart';
import '../../data/models/tab_data.dart';
import 'base/category_data_when_strategy.dart';


class NewsState implements CategoryDataWhenStrategy{
  final int currentIndex;
  final Map<int, CategoryData> tabsData;

  const NewsState({
    required this.currentIndex,
    required this.tabsData,
  });

  CategoryData? get currentTabData => tabsData[currentIndex];

  bool get isLoadingMore => tabsData[currentIndex]!.isLoading;

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
      currentIndex: currentIndex ?? this.currentIndex,
      tabsData: tabsData ?? this.tabsData,
    );
  }

  @override
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(CategoryData? tabData) loaded,
    required R Function(AppException error) onError,
  }) {
    if (currentTabData!.error != null) {
      return onError(currentTabData!.error!);
    }
    if (currentTabData!.isLoading) {
      return loading();
    }
    if (currentTabData!.products.isNotEmpty) {
      return loaded(currentTabData);
    }
    return initial();
  }
}



