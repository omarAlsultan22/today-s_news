import '../../../errors/exceptions/base/app_exception.dart';
import 'package:todays_news/presentation/states/base/main_loaded_state.dart';


abstract class MainAppSupState {

  LoadedState get dataModels;

  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(LoadedState) onLoaded,
    required R Function(AppException) onError});
}

