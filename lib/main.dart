import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/core/themes/screen_theme.dart';
import 'domain/useCases/tab_useCases/change_tab_useCase.dart';
import 'package:todays_news/core/services/bloc_observer.dart';
import 'domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/presentation/screens/home_screen.dart';
import 'package:todays_news/data/datasources/local/cacheHelper.dart';
import 'package:todays_news/data/datasources/remote/dio_helper.dart';
import 'package:todays_news/presentation/cubits/categories_cubit.dart';
import 'package:todays_news/data/repositories_impl/api_repository.dart';
import 'package:todays_news/features/home/constants/home_screen_constants.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  final repository = NewsApiRepository();
  final loadUseCase = LoadDataUseCase(repository);
  final changeTabUseCase = ChangeTabUseCase();
  const screenIndex = HomeScreenConstants.screenBusinessIndex;

  runApp(
      MultiBlocProvider(providers: [
        BlocProvider(
            create: (context) =>
            CategoriesCubit(
                loadDataUseCase: loadUseCase,
                changeTabUseCase: changeTabUseCase
            )
              ..changeScreen(screenIndex))
      ], child: const MyApp(),)
  );
}


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
      /*
        400: Color(0xFFFF3D00),
        700: Color(0xFFDD2C00),
        */
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
          return MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeNotifier.themeMode,
              debugShowCheckedModeBanner: false,
              home: const HomeScreen()
          );
        },
      ),
    );
  }
}


