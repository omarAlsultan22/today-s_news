import 'package:dio/dio.dart';
import '../../../constants/app_durations.dart';
import '../../../domain/data_sources/dio_helper.dart';


class DioHelperImpl implements DioHelper {
  final Dio _dio;
  DioHelperImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future <void> init() async {
    _dio.options =
        BaseOptions(
            baseUrl: 'https://newsapi.org/',
            receiveDataWhenStatusError: true
        );
  }

  @override
  Future <Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    return await _dio.get(
        url,
        queryParameters: query).timeout(AppDurations.seconds);
  }
}