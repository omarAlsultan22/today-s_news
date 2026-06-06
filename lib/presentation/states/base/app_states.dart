import 'main_app_state.dart';
import '../../../errors/exceptions/base/app_exception.dart';


class InitialState extends MainAppState {
  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException) onError}) {
    return onInitial();
  }
}

class LoadingState extends MainAppState {
  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException) onError}) {
    return onLoading();
  }
}

class SuccessState extends MainAppState {
  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException) onError}) {
    return onLoaded();
  }
}

class ErrorState extends MainAppState {
  final AppException exception;

  ErrorState({required this.exception});

  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException) onError}) {
    return onError(exception);
  }
}