abstract class TodayNewsStates{
  final String? error;
  TodayNewsStates({this.error});
}

class InitialHomeState extends TodayNewsStates{}
class NewsBottomNavState extends TodayNewsStates{}
class ThemeModeState extends TodayNewsStates{}
class ThemeModeErrorState extends TodayNewsStates{}


class BusinessSuccessState extends TodayNewsStates{}
class BusinessLoadingState extends TodayNewsStates{}
class BusinessErrorState extends TodayNewsStates{
  BusinessErrorState({super.error});
}

class SportSuccessState extends TodayNewsStates{}
class SportLoadingState extends TodayNewsStates{}
class SportErrorState extends TodayNewsStates{
  SportErrorState({super.error});
}

class ScienceSuccessState extends TodayNewsStates{}
class ScienceLoadingState extends TodayNewsStates{}
class ScienceErrorState extends TodayNewsStates{
  ScienceErrorState({super.error});
}

class SearchSuccessState extends TodayNewsStates{}
class SearchLoadingState extends TodayNewsStates{}
class SearchErrorState extends TodayNewsStates{
  SearchErrorState({super.error});
}