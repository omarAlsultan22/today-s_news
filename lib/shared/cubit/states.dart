import '../../models/states_keys_model.dart';


abstract class TodaysNewsStates {
  final String? error;
  final StatesKeys? key;
  TodaysNewsStates({this.error, this.key});
}

class InitialHomeState extends TodaysNewsStates {}

class LoadingState extends TodaysNewsStates {}

class SuccessState extends TodaysNewsStates {}

class ErrorState extends TodaysNewsStates {
  ErrorState({super.error, super.key});
}