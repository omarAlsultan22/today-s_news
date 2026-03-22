import '../../../data/models/tab_data.dart';
import '../../../core/errors/exceptions/app_exception.dart';


abstract class CategoryDataWhenStrategy {
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData tabData) onLoaded,
    required R Function(AppException error) onError});
}

