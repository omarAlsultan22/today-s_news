import '../service _locator.dart';
import '../../themes/screen_theme.dart';
import '../../data/data_sources/local/hive.dart';
import '../../data/data_sources/remote/dio_helper.dart';
import '../../data/data_sources/local/cacheHelper.dart';
import '../../presentation/utils/helpers/save_time_stamp.dart';
import '../../presentation/utils/helpers/storage_validity.dart';
import '../../presentation/providers/connectivity_provider.dart';


class CoreDependencies {
  static void register() {
    //providers
    sl.registerLazySingleton(() => ConnectivityProvider());

    //services
    sl.registerLazySingleton(() => DioHelper());
    sl.registerLazySingleton(() => CacheHelper());
    sl.registerLazySingleton(() =>
        ThemeNotifier(cacheHelper: sl<CacheHelper>()));
    sl.registerLazySingleton(() =>
        HiveOperations(cacheHelper: sl<CacheHelper>()));
    sl.registerLazySingleton(() =>
        SaveTimeStamp(cacheHelper: sl<CacheHelper>()));
    sl.registerLazySingleton(() =>
        StorageValidity(cacheHelper: sl<CacheHelper>()));
  }
}