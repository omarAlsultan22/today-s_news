import 'dart:async';
import '../states/news_state.dart';
import 'package:flutter/material.dart';
import '../navigation/screen_items.dart';
import '../mixins/error_handler_mixin.dart';
import '../../data/models/category_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/update_date_useCase.dart';
import 'package:todays_news/data/models/message_result.dart';
import 'package:todays_news/presentation/mixins/debounce_mixin.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/presentation/states/base/app_sub_states.dart';
import 'package:todays_news/presentation/providers/connectivity_provider.dart';
import 'package:todays_news/presentation/navigation/bottom_navigation_bar_items.dart';


class NewsCubit extends Cubit<NewsState> with ErrorHandlerMixin<NewsState>, DebounceMixin {
  final LoadDataUseCase _loadDataUseCase;
  final UpdateDateUseCase _updateDateUseCase;
  final ConnectivityProvider _connectivityProvider;

  VoidCallback? _connectivityListener;

  NewsCubit({
    required LoadDataUseCase loadDataUseCase,
    required UpdateDateUseCase updateDateUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _loadDataUseCase = loadDataUseCase,
        _updateDateUseCase = updateDateUseCase,
        _connectivityProvider = connectivityProvider,
        super(
        NewsState.initial(),
      ) {
    bool? isConnected;
    _connectivityListener = () {
      if (isConnected != _connectivityProvider.isConnected) {
        isConnected = _connectivityProvider.isConnected;
        emit(state.copyWith(isConnected: isConnected));
      }
    };
    _connectivityProvider.addListener(_connectivityListener!);
  }

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

  Future<void> updateData(
      {required int index, required bool isConnected}) async {
    final currentTabData = state.getCurrentCategoryData(index);

    if (currentTabData == null) return;

    if (!currentTabData.productsIsEmpty && isConnected) {
      final currentCategory = state.getCurrentCategoryKey(index);

      final newTabData = await _updateDateUseCase.execute(
        page: 1,
        key: currentCategory,
        currentData: currentTabData,
      );
      final firstArticle = newTabData.firstArticle;

      if (currentTabData.publishedAt == firstArticle.publishedAt) {
        return;
      }

      final newState = state.updateTab(index, newTabData);
      emit(newState.copyWith(messageResult: MessageResult.success(
          message: 'The news has been successfully updated')));
      return;
    }
    await loadCurrentTabData(index);
  }

  void changeTab(int index) {
    if (state.currentTabIndex != index) {
      emit(state.copyWith(currentTabIndex: index));
    }
  }

  Future<void> loadCurrentTabData(index) async {
    if (!state.currentTabDataIsEmpty) return;

    final currentTabData = state.currentTabData;

    final newTabData = currentTabData.copyWith(subState: const LoadingState());
    emit(state.updateTab(index, newTabData));

    try {
      final categoryData = await _loadDataUseCase.execute(
        category: state.categoryStatus,
        currentData: state.currentTabData,
      );

      if (state.currentTabDataIsEmpty && categoryData.productsIsEmpty) {
        final newTabData = categoryData.copyWith(
            subState: const InitialState());
        emit(state.updateTab(index, newTabData));
        return;
      }

      _successState(currentTabData: categoryData);
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

  Future<void> switchTabAndLoadData({required int index}) async {
    changeTab(index);
    await loadCurrentTabData(index);
  }

  Future<void> loadMoreData() async {
    if (!state.hasMore) return;

    try {
      final newTabData = await _loadDataUseCase.execute(
        category: state.categoryStatus,
        currentData: state.currentTabData,
      );

      _successState(currentTabData: newTabData);
    }
    catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(messageResult: MessageResult.error(
                  message: 'Failed to fetch more data'))
      );
    }
  }

  void restLock(int index) {
    final newTabData = state.getCurrentCategoryData(index);
    emit(state.updateTab(index, newTabData!.copyWith(hasMore: true)));
  }

  @override
  Future<void> close() {
    if (_connectivityListener != null) {
      _connectivityProvider.removeListener(_connectivityListener!);
    }
    return super.close();
  }
}
