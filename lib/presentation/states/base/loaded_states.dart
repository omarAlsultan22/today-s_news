import 'main_loaded_state.dart';


class DoubleModelSuccessState extends LoadedState {
  DoubleModelSuccessState({
    required super.categoryData,
    required super.messageResult
  });
}


class TripleModelSuccessState extends LoadedState {
  final String query;

  TripleModelSuccessState({
    required this.query,
    required super.categoryData,
    required super.messageResult,
  });

  bool get queryIsNotEmpty => query.isNotEmpty;

  bool get productsIsEmpty => products.isEmpty;
}





