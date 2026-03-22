import 'dart:async';
import '../states/news_state.dart';
import 'package:flutter/material.dart';
import '../../data/models/tab_data.dart';
import '../../core/errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/errors/exceptions/app_exception.dart';
import '../../domain/useCases/tab_useCases/change_tab_useCase.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/presentation/navigation/screen_items.dart';
import 'package:todays_news/presentation/states/base/public_states.dart';
import 'package:todays_news/presentation/navigation/bottom_navigation_bar_items.dart';


class NewsCubit extends Cubit<NewsState> {
  final LoadDataUseCase _loadDataUseCase;
  final ChangeTabUseCase _changeTabUseCase;

  static const int _initialTabIndex = 0;
  static const int _initialTabCount = 3;

  NewsCubit({
    required LoadDataUseCase loadDataUseCase,
    required ChangeTabUseCase changeTabUseCase,
  })
      : _loadDataUseCase = loadDataUseCase,
        _changeTabUseCase = changeTabUseCase,
        super(
        NewsState(
          currentIndex: _initialTabIndex,
          tabsData: {
            for (var i = _initialTabIndex; i < _initialTabCount; i++)
              i: CategoryData(state: InitialState())
          },
        ),
      );


  static NewsCubit get(context) => BlocProvider.of<NewsCubit>(context);

  List<Widget> get screenItems => ScreenItems.screenItems;

  List<BottomNavigationBarItem> get barItems => BottomNavigationBarItems.items;


  Future<void> changeScreen(int index) async {
    emit(state.copyWith(currentIndex: index));

    final currentTabData = state.tabsData[index]!;

    try {
      final newTabData = await _changeTabUseCase.execute(
        tabIndex: index,
        currentData: currentTabData,
        loadDataUseCase: _loadDataUseCase,
      );
      emit(state.updateTab(
          index, newTabData.copyWith(state: SuccessState(currentTabData))));
    }
    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(state.updateTab(
          index, currentTabData.copyWith(state: ErrorState(failure))));
    }
  }


  Future<void> getMoreData() async {
    final index = state.currentIndex;
    final currentTabData = state.tabsData[index]!;

    try {
      final newTabData = await _loadDataUseCase.execute(
        tabIndex: index,
        currentData: currentTabData,
      );

      if (newTabData.productsIsEmpty && state.productsIsEmpty!) {
        emit(state.updateTab(
            index, newTabData.copyWith(state: InitialState()))
        );
      }

      emit(state.updateTab(
          index, newTabData.copyWith(state: SuccessState(newTabData))));
    }
    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(state.updateTab(
          index, currentTabData.copyWith(state: ErrorState(failure))));
    }
  }

  void restLock() {
    final index = state.currentIndex;
    final currentTabData = state.tabsData[index]!;
    emit(state.updateTab(index, currentTabData.copyWith(hasMore: true)));
  }
}

