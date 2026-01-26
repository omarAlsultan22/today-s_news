import '../datasources/remote/dio_helper.dart';
import '../../core/constants/api/news_config.dart';
import '../../core/constants/api/search_config.dart';
import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/domain/repositories/data_repository.dart';


class SearchRepository implements DataRepository {

  @override
  Future<List<Article>> fetchArticles(
      {required String value, required int page}) async {
    final response = await DioHelper.getData(
      url: SearchConfig.searchUrl,
      query: {
        'q': value,
        'apiKey': NewsConfig.apiKey,
        'pageSize': NewsConfig.pageSize,
        'page': page,
        'sortBy': NewsConfig.sortBy
      },
    );
    return response.data['articles'];
  }
}