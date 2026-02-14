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

      if (response.statusCode != 200) {
        throw(Exception('No Internet Connection'));
      }

      return ArticleListParser
          .fromJson(response.data['articles'])
          .data;
    }
    catch (e) {
      rethrow;
    }
  }
}