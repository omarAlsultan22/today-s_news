import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todays_news/layout/business.dart';
import 'package:todays_news/layout/science.dart';
import 'package:todays_news/layout/sport.dart';
import 'package:todays_news/modules/states.dart';
import 'package:todays_news/shared/components/components.dart';
import '../shared/networks/local/cacheHelper.dart';
import '../shared/networks/remote/dio_helper.dart';
//https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=d1412c4e454044d481709aad5ec6c572

class TodayNewsCubit extends Cubit<TodayNewsStates> {
  TodayNewsCubit() : super(InitialHomeState());

  static TodayNewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int currentBusinessPage = 1;
  int currentSportPage = 1;
  int currentSciencePage = 1;
  final int pageSize = 10;

  bool isBusinessLoadingMore = false;
  bool isSportLoadingMore = false;
  bool isScienceLoadingMore = false;

  List <dynamic> searchList = [];
  List <dynamic> businessList = [];
  List <dynamic> sportList = [];
  List <dynamic> scienceList = [];

  Timer? _debounce;

  List <Widget> screenItems = const[
    BusinessScreen(),
    SportScreen(),
    ScienceScreen(),
  ];

  List<BottomNavigationBarItem> items = const[

    BottomNavigationBarItem(
        icon: Icon(Icons.business),
        label: 'Business'),

    BottomNavigationBarItem(
        icon: Icon(Icons.sports),
        label: 'Sports'),

    BottomNavigationBarItem(
        icon: Icon(Icons.science),
        label: 'Science')
  ];

  void toggleTheme(themeMode) {
    if (themeMode == true) {
      themeMode = !themeMode;
      CacheHelper.setDate(key: 'theme', value: themeMode)
          .then((value) {
        emit(ThemeModeState());
      }).catchError((error) {
        emit(ThemeModeErrorState());
      });
    }
    else {
      themeMode = !themeMode;
      CacheHelper.setDate(key: 'theme', value: themeMode)
          .then((value) {
        emit(ThemeModeState());
      }).catchError((error) {
        emit(ThemeModeErrorState());
      });
    }
  }

  void changeIndex(int index) {
    currentIndex = index;

    if (index == 0) {
      if (businessList.isEmpty) {
        getBusiness();
      }
    }
    if (index == 1) {
      if (sportList.isEmpty) {
        getSport();
      }
    }
    if (index == 2) {
      if (scienceList.isEmpty) {
        getScience();
      }
    }
    emit(NewsBottomNavState());
  }

  void loadMoreData() {
    if (currentIndex == 0 && !isBusinessLoadingMore) {
      getBusiness(loadMore: true);
    } else if (currentIndex == 1 && !isSportLoadingMore) {
      getSport(loadMore: true);
    } else if (currentIndex == 2 && !isScienceLoadingMore) {
      getScience(loadMore: true);
    }
  }

  void getSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      emit(SearchLoadingState());

      DioHelper.getData(
        url: 'v2/everything',
        query: {
          'q': value,
          'apiKey': 'd1412c4e454044d481709aad5ec6c572',
        },
      ).then((response) {
        searchList = response.data['articles'];
        emit(SearchSuccessState());
      }).catchError((error) {
        emit(SearchErrorState(error: error.toString()));
      });
    });
  }


  Future<void> getBusiness({bool loadMore = false}) async {
    if (isBusinessLoadingMore) return;

    if (loadMore) {
      currentBusinessPage++;
      isBusinessLoadingMore = true;
    } else {
      currentBusinessPage = 1;
      emit(BusinessLoadingState());
    }
    await getCategoryData(
        category: 'business',
        pageSize: pageSize,
        currentBusinessPage: currentBusinessPage
    ).then((data) {
      if (loadMore && data.isEmpty) {
        isBusinessLoadingMore = true;
        emit(BusinessSuccessState());
        return;
      }
      businessList.addAll(data);
      isBusinessLoadingMore = false;
      emit(BusinessSuccessState());
    }).catchError((error) {
      if (loadMore) currentBusinessPage--;
      isBusinessLoadingMore = true;
      emit(BusinessErrorState(error: error.toString()));
    });
  }

  Future<void> getSport({bool loadMore = false}) async {
    if (isSportLoadingMore) return;

    if (loadMore) {
      currentSportPage++;
      isSportLoadingMore = true;
    } else {
      currentSportPage = 1;
      emit(SportLoadingState());
    }
    await getCategoryData(
        category: 'sport',
        pageSize: pageSize,
        currentBusinessPage: currentBusinessPage
    ).then((data) {
      if (loadMore && data.isEmpty) {
        isSportLoadingMore = true;
        emit(SportSuccessState());
        return;
      }
      sportList.addAll(data);
      isSportLoadingMore = false;
      emit(SportSuccessState());
    }).catchError((error) {
      if (loadMore) currentSportPage--;
      isSportLoadingMore = true;
      emit(SportErrorState(error: error.toString()));
    });
  }

  Future<void> getScience({bool loadMore = false}) async {
    if (isScienceLoadingMore) return;

    if (loadMore) {
      currentSciencePage++;
      isScienceLoadingMore = true;
    } else {
      currentSciencePage = 1;
      emit(ScienceLoadingState());
    }
    await getCategoryData(
        category: 'science',
        pageSize: pageSize,
        currentBusinessPage: currentBusinessPage
    ).then((data) {
      if (loadMore && data.isEmpty) {
        isScienceLoadingMore = true;
        emit(ScienceSuccessState());
        return;
      }
      scienceList.addAll(data);
      isScienceLoadingMore = false;
      emit(ScienceSuccessState());
    }).catchError((error) {
      if (loadMore) currentSciencePage--;
      isScienceLoadingMore = true;
      emit(ScienceErrorState(error: error.toString()));
    });
  }
}

bool toggle = true;

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
    _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    if (_themeMode == ThemeMode.light) {
      toggle = true;
      CacheHelper.setDate(key: 'theme', value: 'light');
    }
    else {
      toggle = false;
      CacheHelper.setDate(key: 'theme', value: 'dark');
    }
    notifyListeners();
  }
  ThemeNotifier() {
    _loadTheme();
  }

  void _loadTheme() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? theme = prefs.getString('theme');
      if (theme == ThemeMode.dark.toString()) {
        _themeMode = ThemeMode.dark;
      } else if (theme == ThemeMode.light.toString()) {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.system;
      }
      notifyListeners();
    } catch (e) {
      print("Error loading theme: $e");
    }
  }
}