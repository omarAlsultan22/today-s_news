import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/core/config/bloc_observer.dart';
import 'package:todays_news/data/datasources/local/hive.dart';
import 'package:todays_news/data/datasources/local/cacheHelper.dart';
import 'package:todays_news/data/datasources/remote/dio_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  await HiveOperations.init();

  runApp(const MyApp());
}

