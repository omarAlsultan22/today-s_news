import '../service _locator.dart';
import '../../data/data_sources/local/hive.dart';
import '../../presentation/cubits/news_cubit.dart';
import '../../domain/useCases/update_date_useCase.dart';
import '../../presentation/utils/helpers/save_time_stamp.dart';
import '../../presentation/utils/helpers/storage_validity.dart';
import '../../presentation/providers/connectivity_provider.dart';
import '../../data/repositories_impl/api_articles_repository.dart';
import '../../data/repositories_impl/hive_articles_repository.dart';
import 'package:todays_news/data/data_sources/local/cache_helper.dart';
import 'package:todays_news/data/data_sources/remote/dio_helper.dart';
import '../../data/repositories_impl/hybrid_articles_repository.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import '../../presentation/utils/helpers/pagination_state_manager.dart';


class NewsDependencies {
  static void register() {
    // Repositories
    sl.registerLazySingleton(() =>
        ApiArticlesRepository(
            dioHelper: sl<DioHelper>()
        ));

    sl.registerLazySingleton(() =>
        HiveArticlesRepository(
            cacheHelper: sl<CacheHelper>(),
            saveTimeStamp: sl<SaveTimeStamp>(),
            hiveOperations: sl<HiveOperations>(),
            storageValidity: sl<StorageValidity>()
        ));

    sl.registerLazySingleton(() =>
        HybridArticlesRepository(
          apiRepository: sl<ApiArticlesRepository>(),
          localRepository: sl<HiveArticlesRepository>(),
          connectivityProvider: sl<ConnectivityProvider>(),
        ));

    // UseCase
    sl.registerLazySingleton(() =>
        LoadDataUseCase(
            repository: sl<HybridArticlesRepository>(),
            paginationHandler: sl<PaginationHandler>()));

    sl.registerLazySingleton(() =>
        UpdateDateUseCase(
            apiRepository: sl<ApiArticlesRepository>(),
            localRepository: sl<HiveArticlesRepository>()));

    // Cubit
    sl.registerFactory(() =>
        NewsCubit(
            loadDataUseCase: sl<LoadDataUseCase>(),
            updateDateUseCase: sl<UpdateDateUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()
        ));
  }
}
