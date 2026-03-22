import 'package:todays_news/data/models/tab_data.dart';
import 'package:todays_news/core/errors/exceptions/app_exception.dart';
import 'package:todays_news/presentation/states/base/category_data_when_strategy.dart';


abstract class BaseState implements CategoryDataWhenStrategy{}
class InitialState extends BaseState{
  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData tabData) onLoaded,
    required R Function(AppException error) onError}) {
    return onInitial();
  }
}

class LoadingState extends BaseState{
  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData tabData) onLoaded,
    required R Function(AppException error) onError}) {
    return onLoading();
  }
}

class SuccessState extends BaseState{
  final CategoryData _currentTabData;
  SuccessState(this._currentTabData);
  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData tabData) onLoaded,
    required R Function(AppException error) onError}) {
    return onLoaded(_currentTabData);
  }
}

class ErrorState extends BaseState {
  final AppException _error;
  ErrorState(this._error);

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoryData tabData) onLoaded,
    required R Function(AppException error) onError}) {
    return onError(_error);
  }
}