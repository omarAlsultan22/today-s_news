import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import '../exceptions/dio_app_exception.dart';
import '../exceptions/base/app_exception.dart';
import '../exceptions/client_app_exception.dart';
import '../exceptions/network_app_exception.dart';
import 'package:todays_news/constants/app_strings.dart';
import '../exceptions/cache_exceptions/hive_app_exceptions.dart';
import '../exceptions/cache_exceptions/shared_prefs_app_exceptions.dart';


class ExceptionMapper {
  final dynamic error;

  ExceptionMapper({required this.error});

  static const String _readOperation = 'read';
  static const String _writeOperation = 'write';

  static const _noInternetMessage = AppStrings.noInternetMessage;
  static const String _msgServerError = 'Cannot reach the server';

  static const String _msgCastError = 'Error in stored data type';
  static const String _msgWriteError = 'Failed to save data to local storage';
  static const String _msgReadError = 'Failed to read data from local storage';
  static const String _msgInitError = 'Local storage has not been initialized correctly';

  static final Map<String, AppException> _networkPatterns = {
    'socket': NetworkAppException(message: _noInternetMessage),
    'connection': NetworkAppException(message: _noInternetMessage),
    'network': NetworkAppException(message: _noInternetMessage),
    'timeout': NetworkAppException(message: _noInternetMessage),
    'host': NetworkAppException(message: _msgServerError),
    'dns': NetworkAppException(message: _msgServerError),
    'unable to resolve': NetworkAppException(message: _msgServerError),
  };

  static final Map<String, AppException> _sharedPrefsPatterns = {
    '_casterror': SharedPrefsCastException(
      message: _msgCastError,
    ),
    'null check operator': SharedPrefsCastException(
      message: _msgCastError,
    ),
    'getinstance': SharedPrefsInitException(
      message: _msgInitError,
    ),
    'not initialized': SharedPrefsInitException(
      message: _msgInitError,
    ),
    'binding has not been initialized': SharedPrefsInitException(
      message: _msgInitError,
    ),
    'read': SharedPrefsOperationException(
      message: _msgReadError,
      operation: _readOperation,
    ),
    'get': SharedPrefsOperationException(
      message: _msgReadError,
      operation: _readOperation,
    ),
    'write': SharedPrefsOperationException(
      message: _msgWriteError,
      operation: _writeOperation,
    ),
    'set': SharedPrefsOperationException(
      message: _msgWriteError,
      operation: _writeOperation,
    ),
    'save': SharedPrefsOperationException(
      message: _msgWriteError,
      operation: _writeOperation,
    ),
  };

  static final Map<Type,
      AppException Function(dynamic)> _exceptionTypeHandlers = {
    HiveError: (error) {
      final hiveException = HiveAppExceptions(error: error.toString());
      return hiveException.getException();
    },
    DioException: (error) {
      final firebaseException = DioAppException(
          message: (error as DioException).message ?? 'DIO_ERROR'
      );
      return firebaseException.getException();
    },
    SocketException: (error) =>
        NetworkAppException(
          message: AppStrings.noInternetMessage,
        ),
    TimeoutException: (error) =>
        NetworkAppException(
          message: 'Timeout expired, please try again later',
        ),
    FormatException: (error) =>
        ClientAppException(
          message: 'Invalid data format',
        ),
  };

  static final RegExp _mergedPatternRegex = RegExp(
    '(${[
      ..._networkPatterns.keys,
      ..._sharedPrefsPatterns.keys,
    ].join('|')})',
    caseSensitive: false,
  );

  Iterable<String> get keys =>
      {..._networkPatterns, ..._sharedPrefsPatterns}.keys;

  bool get isKey => _exceptionTypeHandlers.containsKey(error);

  bool isUrlLauncherError() {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('url_launcher') ||
        error is PlatformException && errorStr.contains('url') ||
        error is MissingPluginException && errorStr.contains('url');
  }

  bool isSharedPrefsError() {
    final errorStr = error.toString().toLowerCase();
    return error is PlatformException &&
        (errorStr.contains('shared_preferences') ||
            errorStr.contains('sharedpreferences')) ||
        error is MissingPluginException &&
            errorStr.contains('shared_preferences') ||
        errorStr.contains('sharedpreferences') ||
        errorStr.contains('preferences') && errorStr.contains('instance');
  }

  AppException mapByTypePattern() {
    final exception = _exceptionTypeHandlers[error]!(error);
    return exception;
  }

  AppException? mapByStringPattern() {
    final errorMessage = error.toString().toLowerCase();
    final match = _mergedPatternRegex.firstMatch(errorMessage);
    if (match != null) {
      final matchedKey = match.group(0)!;
      return _networkPatterns[matchedKey] ??
          _sharedPrefsPatterns[matchedKey];
    }
    return null;
  }
}