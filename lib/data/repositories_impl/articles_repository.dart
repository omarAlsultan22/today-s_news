import 'package:todays_news/core/constants/api/search_config.dart';
import '../../domain/repositories/data_repository.dart';
import '../../core/utils/helpers/list_convertor.dart';
import '../../core/constants/api/news_config.dart';
import '../datasources/remote/dio_helper.dart';
import '../models/article_Model.dart';


class ArticlesRepository implements DataRepository{

  @override
  Future<List<Article>> fetchArticles({
    required String value,
    required int page,
  }) async {
    final jsonData = await DioHelper.getData(
      url: NewsConfig.newsUrl,
      query: {
        'apiKey': NewsConfig.apiKey,
        'country': NewsConfig.country,
        'pageSize': NewsConfig.pageSize,
        'sortBy': NewsConfig.sortBy,
        'category': value,
        'page': page,
      },
    );

    return ArticleListParser
        .fromJson(jsonData.data['articles'])
        .data;
  }
}