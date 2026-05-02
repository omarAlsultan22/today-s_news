import 'package:flutter/cupertino.dart';
import '../../../../presentation/widgets/states/error_widgets/error_state_widget.dart';


abstract class AppException implements Exception {
  final int? statusCode;
  final String message;
  final String? code;

  const AppException({
    required this.message,
    this.statusCode,
    this.code,
  });

  Widget buildErrorWidget({required VoidCallback onRetry}) {
    return ErrorStateWidget(error: message, onRetry: onRetry);
  }
}