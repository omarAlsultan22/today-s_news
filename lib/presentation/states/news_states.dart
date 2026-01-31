import '../../data/models/tab_data.dart';


class NewsStates {
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
}



