import '../../../data/models/tab_data.dart';
import 'load_tab_data_useCase.dart';


class ChangeTabUseCase {
  Future<TabData> execute({
    required int tabIndex,
    required TabData currentData,
    required LoadDataUseCase loadDataUseCase,
  }) async {
    if (currentData.products.isEmpty) {
      return await loadDataUseCase.execute(
        tabIndex: tabIndex,
        currentData: currentData.copyWith(isLoading: true),
      );
    }
    return currentData;
  }
}