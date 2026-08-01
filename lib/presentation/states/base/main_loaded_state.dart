import '../../../data/models/article_Model.dart';
import 'package:todays_news/data/models/category_data.dart';
import 'package:todays_news/data/models/message_result.dart';


abstract class LoadedState {
  final CategoryData categoryData;
  final MessageResult? messageResult;

  LoadedState({
    this.messageResult,
    required this.categoryData
  });

  bool get hasMore => categoryData.hasMore;

  List<Article> get products => categoryData.products;
}