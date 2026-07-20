import 'load_tab_data_useCase.dart';
import '../../../data/models/category_data.dart';


class ChangeTabUseCase {
  final LoadDataUseCase _loadDataUseCase;

  ChangeTabUseCase({required LoadDataUseCase loadDataUseCase})
      : _loadDataUseCase = loadDataUseCase;

  Future<CategoryData> execute({
    int? currentPage,
    required String category,
    required CategoryData currentData,
  }) async {
    if (currentData.productsIsEmpty) {
      return await _loadDataUseCase.execute(
        category: category,
        currentPage: currentPage,
        currentData: currentData,
      );
    }
    return currentData;
  }
}