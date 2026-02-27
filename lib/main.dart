import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/core/config/bloc_observer.dart';
import 'data/repositories_impl/hive_articles_repository.dart';
import 'domain/useCases/tab_useCases/change_tab_useCase.dart';
import 'package:todays_news/data/datasources/local/hive.dart';
import 'package:todays_news/presentation/cubits/News_cubit.dart';
import 'domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/data/datasources/local/cacheHelper.dart';
import 'package:todays_news/data/datasources/remote/dio_helper.dart';
import 'domain/services/connectivity_service/connectivity_provider.dart';
import 'package:todays_news/presentation/constants/home_screen_constants.dart';
import 'package:todays_news/data/repositories_impl/api_articles_repository.dart';
import 'package:todays_news/data/repositories_impl/hybrid_articles_repository.dart';
import 'package:todays_news/domain/services/connectivity_service/connectivity_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  await HiveOperations.init();


  final remoteDatabase = ApiArticlesRepository();
  final localDatabase = HiveArticlesRepository();
  final connectivityProvider = ConnectivityService();
  final repository = HybridArticlesRepository(
      remoteDatabase: remoteDatabase,
      localDatabase: localDatabase,
      connectivityService: connectivityProvider
  );

  final loadDataUseCase = LoadDataUseCase(repository, localDatabase);
  final changeTabUseCase = ChangeTabUseCase(loadDataUseCase: loadDataUseCase);
  const screenIndex = HomeScreenConstants.screenBusinessIndex;

  runApp(
      MultiBlocProvider(providers: [
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        BlocProvider(
            create: (context) =>
            NewsCubit(
                loadDataUseCase: loadDataUseCase,
                changeTabUseCase: changeTabUseCase
            )
              ..changeScreen(screenIndex))
      ], child: const MyApp(),)
  );
}

