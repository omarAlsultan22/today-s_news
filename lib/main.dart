import 'my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'domain/useCases/tab_useCases/change_tab_useCase.dart';
import 'package:todays_news/core/services/bloc_observer.dart';
import 'domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/data/datasources/local/cacheHelper.dart';
import 'package:todays_news/data/datasources/remote/dio_helper.dart';
import 'package:todays_news/domain/repositories/data_repository.dart';
import 'package:todays_news/presentation/cubits/categories_cubit.dart';
import 'package:todays_news/data/repositories_impl/articles_repository.dart';
import 'package:todays_news/features/home/constants/home_screen_constants.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  final DataRepository repository = ArticlesRepository();
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



