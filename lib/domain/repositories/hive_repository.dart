import 'package:todays_news/domain/repositories/hive_operations.dart';
import 'package:todays_news/domain/repositories/articles_repository.dart';


abstract class HiveRepository implements ArticlesRepository, HiveOperations{}