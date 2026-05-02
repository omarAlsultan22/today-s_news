import 'base/app_exception.dart';


class DioAppException extends AppException {
  DioAppException({
    required super.message,
    required super.statusCode
  });
}