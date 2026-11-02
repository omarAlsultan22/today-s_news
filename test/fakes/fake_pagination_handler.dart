import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/data/models/category_data.dart';
import 'package:todays_news/domain/use_cases/pagination_state_manager.dart';


class FakePaginationHandler implements PaginationHandler {
  CategoryData? resultToReturn;
  int updateCallCount = 0;
  CategoryData? lastCurrentData;
  List<Article>? lastNewArticles;

  @override
  CategoryData updateWithNewData(CategoryData current,
      List<Article> newArticles,) {
    updateCallCount++;
    lastCurrentData = current;
    lastNewArticles = newArticles;
    return resultToReturn ?? current.copyWith();
  }
}