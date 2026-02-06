import '../../data/models/article_Model.dart';


abstract class DataRepository {
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
  });
}