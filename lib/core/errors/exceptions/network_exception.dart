import 'app_exception.dart';


class NoInternetException extends AppException {
  const NoInternetException(super.message, super.isConnection, [super.stackTrace]);
}