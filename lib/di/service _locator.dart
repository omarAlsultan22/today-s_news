import 'core/di_core.dart';
import 'package:get_it/get_it.dart';
import 'package:todays_news/di/domains/di_news.dart';


final sl = GetIt.instance;

void setupServiceLocator() {
  // ============ Core ============
  CoreDependencies.register();

  // ============ Domains ============
  NewsDependencies.register();
}