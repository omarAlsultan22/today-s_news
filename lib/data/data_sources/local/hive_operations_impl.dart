import '../../config/news_config.dart';
import '../../models/article_Model.dart';
import '../../../domain/data_sources/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/data_sources/cache_helper.dart';
import '../../../errors/exceptions/cache_exceptions/hive_app_exceptions.dart';


class HiveOperationsImpl implements HiveOperations {
  final HiveInterface _hive;
  final CacheHelper _cacheHelper;

  HiveOperationsImpl({
    HiveInterface? hive,
    required CacheHelper cacheHelper,
  })
      : _hive = hive ?? Hive,
        _cacheHelper = cacheHelper;

  Box<Article>? _businessBox;
  Box<Article>? _scienceBox;
  Box<Article>? _sportsBox;

  Box<Article> get businessBox {
    if (_businessBox == null) {
      throw const HiveInitializeException();
    }
    return _businessBox!;
  }

  Box<Article> get scienceBox {
    if (_scienceBox == null) {
      throw const HiveInitializeException();
    }
    return _scienceBox!;
  }

  Box<Article> get sportsBox {
    if (_sportsBox == null) {
      throw const HiveInitializeException ();
    }
    return _sportsBox!;
  }

  Map<String, Box<Article>> get _boxes =>
      {
        'business': businessBox,
        'science': scienceBox,
        'sports': sportsBox
      };

  @override
  Future<void> init() async {
    try {
      await _hive.initFlutter();
      _hive.registerAdapter(ArticleAdapter());
      _businessBox = await _hive.openBox<Article>('businessBox');
      _scienceBox = await _hive.openBox<Article>('scienceBox');
      _sportsBox = await _hive.openBox<Article>('sportsBox');
    }
    catch (e) {
      throw HiveInitializeException(error: e);
    }
  }

  @override
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
    }
    catch (e) {
      throw HiveSaveException(error: e);
    }
  }

  @override
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

  @override
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

