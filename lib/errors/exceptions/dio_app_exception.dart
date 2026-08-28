import 'package:dio/dio.dart';
import 'base/app_exception.dart';
import 'client_app_exception.dart';
import 'network_app_exception.dart';
import 'base/exception_handler.dart';
import 'package:todays_news/constants/app_strings.dart';
import 'package:todays_news/errors/exceptions/server_app_exception.dart';
import 'package:todays_news/errors/exceptions/unknown_app_exception.dart';
import 'package:todays_news/errors/exceptions/security_app_exception.dart';


class DioAppException extends AppException implements ExceptionHandler {
  DioAppException({
    super.error,
    super.message
  });

  static const String _dioError = 'DIO_ERROR';
  static const _noInternetMessage = AppStrings.noInternetMessage;
  static const String _networkTimeoutMessageSuffix = ' or timeout expired';

  static final Map<DioExceptionType, String> _dioErrorCodePatterns = {
    DioExceptionType.connectionTimeout: 'CONNECTION_TIMEOUT',
    DioExceptionType.sendTimeout: 'SEND_TIMEOUT',
    DioExceptionType.receiveTimeout: 'RECEIVE_TIMEOUT',
    DioExceptionType.connectionError: 'CONNECTION_ERROR',
  };

  static final Map<int, AppException Function(int?)> _badResponsePatterns = {

    403: (statusCode) =>
        SecurityAppException(
          message: 'You do not have permission to access this.',
          code: 'UNAUTHORIZED',
          statusCode: statusCode,
        ),

    404: (statusCode) =>
        ClientAppException(
          message: 'Data not found.',
          code: 'NOT_FOUND',
          statusCode: statusCode,
        ),

    429: (statusCode) =>
        ClientAppException(
          message: 'The number of attempts has been exceeded.',
          code: 'TOO_MANY_REQUESTS',
          statusCode: statusCode,
        ),

    500: (statusCode) =>
        ServerAppException(
          message: 'Server Error.',
          code: 'PLAN_EXPIRED',
          statusCode: statusCode,
        ),
  };

  static final Map<DioExceptionType,
      AppException Function(DioException)> _dioTypeExceptionHandlers = {
    DioExceptionType.connectionTimeout: (error) =>
        NetworkAppException(
          message: '$_noInternetMessage$_networkTimeoutMessageSuffix',
          code: _dioErrorCodePatterns[error.type] ?? _dioError,
        ),
    DioExceptionType.sendTimeout: (error) =>
        NetworkAppException(
          message: '$_noInternetMessage$_networkTimeoutMessageSuffix',
          code: _dioErrorCodePatterns[error.type] ?? _dioError,
        ),
    DioExceptionType.receiveTimeout: (error) =>
        NetworkAppException(
          message: '$_noInternetMessage$_networkTimeoutMessageSuffix',
          code: _dioErrorCodePatterns[error.type] ?? _dioError,
        ),
    DioExceptionType.connectionError: (error) =>
        NetworkAppException(
          message: '$_noInternetMessage$_networkTimeoutMessageSuffix',
          code: _dioErrorCodePatterns[error.type] ?? _dioError,
        ),
    DioExceptionType.badResponse: (error) {
      final statusCode = error.response?.statusCode;
      final handler = _badResponsePatterns[statusCode];
      return handler != null
          ? handler(statusCode)
          : ServerAppException(
        message: 'Server error: $statusCode.',
        statusCode: statusCode,
      );
    },
    DioExceptionType.cancel: (error) =>
        ClientAppException(
          message: 'Request cancelled',
          code: 'REQUEST_CANCELLED',
        ),
    DioExceptionType.unknown: (error) =>
        UnknownAppException(
          message: error.message ?? 'An unexpected error occurred',
          code: 'UNKNOWN_DIO_ERROR',
        )
  };

  @override
  bool canHandle() {
    return _dioTypeExceptionHandlers.containsKey((error as DioException).type);
  }

  @override
  AppException handle() {
    if (canHandle()) {
      return _dioTypeExceptionHandlers[(error as DioException).type]!(error);
    }
    return UnknownAppException(
      message: error.message ?? 'An unexpected error occurred',
      code: 'UNKNOWN_DIO_ERROR',
    );
  }
}
