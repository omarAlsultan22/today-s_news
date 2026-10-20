import '../service _locator.dart';
import '../../themes/screen_theme.dart';
import '../../providers/connectivity_provider.dart';
import '../../data/data_sources/remote/dio_helper_impl.dart';
import '../../data/data_sources/local/cache_helper_impl.dart';
import '../../presentation/utils/helpers/save_time_stamp.dart';
import '../../presentation/utils/helpers/storage_validity.dart';
import '../../data/data_sources/local/hive_operations_impl.dart';


class CoreDependencies {
  static void register() {
    //providers
    sl.registerLazySingleton(() => ConnectivityProvider());

    //services
    sl.registerLazySingleton(() => DioHelperImpl());
    sl.registerLazySingleton(() => CacheHelperImpl());
    sl.registerLazySingleton(() =>
        ThemeNotifier(cacheHelper: sl<CacheHelperImpl>()));
    sl.registerLazySingleton(() =>
        HiveOperationsImpl(cacheHelper: sl<CacheHelperImpl>()));
    sl.registerLazySingleton(() =>
        SaveTimeStamp(cacheHelper: sl<CacheHelperImpl>()));
    sl.registerLazySingleton(() =>
        StorageValidity(cacheHelper: sl<CacheHelperImpl>()));
  }
}