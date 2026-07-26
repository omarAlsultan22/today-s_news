import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/layouts/home_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/states/news_state.dart';
import '../utils/helpers/pagination_state_manager.dart';
import 'package:todays_news/presentation/cubits/news_cubit.dart';
import '../../domain/useCases/tab_useCases/change_tab_useCase.dart';
import '../../data/repositories_impl/hybrid_articles_repository.dart';
import 'package:todays_news/data/data_sources/remote/dio_helper.dart';
import 'package:todays_news/domain/useCases/update_date_useCase.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';
import 'package:todays_news/data/repositories_impl/api_articles_repository.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityService = ConnectivityService();

    final hybridRepository = HybridArticlesRepository(
        connectivityService: connectivityService
    );
    final paginationHandler = PaginationHandler();
    final loadDataUseCase = LoadDataUseCase(
        repository: hybridRepository, paginationHandler: paginationHandler);
    final changeTabUseCase = ChangeTabUseCase(loadDataUseCase: loadDataUseCase);

    final dioHelper = DioHelper();
    final apiRepository = ApiArticlesRepository(
        dioHelper: dioHelper
    );
    final updateDateUseCase = UpdateDateUseCase(repository: apiRepository);

    return BlocProvider<NewsCubit>(
        create: (context) =>
        NewsCubit(
            loadDataUseCase: loadDataUseCase,
            changeTabUseCase: changeTabUseCase,
            updateDateUseCase: updateDateUseCase
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






