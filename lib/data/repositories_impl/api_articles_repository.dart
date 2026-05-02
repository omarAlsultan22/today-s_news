import '../../presentation/utils/helpers/list_convertor.dart';
import '../../domain/repositories/data_repository.dart';
import 'package:todays_news/constants/app_texts.dart';
import '../datasources/remote/dio_helper.dart';
import '../../constants/keys_config.dart';
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
          .fromJson(response.data[AppTexts.articles])
          .data;
    }
    catch (e) {
      rethrow;
    }
  }
}