import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/data/datasources/local/hive.dart';
import '../../presentation/utils/helpers/storage_validity.dart';
import 'package:todays_news/domain/repositories/data_operations.dart';
import 'package:todays_news/domain/repositories/data_repository.dart';
import 'package:todays_news/presentation/utils/helpers/save_time_stamp.dart';


class HiveArticlesRepository implements DataRepository, DataOperations {
  static const time = 'saved_time';

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage
  }) async {
    try {

      final isTimeUp = await StorageValidity.has24HoursPassed();
      if(isTimeUp) {
        return [];
      }

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


  @override
  Future<void> saveArticles({
    required String key,
    required int currentPage,
    required List<Article> articles}) async {
    try {
      SaveTimeStamp.saveTime(time);
      return await HiveOperations.putLocalData(
          key: key,
          currentPage: currentPage,
          articles: articles
      );
    }
    catch (e) {
      rethrow;
    }
  }


  @override
  Future<void> clearArticles() async {
    await HiveOperations.clearData();
  }
}