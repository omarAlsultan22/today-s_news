import 'package:todays_news/data/models/article_Model.dart';
import 'package:todays_news/data/datasources/local/hive.dart';
import '../../presentation/utils/helpers/storage_validity.dart';
import 'package:todays_news/domain/repositories/data_operations.dart';
import 'package:todays_news/domain/repositories/data_repository.dart';
import 'package:todays_news/presentation/utils/helpers/save_time_stamp.dart';


class HiveArticlesRepository implements DataRepository, DataOperations {
  final SaveTimeStamp _saveTimeStamp;
  final HiveOperations _hiveOperations;
  final StorageValidity _storageValidity;

  HiveArticlesRepository({
    required SaveTimeStamp saveTimeStamp,
    required HiveOperations hiveOperations,
    required StorageValidity storageValidity
  })
      :
        _saveTimeStamp = saveTimeStamp,
        _hiveOperations = hiveOperations,
        _storageValidity = storageValidity;

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage
  }) async {
    try {
      final isTimeUp = await _storageValidity.has24HoursPassed();
      if (isTimeUp) {
        return [];
      }

      final value = await _hiveOperations.getLocalData(key, currentPage);

      if (value == null) return [];

      if (value is List<Article>) {
        return List<Article>.from(value);
      }

      if (value is List) {
        return value.where((item) => item is Article).cast<Article>().toList();
      }

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
      _saveTimeStamp.saveTime();
      return await _hiveOperations.putLocalData(
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
    await _hiveOperations.clearData();
  }
}