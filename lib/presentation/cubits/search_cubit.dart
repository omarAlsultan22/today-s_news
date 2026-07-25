import 'dart:io';
import 'dart:async';
import '../states/search_state.dart';
import '../mixins/error_handler_mixin.dart';
import '../../data/models/category_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/constants/app_strings.dart';
import 'package:todays_news/constants/app_durations.dart';
import '../../domain/useCases/tab_useCases/change_tab_useCase.dart';
import 'package:todays_news/presentation/mixins/debounce_mixin.dart';
import 'package:todays_news/presentation/states/base/app_states.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class SearchCubit extends Cubit<SearchState> with ErrorHandlerMixin<SearchState>, DebounceMixin {
  final LoadDataUseCase _loadDataUseCase;
  final ChangeTabUseCase _changeTabUseCase;
  final ConnectivityProvider _connectivityProvider;

  SearchCubit({
    required LoadDataUseCase loadDataUseCase,
    required ChangeTabUseCase changeTabUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _loadDataUseCase = loadDataUseCase,
        _changeTabUseCase = changeTabUseCase,
        _connectivityProvider = connectivityProvider,
        super(
          SearchState.initial()) {
    _connectivityProvider.addListener(_updateConnectionStatus);
  }

  static SearchCubit get(context) => BlocProvider.of(context);

  Timer? timer;

  void _updateConnectionStatus() {
    if (_connectivityProvider.isConnected) {
      if (!state.queryIsEmpty && state.productsIsEmpty) {
        getSearch(query: state.query);
      }
    }
  }

  void _successState({
    required CategoryData newTabData
  }) {
    emit(
        state.copyWith(
            categoryData: newTabData,
            subState: const SuccessState()
        )
    );
  }

  Future<void> getSearch({
    required String query,
  }) async {
    if (!_connectivityProvider.isConnected) {
      handleError(
          stackTrace: StackTrace.current,
          error: SocketException,
          onError: (failure) =>
              state.copyWith(
                  subState: ErrorState(
                      exception: failure
                  )
              )
      );
      return;
    }

    if (query.isEmpty) {
      emit(state.copyWith(
          query: AppStrings.empty,
          subState: const InitialState(),
          categoryData: const CategoryData()));
      return;
    }

    emit(
        state.copyWith(
            query: query,
            subState: const LoadingState(),
            categoryData: const CategoryData()
        )
    );
    try {
      final newTabData = await _changeTabUseCase.execute(
        category: query,
        currentData: state.categoryData,
      );
      _successState(newTabData: newTabData);
    }

    catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  subState: ErrorState(
                      exception: failure
                  )
              )
      );
    }
  }

  Future<void> loadMoreSearch() async {
    if (!state.hasMore) return;
    try {
      final newTabData = await _loadDataUseCase.execute(
        query: state.query,
        currentData: state.categoryData,
      );

      _successState(newTabData: newTabData);
    }

    catch (e) {
      runDebounced(AppDurations.seconds, () =>
          loadMoreSearch()
      );
    }
  }

  @override
  Future<void> close() {
    _connectivityProvider.removeListener(_updateConnectionStatus);
    return super.close();
  }
}
