import '../config/news_config.dart';
import '../constants/config_keys.dart';
import '../../domain/data_sources/dio_helper.dart';
import 'package:todays_news/data/models/article_Model.dart';
import '../../presentation/utils/helpers/list_convertor.dart';
import 'package:todays_news/data/constants/data_strings.dart';
import 'package:todays_news/domain/repositories/articles_repository.dart';


class SearchRepository implements ArticlesRepository {
  final DioHelper _dioHelper;

  SearchRepository({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
    required int currentIndex,
  }) async {
    final response = await _dioHelper.getData(
      url: 'v2/everything',
      query: {
        'q': key,
        'language': 'en',
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
}