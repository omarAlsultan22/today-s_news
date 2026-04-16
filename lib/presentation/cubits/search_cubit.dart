import 'dart:async';
import '../states/search_state.dart';
import '../../data/models/tab_data.dart';
import '../../core/errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/presentation/states/base/app_states.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/core/errors/exceptions/app_exception.dart';
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
              categoryData: CategoryData(),
              subState: InitialState()
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
    final currentData = state.categoryData;
    emit(
        state.copyWith(
            query: query,
            categoryData: currentData.copyWith(
              products: const [],
            ),
            subState: LoadingState())
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

      emit(
          state.copyWith(
              categoryData: newTabData,
              subState: SuccessState()
          )
      );
    }

    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(
          state.copyWith(
              categoryData: currentData,
              subState: ErrorState(failure: failure)
          )
      );
    }
  }

  Future<void> getMoreSearch() async {
    final currentData = state.categoryData;
    try {
      final newTabData = await _loadDataUseCase.execute(
        query: state.query,
        currentData: currentData,
      );

      if (newTabData.productsIsEmpty) {
        emit(
            state.copyWith(
                categoryData: newTabData,
                subState: InitialState()
            )
        );
      }

      emit(
          state.copyWith(
              categoryData: newTabData,
              subState: SuccessState()
          )
      );
    }

    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(
          state.copyWith(
              categoryData: currentData,
              subState: ErrorState(failure: failure)
          )
      );
    }
  }
}
