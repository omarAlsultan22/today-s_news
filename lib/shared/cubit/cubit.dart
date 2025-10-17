import 'dart:async';
import '../../modules/sports.dart';
import '../../modules/science.dart';
import '../../modules/business.dart';
import 'package:flutter/material.dart';
import '../networks/local/cacheHelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/model/dataModel.dart';
import 'package:todays_news/shared/cubit/states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todays_news/shared/components/components.dart';

//https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=d1412c4e454044d481709aad5ec6c572

class TodaysNewsCubit extends Cubit<TodaysNewsStates> {
  TodaysNewsCubit() : super(InitialHomeState());

  static TodaysNewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int currentSearchPage = 1;
  int currentBusinessPage = 1;
  int currentSportPage = 1;
  int currentSciencePage = 1;
  final int pageSize = 10;


  Timer? _debounce;


  List <Widget> screenItems = const[
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];


  List <Article> searchList = [];
  List <Article> businessList = [];
  List <Article> sportList = [];
  List <Article> scienceList = [];


  bool isBusinessLoadingMore = false;
  bool isSportLoadingMore = false;
  bool isScienceLoadingMore = false;
  bool isSearchLoadingMore = false;


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
        emit(SuccessState());
      }).catchError((error) {
        emit(SuccessState());
      });
    }
    else {
      themeMode = !themeMode;
      CacheHelper.setDate(key: 'theme', value: themeMode)
          .then((value) {
        emit(SuccessState());
      }).catchError((error) {
        emit(SuccessState());
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
    emit(SuccessState());
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

  void getSearch({
    String? text,
  }) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      emit(LoadingState());

      await getSearchData(
      value: text!,
      pageSize: pageSize,
      currentSearchPage: currentSearchPage
      ).then((value) {
        if (value.isEmpty) {
          emit(SuccessState());
          return;
        }
        ListConvertor listConvertor = ListConvertor.fromJson(value);
        final data = listConvertor.data;
        searchList = data;
        emit(SuccessState());
      }).catchError((error) {
        emit(ErrorState(key: StatesKeys.search, error: error.toString()));
      });
    });
  }


  Future<void> getPaginationSearch({
    String? text,
    bool? loadMore = false
  }) async {
    if (isSearchLoadingMore) return;

    if (loadMore!) {
      currentSearchPage ++;
      isSearchLoadingMore = true;
      emit(LoadingState());
    } else {
      currentSearchPage = 1;
      emit(LoadingState());
    }
    await getSearchData(
        value: text!, 
        pageSize: pageSize, 
        currentSearchPage: currentSearchPage
    ).then((value) {
      if (loadMore && value.isEmpty) {
        isSearchLoadingMore = true;
        emit(SuccessState());
        return;
      }
      ListConvertor listConvertor = ListConvertor.fromJson(
          value);
      final data = listConvertor.data;
      searchList.addAll(data);
      isSearchLoadingMore = false;
      emit(SuccessState());
    }).catchError((error) {
      emit(ErrorState(key: StatesKeys.search, error: error.toString()));
    });
  }


  Future<void> getBusiness({bool loadMore = false}) async {
    if (isBusinessLoadingMore) return;

    if (loadMore) {
      currentBusinessPage ++;
      isBusinessLoadingMore = true;
      emit(LoadingState());

    } else {
      currentBusinessPage = 1;
      emit(LoadingState());
    }
    await getCategoryData(
        category: 'business',
        pageSize: pageSize,
        currentBusinessPage: currentBusinessPage
    ).then((value) {
      if (loadMore && value.isEmpty) {
        isBusinessLoadingMore = true;
        emit(SuccessState());
        return;
      }
      ListConvertor listConvertor = ListConvertor.fromJson(value);
      final data = listConvertor.data;
      businessList.addAll(data);
      isBusinessLoadingMore = false;
        emit(SuccessState());
    }).catchError((error) {
      if (loadMore) currentBusinessPage--;
      isBusinessLoadingMore = true;
      emit(ErrorState(key: StatesKeys.business, error: error.toString()));
    });
  }

  Future<void> getSport({bool loadMore = false}) async {
    if (isSportLoadingMore) return;

    if (loadMore) {
      currentSportPage ++;
      isSportLoadingMore = true;
    } else {
      currentSportPage = 1;
      emit(LoadingState());
    }
    await getCategoryData(
        category: 'sport',
        pageSize: pageSize,
        currentBusinessPage: currentSportPage
    ).then((value) {
      if (loadMore && value.isEmpty) {
        isSportLoadingMore = true;
        emit(SuccessState());
        return;
      }
      ListConvertor listConvertor = ListConvertor.fromJson(value);
      final data = listConvertor.data;
      sportList.addAll(data);
      isSportLoadingMore = false;
      emit(SuccessState());
    }).catchError((error) {
      if (loadMore) currentSportPage--;
      isSportLoadingMore = true;
      emit(ErrorState(key: StatesKeys.sports, error: error.toString()));
    });
  }

  Future<void> getScience({bool loadMore = false}) async {
    if (isScienceLoadingMore) return;

    if (loadMore) {
      currentSciencePage ++;
      isScienceLoadingMore = true;
    } else {
      currentSciencePage = 1;
      emit(LoadingState());
    }
    await getCategoryData(
        category: 'science',
        pageSize: pageSize,
        currentBusinessPage: currentSciencePage
    ).then((value) {
      if (loadMore && value.isEmpty) {
        isScienceLoadingMore = true;
        emit(SuccessState());
        return;
      }
      ListConvertor listConvertor = ListConvertor.fromJson(value);
      final data = listConvertor.data;
      scienceList.addAll(data);
      isScienceLoadingMore = false;
      emit(SuccessState());
    }).catchError((error) {
      if (loadMore) currentSciencePage--;
      isScienceLoadingMore = true;
      emit(ErrorState(key: StatesKeys.science, error: error.toString()));
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