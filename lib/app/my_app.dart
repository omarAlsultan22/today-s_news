import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/themes/screen_theme.dart';
import '../presentation/cubits/News_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/managers/app_lifecycle_manager.dart';
import 'package:todays_news/core/constants/app_constants.dart';
import '../data/repositories_impl/api_articles_repository.dart';
import '../data/repositories_impl/hive_articles_repository.dart';
import '../domain/useCases/tab_useCases/change_tab_useCase.dart';
import '../data/repositories_impl/hybrid_articles_repository.dart';
import 'package:todays_news/presentation/screens/home_screen.dart';
import '../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import '../domain/services/connectivity_service/connectivity_service.dart';
import '../domain/services/connectivity_service/connectivity_provider.dart';
import 'package:todays_news/presentation/constants/home_screen_constants.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _white = AppConstants.white;
  static const _black = AppConstants.black;
  static const _amber = AppConstants.amber;
  static const _orange = AppConstants.orange;

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      primarySwatch: _amber,
      brightness: Brightness.light,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: _orange,
          unselectedIconTheme: IconThemeData(color: _black)
      ),
      iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(_black))),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: _black),
    );

    final ThemeData darkTheme = ThemeData(
      primarySwatch: _amber,
      brightness: Brightness.dark,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: _orange,
          unselectedIconTheme: IconThemeData(color: _white)
      ),
      iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(_white))),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: _white),
    );

    final remoteDatabase = ApiArticlesRepository();
    final localDatabase = HiveArticlesRepository();
    final connectivityService = ConnectivityService();
    final repository = HybridArticlesRepository(
        remoteDatabase: remoteDatabase,
        localDatabase: localDatabase,
        connectivityService: connectivityService
    );

    final connectivityProvider = ConnectivityProvider();
    const screenIndex = HomeScreenConstants.screenBusinessIndex;
    final loadDataUseCase = LoadDataUseCase(repository: repository);
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
                ..changeScreen(screenIndex)),
          ChangeNotifierProvider<ConnectivityProvider>(
              create: (_) => ConnectivityProvider()),
          ChangeNotifierProvider<ThemeNotifier>(
              create: (_) => ThemeNotifier())
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