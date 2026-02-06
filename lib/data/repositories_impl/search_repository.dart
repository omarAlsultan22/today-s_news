import '../datasources/remote/dio_helper.dart';
import '../../core/constants/api/news_config.dart';
import '../../core/constants/api/search_config.dart';
import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/domain/repositories/data_repository.dart';


class SearchRepository implements DataRepository {

  @override
  Future<List<Article>> fetchArticles(
      {required String key, required int currentPage}) async {
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
    return response.data['articles'];
  }
}