import '../themes/screen_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_sources/local/cacheHelper.dart';
import 'package:todays_news/presentation/screens/home_screen.dart';
import '../domain/services/connectivity_service/connectivity_provider.dart';


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

    final cacheHelper = CacheHelper();

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeNotifier>(
              create: (context) => ThemeNotifier(cacheHelper: cacheHelper)),
          ChangeNotifierProvider<ConnectivityProvider>(
              create: (context) => ConnectivityProvider()),
        ],
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return MaterialApp(
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeNotifier.themeMode,
                debugShowCheckedModeBanner: false,
                home: const HomeScreen()
            );
          },
        )
    );
  }
}