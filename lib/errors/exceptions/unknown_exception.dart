import 'base/app_exception.dart';


class UnknownException extends AppException{
  UnknownException({required super.message, super.code});
}