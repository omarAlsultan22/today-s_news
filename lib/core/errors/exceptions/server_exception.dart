import 'app_exception.dart';


class ServerException extends AppException {
  final int? statusCode;

  const ServerException(
      super.message,
      super.isConnection,
      [
        this.statusCode,
        super.stackTrace,
      ]);
}