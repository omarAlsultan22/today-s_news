import 'package:todays_news/data/models/category_data.dart';
import '../../../errors/exceptions/base/app_exception.dart';


abstract class CategoryDataWhenStrategy {
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData, {String? query}) onLoaded,
    required R Function(AppException) onError});
}

