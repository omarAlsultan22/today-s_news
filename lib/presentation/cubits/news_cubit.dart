import 'dart:async';
import '../states/news_state.dart';
import 'package:flutter/material.dart';
import '../../constants/app_durations.dart';
import '../mixins/error_handler_mixin.dart';
import '../../data/models/category_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/update_date_useCase.dart';
import '../../domain/useCases/tab_useCases/change_tab_useCase.dart';
import 'package:todays_news/presentation/mixins/debounce_mixin.dart';
import 'package:todays_news/presentation/states/base/app_states.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/presentation/navigation/screen_items.dart';
import 'package:todays_news/presentation/navigation/bottom_navigation_bar_items.dart';


class NewsCubit extends Cubit<NewsState> with ErrorHandlerMixin<NewsState>, DebounceMixin {
  final LoadDataUseCase _loadDataUseCase;
  final ChangeTabUseCase _changeTabUseCase;
  final UpdateDateUseCase _updateDateUseCase;

  NewsCubit({
    required LoadDataUseCase loadDataUseCase,
    required ChangeTabUseCase changeTabUseCase,
    required UpdateDateUseCase updateDateUseCase
  })
      : _loadDataUseCase = loadDataUseCase,
        _changeTabUseCase = changeTabUseCase,
        _updateDateUseCase = updateDateUseCase,
        super(
        NewsState.initial(),
      );

  static NewsCubit get(context) => BlocProvider.of<NewsCubit>(context);

  List<Widget> get screenItems => ScreenItems.screenItems;

  List<BottomNavigationBarItem> get barItems => BottomNavigationBarItems.items;

  void _successState({
    required CategoryData currentTabData
  }) {
    final newTabData = currentTabData.copyWith(subState: const SuccessState());
    emit(
        state.updateTab(
            state.currentTabIndex, newTabData
        )
    );
  }

  Future<void> updateData(int index) async {
    final currentTabData = state.getCurrentCategoryData(index);
    final currentCategory = state.getCurrentCategoryKey(index);

    if (!currentTabData!.productsIsEmpty) {
      try {
        final newTabData = await _updateDateUseCase.execute(
          page: 1,
          category: currentCategory,
          currentData: currentTabData,
        );
        emit(state.updateTab(index, newTabData));
      }
      catch (e) {
        runDebounced(AppDurations.seconds, () =>
            updateData(index));
      }
    }
  }

  Future<void> changeScreen({required int index}) async {
    emit(state.copyWith(currentTabIndex: index));
    final currentTabData = state.currentTabData;
    emit(state.updateTab(index, currentTabData!));

    final productsIsEmpty = state.productsIsEmpty;
    if (!state.productsIsEmpty) return;

    final newTabData = currentTabData.copyWith(subState: const LoadingState());
    emit(state.updateTab(index, newTabData));

    try {
      final currentTabData = await _changeTabUseCase.execute(
        category: state.categoryStatus,
        currentData: state.currentTabData!,
      );

      if (productsIsEmpty && currentTabData.productsIsEmpty) {
        final newTabData = currentTabData.copyWith(
            subState: const InitialState());
        emit(state.updateTab(index, newTabData));
      }

      print('im here second>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');
      _successState(currentTabData: currentTabData);
    }
    catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) {
            final newTabData = currentTabData.copyWith(subState: ErrorState(
                exception: failure
            ));
            return state.updateTab(index, newTabData);
          }
      );
    }
  }

  Future<void> loadMoreData() async {
    if (!state.hasMore) return;

    try {
      final newTabData = await _loadDataUseCase.execute(
        category: state.categoryStatus,
        currentData: state.currentTabData!,
      );

      _successState(currentTabData: newTabData);
    }
    catch (e) {
      runDebounced(AppDurations.seconds, () =>
          loadMoreData()
      );
    }
  }

  void restLock(int index) {
    final newTabData = state.getCurrentCategoryData(index);
    emit(state.updateTab(index, newTabData!.copyWith(hasMore: true)));
  }
}
