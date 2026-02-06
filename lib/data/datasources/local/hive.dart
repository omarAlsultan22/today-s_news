import '../../models/article_Model.dart';
import 'package:hive_flutter/hive_flutter.dart';


abstract class HiveOperations {
  static Box<List<Article>>? _box;

  static Box get box {
    if (_box == null) {
      throw Exception('HiveOperations not initialized. Call init() first.');
    }
    return _box!;
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ArticleAdapter());
    _box = await Hive.openBox<List<Article>>('article');
    print('Box is opened..................');
  }

  static Future<void> putLocalData(String key, List<Article> value,
      int currentPage) async {
    try {
      await box.put('${key}_$currentPage', value);
      await box.flush();
      print("Data is done.........................");
    } catch (e) {
      print("Error saving local data: $e");
    }
  }

  static Future<List<Article>> getLocalData(String key, int currentPage) async {
    return await box.get('${key}_$currentPage');
  }

  static Future<void> clearData() async {
    await box.clear();
  }

  static Future<void> deleteData(String key, int currentPage) async {
    await box.delete('${key}_$currentPage');
  }

  static Future<void> closeBox() async {
    await box.flush();
    await _box?.close();
    await Hive.close();
  }
}
