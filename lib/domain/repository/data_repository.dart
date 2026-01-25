import '../../data/models/article_Model.dart';


abstract class DataRepository {
  Future<List<Article>> fetchCategoryArticles({
    required String category,
    required int page,
  });


  Future<List<Article>> fetchSearchArticles({
    required String value,
    required int currentSearchPage,
  });
}