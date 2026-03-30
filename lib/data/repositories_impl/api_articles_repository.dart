import '../../presentation/utils/helpers/list_convertor.dart';
import '../../presentation/constants/api/news_config.dart';
import '../../presentation/constants/api/keys_config.dart';
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
          'category': key,
          'country': NewsConfig.country,
          KeysConfig.page: currentPage,
          KeysConfig.sortBy: NewsConfig.sortBy,
          KeysConfig.apiKey: NewsConfig.apiKey,
          KeysConfig.pageSize: NewsConfig.pageSize,
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