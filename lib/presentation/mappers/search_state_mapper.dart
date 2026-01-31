import '../../core/errors/exceptions/app_exception.dart';
import 'package:todays_news/data/models/tab_data.dart';
import '../states/search_state.dart';


class SearchStateMapper {
  static R when<R>({
    required SearchState state,
    required R Function() initial,
    required R Function() loading,
    required R Function(TabData? tabData) loaded,
    required R Function(AppException error) onError}) {

    final tabData = state.tabData;
    final query = state.query;

    if (tabData.error != null) {
      return onError(tabData.error!);
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
