import '../datasources/remote/dio_helper.dart';
import '../../presentation/constants/api/news_config.dart';
import 'package:todays_news/data/models/article_Model.dart';
import '../../presentation/constants/api/search_config.dart';
import '../../presentation/utils/helpers/list_convertor.dart';
import 'package:todays_news/domain/repositories/data_repository.dart';


class SearchRepository implements DataRepository {

  @override
  Future<List<Article>> fetchArticles(
      {required String key, required int currentPage}) async {
    try {
      if (key
          .trim()
          .isEmpty) {
        return [];
      }

      final response = await DioHelper.getData(
        url: SearchConfig.searchUrl,
        query: {
          'q': key,
          'apiKey': NewsConfig.apiKey,
          'pageSize': NewsConfig.pageSize,
          'page': currentPage,
          'sortBy': NewsConfig.sortBy
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