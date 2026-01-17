import '../../data/models/tab_data.dart';
import 'base/tab_data_when_strategy.dart';


class SearchStates implements TabDataWhenStrategy {
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

  @override
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(TabData? tabData) loaded,
    required R Function(String errorText, bool errorType) error}) {
    if (tabData.error != null) {
      if (tabData.isConnection) {
        return error(tabData.error!, true);
      }
      return error(tabData.error!, false);
    }
    if (tabData.isLoading && query.isNotEmpty) {
      return loading();
    }
    if (tabData.products.isNotEmpty) {
      return loaded(tabData);
    }
    return initial();
  }
}
