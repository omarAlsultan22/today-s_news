import 'package:todays_news/core/errors/exceptions/base/app_exception.dart';


class ClientException extends AppException {
  ClientException({
    required super.message,
    super.statusCode,
    super.code
  });
}