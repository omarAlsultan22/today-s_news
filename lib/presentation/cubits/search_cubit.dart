import 'dart:async';
import 'package:dio/dio.dart';
import '../states/search_state.dart';
import '../mixins/error_handler_mixin.dart';
import '../../data/models/category_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/constants/app_durations.dart';
import 'package:todays_news/presentation/mixins/debounce_mixin.dart';
import 'package:todays_news/presentation/states/base/app_states.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class SearchCubit extends Cubit<SearchState> with ErrorHandlerMixin<SearchState>, DebounceMixin {
  final LoadDataUseCase _loadDataUseCase;
  final ConnectivityProvider _connectivityProvider;

  SearchCubit({
    required LoadDataUseCase loadDataUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _loadDataUseCase = loadDataUseCase,
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
            subState: SuccessState()
        )
    );
  }

  Future<void> getSearch({
    required String query,
  }) async {
    if (!_connectivityProvider.isConnected) {
      handleError(
          stackTrace: StackTrace.current,
          error: DioException(type: DioExceptionType.connectionError,
              requestOptions: RequestOptions()),
          onError: (failure) =>
              state.copyWith(
                  subState: ErrorState(
                      exception: failure
                  )
              )
      );
      return;
    }
    emit(
        state.copyWith(
            query: query,
            subState: LoadingState(),
            categoryData: const CategoryData()
        )
    );
    try {
      final newTabData = await _loadDataUseCase.execute(
        query: query,
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
