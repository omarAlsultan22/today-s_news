import 'dart:async';
import '../states/search_states.dart';
import '../../data/models/tab_data.dart';
import '../../core/errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/core/constants/api/search_config.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/core/errors/exceptions/app_exception.dart';


class SearchCubit extends Cubit<SearchStates> {
  final LoadDataUseCase _loadDataUseCase;

  SearchCubit({
    required LoadDataUseCase loadDataUseCase
  })
      : _loadDataUseCase = loadDataUseCase,
        super(SearchStates(query: '', tabData: const TabData()));

  static SearchCubit get(context) => BlocProvider.of(context);

  Timer? timer;


  Future<void> getSearch({
    String? query,
  }) async {
    if (timer?.isActive ?? false) timer?.cancel();


    timer = Timer(
        const Duration(milliseconds: SearchConfig.searchDebounceMs), () async {
      final currentTabData = state.tabData;

      emit(state.copyWith(query: query,
          tabData: currentTabData.copyWith(isLoading: true, error: null)));

      try {
        final newTabData = await _loadDataUseCase.execute(
          currentData: currentTabData.copyWith(isLoading: false),
        );
        emit(state.copyWith(tabData: newTabData));
      }
      on AppException catch (e) {
        final failure = ErrorHandler.handleException(e);
        final newTabData = currentTabData.copyWith(
          isLoading: false,
          error: failure,
        );
        emit(state.copyWith(tabData: newTabData));
      }
    });
  }
}
