import 'app_exception.dart';


class InternetException extends AppException {
  const InternetException(super.message, [super.isConnection, super.stackTrace]);
}