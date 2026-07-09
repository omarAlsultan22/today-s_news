import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/layouts/home_layout.dart';
import '../utils/helpers/save_time_stamp.dart';
import '../utils/helpers/storage_validity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_sources/local/hive.dart';
import '../../../presentation/states/news_state.dart';
import '../utils/helpers/pagination_state_manager.dart';
import '../../data/data_sources/remote/dio_helper.dart';
import '../../data/data_sources/local/cacheHelper.dart';
import 'package:todays_news/presentation/cubits/news_cubit.dart';
import '../../data/repositories_impl/api_articles_repository.dart';
import '../../domain/useCases/tab_useCases/change_tab_useCase.dart';
import '../../data/repositories_impl/hive_articles_repository.dart';
import '../../data/repositories_impl/hybrid_articles_repository.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dioHelper = DioHelper();
    final cacheHelper = CacheHelper();
    final hiveOperations = HiveOperations();
    final remoteDatabase = ApiArticlesRepository(dioHelper: dioHelper);
    final saveTimeStamp = SaveTimeStamp(cacheHelper: cacheHelper);
    final storageValidity = StorageValidity(cacheHelper: cacheHelper);
    final localDatabase = HiveArticlesRepository(
        saveTimeStamp: saveTimeStamp,
        hiveOperations: hiveOperations,
        storageValidity: storageValidity
    );
    final connectivityService = ConnectivityService();

    final repository = HybridArticlesRepository(
        remoteDatabase: remoteDatabase,
        localDatabase: localDatabase,
        connectivityService: connectivityService
    );

    final paginationHandler = PaginationHandler();
    final connectivityProvider = ConnectivityProvider();
    final loadDataUseCase = LoadDataUseCase(
        repository: repository, paginationHandler: paginationHandler);
    final changeTabUseCase = ChangeTabUseCase(loadDataUseCase: loadDataUseCase);

    return BlocProvider<NewsCubit>(
        create: (context) =>
        NewsCubit(
            loadDataUseCase: loadDataUseCase,
            changeTabUseCase: changeTabUseCase,
            connectivityProvider: connectivityProvider
        )
          ..changeScreen(index: 0),
        child: BlocBuilder<NewsCubit, NewsState>(
            builder: (context, state) {
              final cubit = NewsCubit.get(context);
              return Consumer<ConnectivityProvider>(
                  builder: (context, connectivityService, child) {
                    return HomeLayout(
                        barItems: cubit.barItems,
                        screenItems: cubit.screenItems,
                        currentIndex: state.currentTabIndex,
                        connectivityService: connectivityService,
                        onChange: (index) => cubit.changeScreen(index: index)
                    );
                  }
              );
            }
        )
    );
  }
}






