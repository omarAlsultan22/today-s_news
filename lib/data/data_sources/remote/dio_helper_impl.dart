import 'package:dio/dio.dart';
import '../../../constants/app_durations.dart';
import '../../../domain/services/dio_helper.dart';


class DioHelperImpl implements DioHelper {
  static Dio dio = Dio();

  @override
  Future <void> init() async {
    dio = Dio(
        BaseOptions(
            baseUrl: 'https://newsapi.org/',
            receiveDataWhenStatusError: true
        )
    );
  }

  @override
  Future <Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    return await dio.get(
        url,
        queryParameters: query).timeout(AppDurations.seconds);
  }
}