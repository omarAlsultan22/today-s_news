import 'package:todays_news/core/errors/exceptions/base/app_exception.dart';


class SecurityException extends AppException {
  SecurityException({
    required super.message,
    super.statusCode,
    super.code
  });
}