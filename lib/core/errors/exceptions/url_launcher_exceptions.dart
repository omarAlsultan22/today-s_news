import 'package:todays_news/core/errors/exceptions/base/app_exception.dart';


class CantLaunchUrlAppException extends AppException{
  CantLaunchUrlAppException({required super.message});
}


class InvalidUrlAppException extends AppException {
  InvalidUrlAppException({required super.message});
}


class MissingPluginUrlAppException extends AppException {
  MissingPluginUrlAppException({required super.message});
}


class PlatformUrlAppException extends AppException {
  PlatformUrlAppException({required super.message});
}


class UrlLauncherAppException extends AppException {
  UrlLauncherAppException({required super.message});
}

