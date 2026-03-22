import '../../../core/errors/exceptions/app_exception.dart';


abstract class CategoryDataWhenStrategy<T> {
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(T) onLoaded,
    required R Function(AppException) onError});
}

