import 'package:todays_news/core/constants/api/search_config.dart';
import '../../core/utils/helpers/list_convertor.dart';
import '../../core/constants/api/news_config.dart';
import '../datasources/remote/dio_helper.dart';
import '../models/article_Model.dart';


class NewsApiRepository {

  Future<List<Article>> fetchCategoryArticles({
    required String category,
    required int page,
  }) async {
    final jsonData = await DioHelper.getData(
      url: NewsConfig.newsUrl,
      query: {
        'apiKey': NewsConfig.apiKey,
        'country': NewsConfig.country,
        'pageSize': NewsConfig.pageSize,
        'sortBy': NewsConfig.sortBy,
        'category': category,
        'page': page,
      },
    );

    return ArticleListParser
        .fromJson(jsonData.data['articles'])
        .data;
  }


  Future<List<Article>> fetchSearchArticles({
    required String value,
    required int currentSearchPage,
  }) async {
    final response = await DioHelper.getData(
      url: SearchConfig.searchUrl,
      query: {
        'q': value,
        'apiKey': NewsConfig.apiKey,
        'pageSize': NewsConfig.pageSize,
        'page': currentSearchPage,
        'sortBy': NewsConfig.sortBy
      },
    );
    return response.data['articles'];
  }
}