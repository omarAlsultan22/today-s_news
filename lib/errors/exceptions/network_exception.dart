import 'base/app_exception.dart';
import 'package:flutter/cupertino.dart';
import '../../../presentation/widgets/states/error_widgets/internet_unavailability.dart';


class NetworkException extends AppException {
  NetworkException({required super.message, super.code});

  @override
  Widget buildErrorWidget({VoidCallback? onRetry}) {
    return InternetUnavailability(message: message, onRetry: onRetry);
  }
}