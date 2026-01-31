import '../../data/models/tab_data.dart';


class NewsState {
  final int currentIndex;
  final Map<int, TabData> tabsData;

  const NewsState({
    required this.currentIndex,
    required this.tabsData,
  });

  TabData? get currentTabData => tabsData[currentIndex];

  bool get isLoadingMore => tabsData[currentIndex]!.isLoading;

  NewsState updateTab(int index, TabData newTabData) {
    return copyWith(
      tabsData: {
        ...tabsData,
        index: newTabData,
      },
    );
  }

  NewsState copyWith({
    int? currentIndex,
    Map<int, TabData>? tabsData,
  }) {
    return NewsState(
      currentIndex: currentIndex ?? this.currentIndex,
      tabsData: tabsData ?? this.tabsData,
    );
  }
}



