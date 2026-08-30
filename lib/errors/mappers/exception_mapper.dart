import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import '../exceptions/dio_app_exception.dart';
import '../exceptions/base/app_exception.dart';
import '../exceptions/components_exception.dart';
import '../exceptions/client_app_exception.dart';
import '../exceptions/network_app_exception.dart';
import '../exceptions/cache_exceptions/hive_app_exceptions.dart';
import '../exceptions/cache_exceptions/shared_prefs_app_exceptions.dart';


class ExceptionMapper {
  final dynamic error;

  ExceptionMapper({required this.error});

  static const String _msgServerError = 'Cannot reach the server';

  static final Map<String, AppException> _networkPatterns = {
    'socket': NetworkAppException(),
    'network': NetworkAppException(),
    'timeout': NetworkAppException(),
    'connection': NetworkAppException(),
    'host': NetworkAppException(message: _msgServerError),
    'dns': NetworkAppException(message: _msgServerError),
    'unable to resolve': NetworkAppException(message: _msgServerError),
  };

  static final Map<Type,
      AppException Function(dynamic)> _exceptionTypeHandlers = {
    HiveAppException: (error) => error,

    ComponentsException: (error) => error,

    SharedPrefsAppException: (error) => error,

    NetworkAppException: (error) => error,

    DioException: (error) {
      final dioException = DioAppException(
          message: (error as DioException).message ?? 'DIO_ERROR'
      );
      return dioException.handle();
    },
    SocketException: (_) =>
        NetworkAppException(),
    TimeoutException: (_) =>
        NetworkAppException(
          message: 'Timeout expired, please try again later',
        ),
    FormatException: (_) =>
        ClientAppException(
          message: 'An error occurred while loading the data. Please try again',
        ),
  };

  static final RegExp _regex = RegExp(
    '(${[
      ..._networkPatterns.keys
    ].join('|')})',
    caseSensitive: false,
  );

  Iterable<String> get keys =>
      _networkPatterns.keys;

  bool get isKey => _exceptionTypeHandlers.containsKey(error);

  AppException mapByTypePattern() {
    final exception = _exceptionTypeHandlers[error]!(error);
    return exception;
  }

  AppException? mapByStringPattern() {
    final errorMessage = error.toString().toLowerCase();
    final match = _regex.firstMatch(errorMessage);
    if (match != null) {
      final matchedKey = match.group(0)!;
      return _networkPatterns[matchedKey];
    }
    return null;
  }
}
