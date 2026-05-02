import '../config/news_config.dart';
import '../../constants/app_texts.dart';
import '../../constants/keys_config.dart';
import '../datasources/remote/dio_helper.dart';
import 'package:todays_news/data/models/article_Model.dart';
import '../../presentation/utils/helpers/list_convertor.dart';
import 'package:todays_news/domain/repositories/data_repository.dart';


class SearchRepository implements DataRepository {
  final DioHelper _dioHelper;

  SearchRepository({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage
  }) async {
    try {
      final response = await _dioHelper.getData(
        url: NewsConfig.searchUrl,
        query: {
          'q': key,
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