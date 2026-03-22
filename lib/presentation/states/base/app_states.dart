import 'package:todays_news/core/errors/exceptions/app_exception.dart';
import 'package:todays_news/presentation/states/base/category_data_when_strategy.dart';


abstract class MainAppState implements CategoryDataWhenStrategy{}

class InitialState<T> extends MainAppState{
  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(T tabData) onLoaded,
    required R Function(AppException error) onError}) {
    return onInitial();
  }
}

class LoadingState<T> extends MainAppState{
  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(T tabData) onLoaded,
    required R Function(AppException error) onError}) {
    return onLoading();
  }
}

class SuccessState<T> extends MainAppState{
  final T _currentTabData;
  SuccessState(this._currentTabData);
  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(T tabData) onLoaded,
    required R Function(AppException error) onError}) {
    return onLoaded(_currentTabData);
  }
}

class ErrorState<T> extends MainAppState {
  final AppException _error;
  ErrorState(this._error);

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(T tabData) onLoaded,
    required R Function(AppException error) onError}) {
    return onError(_error);
  }
}