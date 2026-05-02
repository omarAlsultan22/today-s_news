import 'package:todays_news/data/constants/data_strings.dart';
import '../../presentation/utils/helpers/list_convertor.dart';
import '../../domain/repositories/data_repository.dart';
import '../datasources/remote/dio_helper.dart';
import '../constants/config_keys.dart';
import '../models/article_Model.dart';
import '../config/news_config.dart';


class ApiArticlesRepository implements DataRepository {
  final DioHelper _dioHelper;

  ApiArticlesRepository({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
  }) async {
    try {
      final response = await _dioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'category': key,
          'country': 'us',
          ConfigKeys.page: currentPage,
          ConfigKeys.sortBy: NewsConfig.sortBy,
          ConfigKeys.apiKey: NewsConfig.apiKey,
          ConfigKeys.pageSize: NewsConfig.pageSize,
        },
      );

      return ArticleListParser
          .fromJson(response.data[DataStrings.articles])
          .data;
    }
    catch (e) {
      rethrow;
    }
  }
}