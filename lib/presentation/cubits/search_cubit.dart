import 'dart:async';
import '../states/search_state.dart';
import '../../data/models/category_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../errors/mappers/error_handler.dart';
import 'package:todays_news/constants/app_strings.dart';
import '../../errors/exceptions/network_app_exception.dart';
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

  Future<void> getSearch({
    String? query,
  }) async {
    if (!_connectivityProvider.isConnected) {
      emit(
          state.copyWith(
              query: query,
              subState: ErrorState(
                  exception: NetworkAppException(
                      message: AppStrings.noInternetMessage))
          )
      );
      return;
    }
    emit(
        state.copyWith(
            query: query,
            subState: LoadingState()
        )
    );
    try {
      final newTabData = await _loadDataUseCase.execute(
        query: query,
        currentData: state.categoryData,
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

    catch (e, stackTrace) {
      final errorHandler = ErrorHandler(error: e, stackTrace: stackTrace);
      final exception = errorHandler.handleException();
      emit(
          state.copyWith(
              subState: ErrorState(exception: exception)
          )
      );
    }
  }

  Future<void> loadMoreSearch() async {
    try {
      final newTabData = await _loadDataUseCase.execute(
        query: state.query,
        currentData: state.categoryData,
      );

      _successState(newTabData: newTabData);
    }

    catch (e) {
      Future.delayed(const Duration(seconds: 3), () {
        loadMoreSearch();
      });
    }
  }

  @override
  Future<void> close() {
    _connectivityProvider.removeListener(_updateConnectionStatus);
    return super.close();
  }
}
