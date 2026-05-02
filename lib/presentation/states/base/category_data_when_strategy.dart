import '../../../errors/exceptions/base/app_exception.dart';


abstract class CategoryDataWhenStrategy<T> {
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(T) onLoaded,
    required R Function(AppException) onError});
}

