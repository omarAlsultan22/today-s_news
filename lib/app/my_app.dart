import '../themes/screen_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/app_lifecycle_manager.dart';
import '../presentation/cubits/News_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/datasources/remote/dio_helper.dart';
import 'package:todays_news/data/datasources/local/hive.dart';
import '../data/repositories_impl/api_articles_repository.dart';
import '../data/repositories_impl/hive_articles_repository.dart';
import '../domain/useCases/tab_useCases/change_tab_useCase.dart';
import '../data/repositories_impl/hybrid_articles_repository.dart';
import 'package:todays_news/presentation/screens/home_screen.dart';
import '../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/data/datasources/local/cacheHelper.dart';
import '../domain/services/connectivity_service/connectivity_service.dart';
import '../domain/services/connectivity_service/connectivity_provider.dart';
import 'package:todays_news/presentation/utils/helpers/save_time_stamp.dart';
import 'package:todays_news/presentation/utils/helpers/storage_validity.dart';
import 'package:todays_news/presentation/utils/helpers/pagination_state_manager.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.amber,
      brightness: Brightness.light,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.orange,
          unselectedIconTheme: IconThemeData(color: Colors.black)
      ),
      iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.black))),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.black),
    );

    final ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.amber,
      brightness: Brightness.dark,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.orange,
          unselectedIconTheme: IconThemeData(color: Colors.white)
      ),
      iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white))),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.white),
    );

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

    return MultiProvider(
        providers: [
          BlocProvider<NewsCubit>(
              create: (_) =>
              NewsCubit(
                  loadDataUseCase: loadDataUseCase,
                  changeTabUseCase: changeTabUseCase,
                  connectivityProvider: connectivityProvider
              )
                ..changeScreen(index: 0)),
          ChangeNotifierProvider<ConnectivityProvider>(
              create: (_) => ConnectivityProvider()),
          ChangeNotifierProvider<ThemeNotifier>(
              create: (_) => ThemeNotifier(cacheHelper: cacheHelper))
        ],
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return AppLifecycleManager(
              child: MaterialApp(
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: themeNotifier.themeMode,
                  debugShowCheckedModeBanner: false,
                  home: const HomeScreen()
              ),
            );
          },
        )
    );
  }
}