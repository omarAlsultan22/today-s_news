import 'exceptions/network_exception.dart';
import 'exceptions/server_exception.dart';
import 'exceptions/app_exception.dart';


class ErrorHandler {
  static AppException handleException(AppException exception) {
    if (exception is NoInternetException) {
      return NoInternetException(exception.message, true);
    }
    return ServerException(exception.message, false);
  }
}
