import '../../../errors/exceptions/base/app_exception.dart';


abstract class MainAppState<T> {
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException) onError});
}