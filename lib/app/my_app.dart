import '../themes/screen_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_sources/local/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/cubits/news_cubit.dart';
import '../data/data_sources/remote/dio_helper.dart';
import '../domain/useCases/update_date_useCase.dart';
import '../data/data_sources/local/cacheHelper.dart';
import '../presentation/utils/helpers/save_time_stamp.dart';
import '../presentation/utils/helpers/storage_validity.dart';
import '../presentation/providers/connectivity_provider.dart';
import '../data/repositories_impl/api_articles_repository.dart';
import '../data/repositories_impl/hive_articles_repository.dart';
import 'package:todays_news/presentation/screens/home_screen.dart';
import '../data/repositories_impl/hybrid_articles_repository.dart';
import '../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import '../presentation/utils/helpers/pagination_state_manager.dart';


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

    final connectivityProvider = ConnectivityProvider();

    final dioHelper = DioHelper();
    final apiRepository = ApiArticlesRepository(
        dioHelper: dioHelper
    );

    final hiveOperations = HiveOperations(cacheHelper: cacheHelper);
    final saveTimeStamp = SaveTimeStamp(cacheHelper: cacheHelper);
    final storageValidity = StorageValidity(cacheHelper: cacheHelper);

    final localRepository = HiveArticlesRepository(
        cacheHelper: cacheHelper,
        saveTimeStamp: saveTimeStamp,
        hiveOperations: hiveOperations,
        storageValidity: storageValidity
    );

    final hybridRepository = HybridArticlesRepository(
      apiRepository: apiRepository,
      localRepository: localRepository,
      connectivityProvider: connectivityProvider,
    );

    final paginationHandler = PaginationHandler();
    final loadDataUseCase = LoadDataUseCase(
        repository: hybridRepository, paginationHandler: paginationHandler);

    final updateDateUseCase = UpdateDateUseCase(
        apiRepository: apiRepository,
        localRepository: localRepository);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeNotifier>(
              create: (context) => ThemeNotifier(cacheHelper: cacheHelper)),
          ChangeNotifierProvider<ConnectivityProvider>(
              create: (context) => ConnectivityProvider()),
          BlocProvider<NewsCubit>(
              create: (context) =>
                  NewsCubit(
                      loadDataUseCase: loadDataUseCase,
                      updateDateUseCase: updateDateUseCase,
                      connectivityProvider: connectivityProvider
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