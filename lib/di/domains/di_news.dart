import '../service _locator.dart';
import '../../domain/data_sources/hive.dart';
import '../../domain/data_sources/dio_helper.dart';
import '../../presentation/cubits/news_cubit.dart';
import '../../providers/connectivity_provider.dart';
import '../../domain/data_sources/cache_helper.dart';
import '../../domain/repositories/hive_repository.dart';
import '../../domain/use_cases/update_date_use_case.dart';
import '../../domain/repositories/articles_repository.dart';
import '../../data/repositories_impl/search_repository.dart';
import '../../presentation/utils/helpers/save_time_stamp.dart';
import '../../presentation/utils/helpers/storage_validity.dart';
import 'package:todays_news/presentation/cubits/search_cubit.dart';
import '../../data/repositories_impl/api_articles_repository.dart';
import '../../data/repositories_impl/hive_articles_repository.dart';
import '../../data/repositories_impl/hybrid_articles_repository.dart';
import '../../presentation/utils/helpers/pagination_state_manager.dart';
import '../../domain/use_cases/tab_use_cases/load_tab_data_use_case.dart';


class NewsDependencies {
  static void register() {
    // Repositories
    sl.registerLazySingleton<ArticlesRepository>(() =>
        ApiArticlesRepository(
            dioHelper: sl<DioHelper>()
        )
    );

    sl.registerLazySingleton<ArticlesRepository>(() =>
        SearchRepository(
            dioHelper: sl<DioHelper>()
        )
    );

    sl.registerLazySingleton<ArticlesRepository>(() =>
        HiveArticlesRepository(
            cacheHelper: sl<CacheHelper>(),
            saveTimeStamp: sl<SaveTimeStamp>(),
            storageValidity: sl<StorageValidity>(),
            hiveOperations: sl<HiveOperations>()
        ));

    sl.registerLazySingleton<ArticlesRepository>(() =>
        HybridArticlesRepository(
            localRepository: sl<HiveRepository>(),
            apiRepository: sl<ArticlesRepository>(),
            connectivityProvider: sl<ConnectivityProvider>()
        ));

    // UseCase
    sl.registerLazySingleton<LoadDataUseCase>(() =>
        LoadDataUseCase(
            repository: sl<ArticlesRepository>(),
            paginationHandler: sl<PaginationHandler>()
        ),
        instanceName: 'hybrid'
    );

    sl.registerLazySingleton<LoadDataUseCase>(() =>
        LoadDataUseCase(
            repository: sl<ArticlesRepository>(),
            paginationHandler: sl<PaginationHandler>()
        ),
        instanceName: 'search'
    );

    sl.registerLazySingleton<UpdateDateUseCase>(() =>
        UpdateDateUseCase(
            apiRepository: sl<ArticlesRepository>(),
            localRepository: sl<HiveRepository>()));

    // Cubit
    sl.registerFactory<NewsCubit>(() =>
        NewsCubit(
            updateDateUseCase: sl<UpdateDateUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>(),
            loadDataUseCase: sl<LoadDataUseCase>(instanceName: 'hybrid')
        )
    );

    sl.registerFactory<SearchCubit>(() =>
        SearchCubit(
            connectivityProvider: sl<ConnectivityProvider>(),
            loadDataUseCase: sl<LoadDataUseCase>(instanceName: 'search')
        )
    );
  }
}