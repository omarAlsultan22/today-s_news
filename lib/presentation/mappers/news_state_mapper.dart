import 'package:todays_news/core/errors/exceptions/app_exception.dart';
import '../../data/models/tab_data.dart';
import '../states/news_states.dart';


abstract class NewsStateMapper {

  static R when<R>({
    required NewsStates state,
    required R Function() initial,
    required R Function() loading,
    required R Function(TabData? tabData) loaded,
    required R Function(AppException error) onError,
  }) {
    final currentTabData = state.currentTabData!;
    if (currentTabData.error != null) {
        return onError(currentTabData.error!);
    }
    if (currentTabData.isLoading) {
      return loading();
    }
    if (currentTabData.products.isNotEmpty) {
      return loaded(currentTabData);
    }
    return initial();
  }
}