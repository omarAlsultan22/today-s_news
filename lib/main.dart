import 'app/my_app.dart';
import 'config/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'data/data_sources/local/hive.dart';
import 'errors/mappers/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/data_sources/local/cacheHelper.dart';
import 'data/data_sources/remote/dio_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = DioHelper();
  Bloc.observer = MyBlocObserver();
  final cacheHelper = CacheHelper();
  final hiveOperations = HiveOperations(cacheHelper: cacheHelper);

  try {
    await dio.init();
    await cacheHelper.init();
    await hiveOperations.init();

    runApp(const MyApp());
  }
  catch (e, stackTrace) {
    final errorHandler = ErrorHandler(
      error: e,
      stackTrace: stackTrace,
    );
    final exception = errorHandler.handleException();
    runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: exception.buildErrorWidget(
                onRetry: () => runApp(const MyApp())
            ),
          ),
        )
    );
  }
}

