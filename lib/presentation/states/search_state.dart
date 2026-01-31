import '../../data/models/tab_data.dart';


class SearchState {
  final String query;
  final TabData tabData;

  SearchState({required this.query, required this.tabData});

  SearchState copyWith({
    String? query,
    TabData? tabData,
  }) {
    return SearchState(
      query: query ?? this.query,
      tabData: tabData ?? this.tabData,
    );
  }
}
