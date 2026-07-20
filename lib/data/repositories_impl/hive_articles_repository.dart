import '../data_sources/local/hive.dart';
import '../data_sources/local/cacheHelper.dart';
import 'package:todays_news/data/models/article_Model.dart';
import '../../presentation/utils/helpers/storage_validity.dart';
import 'package:todays_news/domain/repositories/data_operations.dart';
import 'package:todays_news/domain/repositories/data_repository.dart';
import 'package:todays_news/presentation/utils/helpers/save_time_stamp.dart';


class HiveArticlesRepository implements DataRepository, DataOperations {
  final CacheHelper _cacheHelper;
  final SaveTimeStamp _saveTimeStamp;
  final HiveOperations _hiveOperations;
  final StorageValidity _storageValidity;

  HiveArticlesRepository({
    required CacheHelper cacheHelper,
    required SaveTimeStamp saveTimeStamp,
    required HiveOperations hiveOperations,
    required StorageValidity storageValidity
  })
      : _cacheHelper = cacheHelper,
        _saveTimeStamp = saveTimeStamp,
        _hiveOperations = hiveOperations,
        _storageValidity = storageValidity;

  @override
  Future<List<Article>> fetchArticles({
    required String key,
    required int currentPage,
    required int currentIndex,
  }) async {
    try {
      final isTimeUp = await _storageValidity.has24HoursPassed();
      if (isTimeUp) {
        clearArticles(key);
        return [];
      }

      final value = await _hiveOperations.getLocalData(
          key: key, currentIndex: currentIndex);

      if (value.isEmpty) return [];

      return value;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveArticles({
    required String key,
    required int currentIndex,
    required List<Article> articles}) async {
    try {
      _saveTimeStamp.saveTime();
      final itemsCount = await _cacheHelper.getInt(key: key) ?? 0;
      _cacheHelper.setInt(
          key: 'itemsCount', value: itemsCount + articles.length);
      return await _hiveOperations.putLocalData(
        key: key,
        articles: articles,
        currentIndex: currentIndex,
      );
    }
    catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearArticles(String key) async {
    await _hiveOperations.clearData(key);
  }
}