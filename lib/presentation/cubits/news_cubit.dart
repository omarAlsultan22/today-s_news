import 'dart:async';
import '../states/news_state.dart';
import 'package:flutter/material.dart';
import '../../data/models/tab_data.dart';
import '../../core/errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/errors/exceptions/app_exception.dart';
import '../../domain/useCases/tab_useCases/change_tab_useCase.dart';
import 'package:todays_news/presentation/states/base/app_states.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/presentation/navigation/screen_items.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';
import 'package:todays_news/presentation/navigation/bottom_navigation_bar_items.dart';


class NewsCubit extends Cubit<NewsState> {
  final LoadDataUseCase _loadDataUseCase;
  final ChangeTabUseCase _changeTabUseCase;
  final ConnectivityProvider _connectivityProvider;

  static const int _initialTabIndex = 0;
  static const int _initialTabCount = 3;

  NewsCubit({
    required LoadDataUseCase loadDataUseCase,
    required ChangeTabUseCase changeTabUseCase,
    required ConnectivityProvider connectivityProvider
  })
      : _loadDataUseCase = loadDataUseCase,
        _changeTabUseCase = changeTabUseCase,
        _connectivityProvider = connectivityProvider,
        super(
        NewsState(
            currentTabIndex: _initialTabIndex,
            tabsData: {
              for (var i = _initialTabIndex; i < _initialTabCount; i++)
                i: CategoryData()
            },
            subState: InitialState()
        ),
      ) {
    _connectivityProvider.addListener(updateConnectionStatus);
  }

  static NewsCubit get(context) => BlocProvider.of<NewsCubit>(context);

  List<Widget> get screenItems => ScreenItems.screenItems;

  List<BottomNavigationBarItem> get barItems => BottomNavigationBarItems.items;

  void updateConnectionStatus() {
    emit(state.copyWith(isConnected: _connectivityProvider.isConnected));
  }

  Future<void> changeScreen(int index) async {
    emit(state.copyWith(currentTabIndex: index));
    final currentTabData = state.tabsData[index]!;
    if (!currentTabData.productsIsEmpty) return;

    emit(state.copyWith(subState: LoadingState()));

    try {
      final newTabData = await _changeTabUseCase.execute(
        tabIndex: index,
        currentData: currentTabData,
        loadDataUseCase: _loadDataUseCase,
      );

      if (currentTabData.productsIsEmpty && newTabData.productsIsEmpty) {
        emit(state.updateTab(index, newTabData).copyWith(
            subState: InitialState()));
      }

      emit(state.updateTab(index, newTabData).copyWith(
          subState: SuccessState()));
    }
    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(state.updateTab(index, currentTabData).copyWith(
          subState: ErrorState(failure: failure)));
    }
  }


  Future<void> getMoreData() async {
    if(!state.hasMore) return;
    final index = state.currentTabIndex;
    final currentTabData = state.tabsData[index]!;

    try {
      final newTabData = await _loadDataUseCase.execute(
        tabIndex: index,
        currentData: currentTabData,
      );

      emit(state
          .updateTab(index, newTabData)
          .copyWith(subState: SuccessState()));
    }
    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(state
          .updateTab(index, currentTabData)
          .copyWith(subState: ErrorState(failure: failure)));
    }
  }

  void restLock() {
    final index = state.currentTabIndex;
    final newTabData = state.tabsData[index]!;
    emit(state.updateTab(index, newTabData.copyWith(hasMore: true)));
  }
}

