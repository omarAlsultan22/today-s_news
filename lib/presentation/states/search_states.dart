import '../../data/models/tab_data.dart';


class SearchStates {
  final String query;
  final TabData tabData;

  SearchStates({required this.query, required this.tabData});

  SearchStates copyWith({
    String? query,
    TabData? tabData,
  }) {
    return SearchStates(
      query: query ?? this.query,
      tabData: tabData ?? this.tabData,
    );
  }
}
