import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/domain/repositories/articles_repository.dart';


class FakeArticlesRepository implements ArticlesRepository {
  List<Article> articlesToReturn = [];
  Object? fetchError;
  int fetchCallCount = 0;
  String? lastKey;
  int? lastCurrentPage;
  int? lastCurrentIndex;

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
    required int currentIndex,
  }) async {
    fetchCallCount++;
    lastKey = key;
    lastCurrentPage = currentPage;
    lastCurrentIndex = currentIndex;
    if (fetchError != null) throw fetchError!;
    return articlesToReturn;
  }
}