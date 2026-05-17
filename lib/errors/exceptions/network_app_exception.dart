import 'base/app_exception.dart';
import 'package:flutter/cupertino.dart';
import '../../../presentation/widgets/states/error_widgets/internet_unavailability.dart';


class NetworkAppException extends AppException {
  NetworkAppException({
    super.code,
    required super.message
  });

  @override
  Widget buildErrorWidget({VoidCallback? onRetry}) {
    return InternetUnavailability(message: message);
  }
}