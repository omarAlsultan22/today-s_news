import '../../data/models/article_Model.dart';


abstract class DataRepository {
  Future<List<Article>> fetchArticles({
    required String value,
    required int page,
  });
}