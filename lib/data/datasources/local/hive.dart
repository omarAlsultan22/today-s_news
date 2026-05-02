import '../../models/article_Model.dart';
import 'package:hive_flutter/hive_flutter.dart';


class HiveOperations {
  static late Box<List<Article>>? _box;

  static const _underscore = '_';
  static Box get box {
    if (_box == null) {
      throw Exception('HiveOperations not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ArticleAdapter());
    _box = await Hive.openBox<List<Article>>('article');
  }

  Future<void> putLocalData({
    required String key,
    required int currentPage,
    required List<Article> articles
  }) async {
    try {
      await box.put('$key$_underscore$currentPage', articles);
      await box.flush();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Article>> getLocalData(String key, int currentPage) async {
    try {
      return await box.get('$key$_underscore$currentPage');
    }
    catch(e){
      rethrow;
    }
  }

  Future<void> clearData() async {
    await box.clear();
  }

  Future<void> deleteData(String key, int currentPage) async {
    await box.delete('$key$_underscore$currentPage');
  }

  Future<void> closeBox() async {
    await box.flush();
    await _box?.close();
    await Hive.close();
  }
}
