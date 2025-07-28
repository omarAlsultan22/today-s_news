abstract class TodayNewsStates{}

class InitialHomeState extends TodayNewsStates{}
class NewsBottomNavState extends TodayNewsStates{}
class ThemeModeState extends TodayNewsStates{}
class ThemeModeErrorState extends TodayNewsStates{}


class BusinessSuccessState extends TodayNewsStates{}
class BusinessLoadingState extends TodayNewsStates{}
class BusinessErrorState extends TodayNewsStates{
  late final String error;
  BusinessErrorState(this.error);
}

class SportSuccessState extends TodayNewsStates{}
class SportLoadingState extends TodayNewsStates{}
class SportErrorState extends TodayNewsStates{
  late final String error;
  SportErrorState(this.error);
}

class ScienceSuccessState extends TodayNewsStates{}
class ScienceLoadingState extends TodayNewsStates{}
class ScienceErrorState extends TodayNewsStates{
  late final String error;
  ScienceErrorState(this.error);
}

class SearchSuccessState extends TodayNewsStates{}
class SearchLoadingState extends TodayNewsStates{}
class SearchErrorState extends TodayNewsStates{
  late final String error;
  SearchErrorState(this.error);
}