import '../../../data/models/tab_data.dart';
import 'load_tab_data_useCase.dart';


class ChangeTabUseCase {
  final LoadDataUseCase _loadDataUseCase;

  ChangeTabUseCase({required LoadDataUseCase loadDataUseCase})
      : _loadDataUseCase = loadDataUseCase;

  Future<CategoryData> execute({
    required int tabIndex,
    required CategoryData currentData,
    required LoadDataUseCase loadDataUseCase,
  }) async {
    if (currentData.products.isEmpty) {
      return await _loadDataUseCase.execute(
        tabIndex: tabIndex,
        currentData: currentData.copyWith(isLoading: true),
      );
    }
    return currentData;
  }
}