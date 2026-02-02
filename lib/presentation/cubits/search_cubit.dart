import 'dart:async';
import '../states/search_state.dart';
import '../../data/models/tab_data.dart';
import '../../core/errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/core/constants/api/search_config.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/core/errors/exceptions/app_exception.dart';


class SearchCubit extends Cubit<SearchState> {
  final LoadDataUseCase _loadDataUseCase;

  SearchCubit({
    required LoadDataUseCase loadDataUseCase
  })
      : _loadDataUseCase = loadDataUseCase,
        super(SearchState(query: '', categoryData: const CategoryData()));

  static SearchCubit get(context) => BlocProvider.of(context);

  Timer? timer;


  Future<void> getSearch({
    String? query,
  }) async {
    if (timer?.isActive ?? false) timer?.cancel();


    timer = Timer(
        const Duration(milliseconds: SearchConfig.searchDebounceMs), () async {
      final currentTabData = state.categoryData;

      emit(state.copyWith(
          query: query,
          categoryData: currentTabData.copyWith(
              products: const [],
              isLoading: true,
              error: null
          )));

      try {
        final newTabData = await _loadDataUseCase.execute(
          query: query,
          currentData: currentTabData,
        );

        emit(state.copyWith(
            query: query,
            categoryData: newTabData
        ));
      }
      on AppException catch (e) {
        final failure = ErrorHandler.handleException(e);
        final newTabData = currentTabData.copyWith(
          isLoading: false,
          error: failure,
        );
        emit(state.copyWith(categoryData: newTabData));
      }
    });
  }
}
