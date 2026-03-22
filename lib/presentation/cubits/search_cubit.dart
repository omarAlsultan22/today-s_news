import 'dart:async';
import '../states/search_state.dart';
import '../../data/models/tab_data.dart';
import '../constants/api/search_config.dart';
import '../../core/errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/core/errors/exceptions/app_exception.dart';
import 'package:todays_news/presentation/states/base/app_states.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class SearchCubit extends Cubit<SearchState> {
  final LoadDataUseCase _loadDataUseCase;
  final ConnectivityProvider _connectivityProvider;

  SearchCubit({
    required LoadDataUseCase loadDataUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _loadDataUseCase = loadDataUseCase,
        _connectivityProvider = connectivityProvider,
        super(
          SearchState(
              categoryData: CategoryData(state: InitialState())
          )
      ) {
    _connectivityProvider.addListener(updateConnectionStatus);
  }

  static SearchCubit get(context) => BlocProvider.of(context);

  Timer? timer;

  void updateConnectionStatus() {
    emit(state.copyWith(isConnected: _connectivityProvider.isConnected));
  }

  Future<void> getSearch({
    String? query,
  }) async {
    final currentTabData = state.categoryData;

    if (!currentTabData.hasMore) {
      return;
    }
    if (timer?.isActive ?? false) timer?.cancel();

    timer = Timer(
        const Duration(
            milliseconds: SearchConfig.searchDebounceMs), () async {
      emit(state.copyWith(
          query: query,
          categoryData: currentTabData.copyWith(
            products: const [],
            state: LoadingState(),
          )));

      try {
        final newTabData = await _loadDataUseCase.execute(
          query: query,
          currentData: currentTabData,
        );

        emit(state.copyWith(
            query: query,
            categoryData: newTabData.copyWith(state: SuccessState(newTabData))
        ));
      }

      on AppException catch (e) {
        final failure = ErrorHandler.handleException(e);
        emit(state.copyWith(
            categoryData: currentTabData.copyWith(state: ErrorState(failure))));
      }
    });
  }
}
