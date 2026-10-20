import 'package:dio/dio.dart';


abstract class DioHelper {
  static Dio dio = Dio();

  Future <void> init();

  Future <Response> getData({
    required String url,
    required Map<String, dynamic> query,
  });
}