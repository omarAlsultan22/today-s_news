import '../../models/article_Model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todays_news/data/config/news_config.dart';
import 'package:todays_news/data/data_sources/local/cacheHelper.dart';


class HiveOperations {
  final CacheHelper _cacheHelper;

  HiveOperations({required CacheHelper cacheHelper})
      : _cacheHelper = cacheHelper;

  static late Box<Article>? _businessBox;
  static late Box<Article>? _scienceBox;
  static late Box<Article>? _sportsBox;

  static Box<Article> get businessBox {
    if (_businessBox == null) {
      throw Exception('HiveOperations not initialized. Call init() first.');
    }
    return _businessBox!;
  }

  static Box<Article> get scienceBox {
    if (_scienceBox == null) {
      throw Exception('HiveOperations not initialized. Call init() first.');
    }
    return _scienceBox!;
  }

  static Box<Article> get sportsBox {
    if (_sportsBox == null) {
      throw Exception('HiveOperations not initialized. Call init() first.');
    }
    return _sportsBox!;
  }

  static final Map<String,Box<Article>> _boxes = {
    'business': businessBox,
    'science': scienceBox,
    'sports': sportsBox
  };

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(ArticleAdapter());
      _businessBox = await Hive.openBox<Article>('businessBox');
      _scienceBox = await Hive.openBox<Article>('scienceBox');
      _sportsBox = await Hive.openBox<Article>('sportsBox');
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> putLocalData({
    required String key,
    required int currentIndex,
    required List<Article> articles
  }) async {
    try {
      final currentBox = _boxes[key];
      for (int i = currentIndex; i < articles.length; i++) {
        await currentBox!.put('item_$i', articles[i]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Article>> getLocalData({required String key, required int currentIndex}) async {
    try {
      List<Article> articles = [];
      final currentBox = _boxes[key];
      final itemsCount = await _cacheHelper.getInt(key: key) ?? 0;
      final length = NewsConfig.pageSize < itemsCount
          ? NewsConfig.pageSize
          : itemsCount;
      for (int i = currentIndex; i < length; i++) {
        final article = currentBox!.get('item_$i');
        if (article != null) {
          articles.add(article);
        }
      }
      return articles;
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> clearData(String key) async {
    final currentBox = _boxes[key];
    await currentBox!.clear();
  }
}

