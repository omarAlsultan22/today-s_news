import '../service _locator.dart';
import '../../themes/screen_theme.dart';
import '../../domain/data_sources/hive.dart';
import '../../domain/data_sources/dio_helper.dart';
import '../../providers/connectivity_provider.dart';
import '../../domain/data_sources/cache_helper.dart';
import '../../data/data_sources/remote/dio_helper_impl.dart';
import '../../data/data_sources/local/cache_helper_impl.dart';
import '../../presentation/utils/helpers/save_time_stamp.dart';
import '../../presentation/utils/helpers/storage_validity.dart';
import '../../data/data_sources/local/hive_operations_impl.dart';


class CoreDependencies {
  static void register() {
    //providers
    sl.registerLazySingleton<ConnectivityProvider>(() => ConnectivityProvider()
    );

    //services
    sl.registerLazySingleton<DioHelper>(() => DioHelperImpl());
    sl.registerLazySingleton<CacheHelper>(() => CacheHelperImpl());
    sl.registerLazySingleton<ThemeNotifier>(() =>
        ThemeNotifier(cacheHelper: sl<CacheHelper>())
    );

    sl.registerLazySingleton<SaveTimeStamp>(() =>
        SaveTimeStamp(cacheHelper: sl<CacheHelper>())
    );

    sl.registerLazySingleton<StorageValidity>(() =>
        StorageValidity(cacheHelper: sl<CacheHelper>())
    );

    sl.registerLazySingleton<HiveOperations>(() =>
        HiveOperationsImpl(cacheHelper: sl<CacheHelper>())
    );
  }
}