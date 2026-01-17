import '../../data/models/tab_data.dart';
import 'base/tab_data_when_strategy.dart';


class NewsStates implements TabDataWhenStrategy{
  final int currentIndex;
  final Map<int, TabData> tabsData;

  const NewsStates({
    required this.currentIndex,
    required this.tabsData,
  });

  TabData? get currentTabData => tabsData[currentIndex];

  bool get isLoadingMore => tabsData[currentIndex]!.isLoading;

  NewsStates updateTab(int index, TabData newTabData) {
    return copyWith(
      tabsData: {
        ...tabsData,
        index: newTabData,
      },
    );
  }

  NewsStates copyWith({
    int? currentIndex,
    Map<int, TabData>? tabsData,
  }) {
    return NewsStates(
      currentIndex: currentIndex ?? this.currentIndex,
      tabsData: tabsData ?? this.tabsData,
    );
  }

  @override
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(TabData? tabData) loaded,
    required R Function(String errorText, bool errorType) error,
  }) {
    if (currentTabData!.error != null) {
      if (currentTabData!.isConnection) {
        return error(currentTabData!.error!, true);
      }
      return error(currentTabData!.error!, false);
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



