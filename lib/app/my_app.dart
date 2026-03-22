import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/themes/screen_theme.dart';
import '../presentation/cubits/News_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/managers/app_lifecycle_manager.dart';
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

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.amber,
      brightness: Brightness.light,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFFF3D00),
          unselectedIconTheme: IconThemeData(color: Color(0xFF000000))
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
          selectedItemColor: Color(0xFFFF3D00),
          unselectedIconTheme: IconThemeData(color: Color(0xFFFFFFFF))
      ),
      iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white))),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.white),
    );

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

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeNotifier>(
              create: (_) => ThemeNotifier()),
          ChangeNotifierProvider<ConnectivityProvider>(
              create: (_) => ConnectivityProvider()),
          BlocProvider<NewsCubit>(
              create: (_) =>
              NewsCubit(
                  loadDataUseCase: loadDataUseCase,
                  changeTabUseCase: changeTabUseCase
              )
                ..changeScreen(screenIndex)),
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