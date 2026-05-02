import '../../../data/models/category_data.dart';
import 'load_tab_data_useCase.dart';


class ChangeTabUseCase {
  final LoadDataUseCase _loadDataUseCase;

  ChangeTabUseCase({required LoadDataUseCase loadDataUseCase})
      : _loadDataUseCase = loadDataUseCase;

  Future<CategoryData> execute({
    required String category,
    required CategoryData currentData,
    required LoadDataUseCase loadDataUseCase,
  }) async {
    if (currentData.productsIsEmpty) {
      return await _loadDataUseCase.execute(
        category: category,
        currentData: currentData,
      );
    }
    return currentData;
  }
}