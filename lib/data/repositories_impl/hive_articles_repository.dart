import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/data/datasources/local/hive.dart';
import 'package:todays_news/domain/repositories/data_repository.dart';


class HiveArticlesRepository implements DataRepository{
  @override
  Future<List<Article>> fetchArticles({required String key, required int currentPage}) async {
    try {
      final value = await HiveOperations.getLocalData(key, currentPage);

      if (value == null) return [];

      if (value is List<Article>) {
        print('Get data is done..................data ${value.first.title}');
        return List<Article>.from(value);
      }

      if (value is List) {
        print('Get data is done..................data');
        return value.where((item) => item is Article).cast<Article>().toList();
      }

      print('Get data is done..................empty');
      return [];
    } catch (e) {
      return [];
    }
  }
}