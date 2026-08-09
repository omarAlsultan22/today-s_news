import '../di/service _locator.dart';
import '../themes/screen_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/cubits/news_cubit.dart';
import '../domain/useCases/update_date_useCase.dart';
import '../data/data_sources/local/cacheHelper.dart';
import '../presentation/providers/connectivity_provider.dart';
import 'package:todays_news/presentation/screens/home_screen.dart';
import '../domain/useCases/tab_useCases/load_tab_data_useCase.dart';


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

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ConnectivityProvider>(
              create: (context) => sl<ConnectivityProvider>()),
          ChangeNotifierProvider<ThemeNotifier>(
              create: (context) =>
                  ThemeNotifier(cacheHelper: sl<CacheHelper>())),
          BlocProvider<NewsCubit>(
              create: (context) =>
                  NewsCubit(
                      loadDataUseCase: sl<LoadDataUseCase>(),
                      updateDateUseCase: sl<UpdateDateUseCase>(),
                      connectivityProvider: sl<ConnectivityProvider>()
                  )
          ),
        ],
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              home: const HomeScreen(),
              debugShowCheckedModeBanner: false,
              themeMode: themeNotifier.themeMode,

            );
          },
        )
    );
  }
}