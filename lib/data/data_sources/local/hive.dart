import '../../config/news_config.dart';
import '../../models/article_Model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todays_news/data/data_sources/local/cacheHelper.dart';
import '../../../errors/exceptions/cache_exceptions/hive_app_exceptions.dart';


class HiveOperations {
  final CacheHelper _cacheHelper;

  HiveOperations({required CacheHelper cacheHelper})
      : _cacheHelper = cacheHelper;

  static late Box<Article>? _businessBox;
  static late Box<Article>? _scienceBox;
  static late Box<Article>? _sportsBox;

  static Box<Article> get businessBox {
    if (_businessBox == null) {
      throw const HiveInitializeException();
    }
    return _businessBox!;
  }

  static Box<Article> get scienceBox {
    if (_scienceBox == null) {
      throw const HiveInitializeException();
    }
    return _scienceBox!;
  }

  static Box<Article> get sportsBox {
    if (_sportsBox == null) {
      throw const HiveInitializeException ();
    }
    return _sportsBox!;
  }

  static final Map<String, Box<Article>> _boxes = {
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
      throw HiveInitializeException(error: e);
    }
  }

  Future<void> putLocalData({
    required String key,
    required int itemsCount,
    required List<Article> articles
  }) async {
    try {
      final currentBox = _boxes[key];
      for (int i = 0; i < articles.length; i++) {
        final number = itemsCount + i;
        await currentBox!.put('item_$number', articles[i]);
      }
    } catch (e) {
      throw HiveSaveException(error: e);
    }
  }

  Future<List<Article>> getLocalData({
    required String key,
    required int currentIndex
  }) async {
    try {
      List<Article> articles = [];
      final currentBox = _boxes[key];
      final itemsCount = await _cacheHelper.getInt(key: '$key-itemsCount') ?? 0;
      final currentPage = currentIndex + NewsConfig.pageSize;
      final length = currentPage < itemsCount
          ? currentPage
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
      throw HiveReadException(error: e);
    }
  }

  Future<void> clearData(String key) async {
    try {
      final currentBox = _boxes[key];
      await currentBox!.clear();
    }
    catch (e) {
      throw HiveClearException(error: e);
    }
  }
}

