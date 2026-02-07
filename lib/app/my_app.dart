import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/themes/screen_theme.dart';
import '../core/managers/app_lifecycle_manager.dart';
import 'package:todays_news/presentation/screens/home_screen.dart';


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

    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
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
      ),
    );
  }
}