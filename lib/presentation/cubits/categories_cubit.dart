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
import 'package:todays_news/presentation/navigation/bottom_navigation_bar_items.dart';


class CategoriesCubit extends Cubit<NewsState> {
  final LoadDataUseCase _loadDataUseCase;
  final ChangeTabUseCase _changeTabUseCase;

  static const int kInitialTabIndex = 0;
  static const int kInitialTabCount = 3;

  CategoriesCubit({
    required LoadDataUseCase loadDataUseCase,
    required ChangeTabUseCase changeTabUseCase
  })
      : _loadDataUseCase = loadDataUseCase,
        _changeTabUseCase = changeTabUseCase,
        super(
        NewsState(
          currentIndex: kInitialTabIndex,
          tabsData: {
            for (var i = 0; i < kInitialTabCount; i++)
              i: const CategoryData()
          },
        ),
      );


  static CategoriesCubit get(context) => BlocProvider.of(context);

  List<Widget> get screenItems => ScreenItems.screenItems;

  List<BottomNavigationBarItem> get barItems => BottomNavigationBarItems.items;


  Future<void> changeScreen(int index) async {
    emit(state.copyWith(currentIndex: index));

    final currentTabData = state.tabsData[index]!;

    emit(state.updateTab(index, currentTabData.copyWith(isLoading: true)));

    try {
      final newTabData = await _changeTabUseCase.execute(
        tabIndex: index,
        currentData: currentTabData,
        loadDataUseCase: _loadDataUseCase,
      );
      emit(state.updateTab(index, newTabData.copyWith(isLoading: false)));
    }
    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      final newTabData = currentTabData.copyWith(
        isLoading: false,
        error: failure,
      );
      emit(state.updateTab(index, newTabData));
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
      emit(state.updateTab(index, newTabData));
      print('im here.......................');
    }
    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      final newTabData = currentTabData.copyWith(
        isLoading: false,
        error: failure,
      );
      emit(state.updateTab(index, newTabData));
    }
  }
}

