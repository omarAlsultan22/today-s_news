import 'dart:async';
import '../states/search_state.dart';
import '../../errors/error_handler.dart';
import '../../data/models/category_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../errors/exceptions/network_exception.dart';
import '../../errors/exceptions/base/app_exception.dart';
import 'package:todays_news/presentation/states/base/app_states.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
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
              categoryData: const CategoryData(),
              subState: InitialState()
          )
      ) {
    _connectivityProvider.addListener(_updateConnectionStatus);
  }

  static SearchCubit get(context) => BlocProvider.of(context);

  Timer? timer;

  void _updateConnectionStatus() {
    if (_connectivityProvider.isConnected && !state.queryIsEmpty) {
      getSearch(query: state.query);
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

  void _errorState({
    required AppException exception,
  }) {
    final failure = ErrorHandler.handleException(exception);
    emit(
        state.copyWith(
            subState: ErrorState(failure: failure)
        )
    );
  }

  Future<void> getSearch({
    String? query,
  }) async {
    final currentData = state.categoryData;
    if (!_connectivityProvider.isConnected) {
      emit(
          state.copyWith(
              query: query,
              categoryData: currentData.copyWith(
                products: const [],
              ),
              subState: ErrorState(
                  failure: NetworkException(message: 'No Internet Connection'))
          )
      );
      return;
    }
    emit(
        state.copyWith(
            query: query,
            categoryData: currentData.copyWith(
              products: const [],
            ),
            subState: LoadingState()
        )
    );
    try {
      final newTabData = await _loadDataUseCase.execute(
        query: query,
        currentData: currentData,
      );

      if (newTabData.productsIsEmpty) {
        emit(
            state.copyWith(
              categoryData: newTabData.copyWith(),
              subState: InitialState(),
            ));
      }
      _successState(newTabData: newTabData);
    }

    on AppException catch (e) {
      _errorState(exception: e);
    }
  }

  Future<void> getMoreSearch() async {
    try {
      final newTabData = await _loadDataUseCase.execute(
        query: state.query,
        currentData: state.categoryData,
      );

      _successState(newTabData: newTabData);
    }

    on AppException catch (e) {
      _errorState(exception: e);
    }
  }

  @override
  Future<void> close() {
    _connectivityProvider.removeListener(_updateConnectionStatus);
    return super.close();
  }
}
