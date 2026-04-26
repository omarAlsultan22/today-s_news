import 'package:dio/dio.dart';
import 'package:todays_news/core/constants/app_durations.dart';


class DioHelper {
  static Dio dio = Dio();

  init() {
    dio = Dio(
        BaseOptions(
            baseUrl: 'https://newsapi.org/',
            receiveDataWhenStatusError: true
        )
    );
  }

  Future <Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    return await dio.get(
        url,
        queryParameters: query).timeout(AppDurations.seconds);
  }
}