import '../../presentation/utils/helpers/list_convertor.dart';
import '../../presentation/constants/api/news_config.dart';
import '../../domain/repositories/data_repository.dart';
import '../datasources/remote/dio_helper.dart';
import '../models/article_Model.dart';


class ApiArticlesRepository implements DataRepository {

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: NewsConfig.newsUrl,
        query: {
          'apiKey': NewsConfig.apiKey,
          'country': NewsConfig.country,
          'pageSize': NewsConfig.pageSize,
          'sortBy': NewsConfig.sortBy,
          'category': key,
          'page': currentPage,
        },
      );

      return ArticleListParser
          .fromJson(response.data['articles'])
          .data;
    }
    catch (e) {
      rethrow;
    }
  }
}