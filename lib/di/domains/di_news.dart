import '../service _locator.dart';
import '../../presentation/cubits/news_cubit.dart';
import '../../providers/connectivity_provider.dart';
import '../../domain/use_cases/update_date_use_case.dart';
import '../../data/repositories_impl/search_repository.dart';
import '../../presentation/utils/helpers/save_time_stamp.dart';
import '../../presentation/utils/helpers/storage_validity.dart';
import '../../data/data_sources/local/hive_operations_impl.dart';
import 'package:todays_news/presentation/cubits/search_cubit.dart';
import '../../data/repositories_impl/api_articles_repository.dart';
import '../../data/repositories_impl/hive_articles_repository.dart';
import '../../data/repositories_impl/hybrid_articles_repository.dart';
import '../../presentation/utils/helpers/pagination_state_manager.dart';
import '../../domain/use_cases/tab_use_cases/load_tab_data_use_case.dart';
import 'package:todays_news/data/data_sources/remote/dio_helper_impl.dart';
import 'package:todays_news/data/data_sources/local/cache_helper_impl.dart';


class NewsDependencies {
  static void register() {
    // Repositories
    sl.registerLazySingleton(() =>
        ApiArticlesRepository(
            dioHelper: sl<DioHelperImpl>()
        )
    );

    sl.registerLazySingleton(() =>
        SearchRepository(
            dioHelper: sl<DioHelperImpl>()
        )
    );

    sl.registerLazySingleton(() =>
        HiveArticlesRepository(
            cacheHelper: sl<CacheHelperImpl>(),
            saveTimeStamp: sl<SaveTimeStamp>(),
            storageValidity: sl<StorageValidity>(),
            hiveOperations: sl<HiveOperationsImpl>()
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
            paginationHandler: sl<PaginationHandler>()
        ),
        instanceName: 'hybrid'
    );

    sl.registerLazySingleton(() =>
        LoadDataUseCase(
            repository: sl<SearchRepository>(),
            paginationHandler: sl<PaginationHandler>()
        ),
        instanceName: 'search'
    );

    sl.registerLazySingleton(() =>
        UpdateDateUseCase(
            apiRepository: sl<ApiArticlesRepository>(),
            localRepository: sl<HiveArticlesRepository>()));

    // Cubit
    sl.registerFactory(() =>
        NewsCubit(
            updateDateUseCase: sl<UpdateDateUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>(),
            loadDataUseCase: sl<LoadDataUseCase>(instanceName: 'hybrid')
        )
    );

    sl.registerFactory(() =>
        SearchCubit(
            connectivityProvider: sl<ConnectivityProvider>(),
            loadDataUseCase: sl<LoadDataUseCase>(instanceName: 'search')
        )
    );
  }
}
