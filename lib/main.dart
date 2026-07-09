import 'app/my_app.dart';
import 'config/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'data/data_sources/local/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/data_sources/local/cacheHelper.dart';
import 'data/data_sources/remote/dio_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = DioHelper();
  await dio.init();
  Bloc.observer = MyBlocObserver();
  final cacheHelper = CacheHelper();
  await cacheHelper.init();
  final hiveOperations = HiveOperations();
  await hiveOperations.init();

  runApp(const MyApp());
}

