import '../../data/models/article_Model.dart';


abstract class ArticlesRepository {
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
    required int currentIndex,
  });
}