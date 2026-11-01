import 'package:dio/dio.dart';
import 'package:todays_news/domain/data_sources/dio_helper.dart';


class FakeDioHelper implements DioHelper {
  // لتسجيل ما وصل
  String? lastUrl;
  Map<String, dynamic>? lastQuery;

  // ما يعيده getData
  Response? responseToReturn;
  Object? errorToThrow;

  @override
  Future<void> init() async {}

  @override
  Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    lastUrl = url;
    lastQuery = query;
    if (errorToThrow != null) throw errorToThrow!;
    return responseToReturn!;
  }
}