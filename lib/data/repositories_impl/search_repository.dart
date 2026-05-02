import '../config/news_config.dart';
import '../constants/config_keys.dart';
import '../datasources/remote/dio_helper.dart';
import 'package:todays_news/data/models/article_Model.dart';
import '../../presentation/utils/helpers/list_convertor.dart';
import 'package:todays_news/data/constants/data_strings.dart';
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
        url: 'v2/everything',
        query: {
          'q': key,
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