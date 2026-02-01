import '../../../data/models/tab_data.dart';
import '../../../core/errors/exceptions/app_exception.dart';


abstract class CategoryDataWhenStrategy {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(CategoryData? tabData) loaded,
    required R Function(AppException error) onError,
  });
}
