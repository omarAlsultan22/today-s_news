import '../cubits/News_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/layouts/home_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/states/news_state.dart';
import '../../data/repositories_impl/api_articles_repository.dart';
import '../../data/repositories_impl/hive_articles_repository.dart';
import '../../domain/useCases/tab_useCases/change_tab_useCase.dart';
import '../../data/repositories_impl/hybrid_articles_repository.dart';
import '../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';
import 'package:todays_news/presentation/constants/home_screen_constants.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDatabase = ApiArticlesRepository();
    final localDatabase = HiveArticlesRepository();
    final connectivityProvider = ConnectivityService();
    final repository = HybridArticlesRepository(
        remoteDatabase: remoteDatabase,
        localDatabase: localDatabase,
        connectivityService: connectivityProvider
    );

    final loadDataUseCase = LoadDataUseCase(repository: repository);
    final changeTabUseCase = ChangeTabUseCase(loadDataUseCase: loadDataUseCase);
    const screenIndex = HomeScreenConstants.screenBusinessIndex;

    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityService, child) {
          return BlocProvider(
              create: (context) =>
              NewsCubit(
                  loadDataUseCase: loadDataUseCase,
                  changeTabUseCase: changeTabUseCase
              )
                ..changeScreen(screenIndex),
              child: BlocBuilder<NewsCubit, NewsState>(
                  builder: (context, state) {
                    return HomeLayout(
                        connectivityService: connectivityService
                    );
                  }
              )
          );
        }
    );
  }
}






