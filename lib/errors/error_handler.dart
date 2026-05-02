import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'exceptions/client_exception.dart';
import 'exceptions/server_exception.dart';
import 'exceptions/cache_exceptions.dart';
import 'exceptions/unknown_exception.dart';
import 'exceptions/network_exception.dart';
import 'exceptions/base/app_exception.dart';
import 'exceptions/security_exception.dart';
import 'exceptions/url_launcher_exceptions.dart';
import 'package:todays_news/constants/app_strings.dart';


class ErrorHandler {

  // ==================== Main Function ====================

  static const String _noInternetMessage = AppStrings.noInternetMessage;

  static AppException handleException(dynamic error, {StackTrace? stackTrace}) {
    // Log error (for analytics)
    _logError(error, stackTrace);

    // 1. Dio Errors
    if (error is DioException) {
      return _handleDioError(error);
    }

    // 2. HTTP Client Errors
    if (error is ClientException) {
      return _handleHttpError(error);
    }

    // 3. Url Launcher Errors
    if (_isUrlLauncherError(error)) {
      return _handleUrlLauncherError(error);
    }

    // 4. SharedPreferences Errors (without specific class)
    if (_isSharedPrefsError(error)) {
      return _handleSharedPrefsError(error, stackTrace);
    }

    // 5. Hive Errors (has its own class)
    if (error is HiveError) {
      return _handleHiveError(error, stackTrace);
    }

    // 6. Basic Network Errors
    if (error is SocketException) {
      return NetworkException(message: _noInternetMessage);
    }

    if (error is TimeoutException) {
      return NetworkException(message: 'Timeout expired, please try again later');
    }

    if (error is FormatException) {
      return ClientException(message: 'Invalid data format');
    }

    // 7. Any other error
    return UnknownException(message: error.toString());
  }

  // ==================== Helper Functions for Checking ====================

  static bool _isUrlLauncherError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('url_launcher') ||
        error is PlatformException && errorStr.contains('url') ||
        error is MissingPluginException && errorStr.contains('url');
  }

  static bool _isSharedPrefsError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return error is PlatformException &&
        (errorStr.contains('shared_preferences') ||
            errorStr.contains('sharedpreferences')) ||
        error is MissingPluginException &&
            errorStr.contains('shared_preferences') ||
        errorStr.contains('sharedpreferences') ||
        errorStr.contains('preferences') && errorStr.contains('instance');
  }

  // ==================== Dio Error Handler ====================

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(
          message: '$_noInternetMessage or timeout expired',
          code: _getDioErrorCode(error.type),
        );

      case DioExceptionType.badCertificate:
        return SecurityException(
          message: 'Invalid security certificate',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response?.statusCode);

      case DioExceptionType.cancel:
        return ClientException(
          message: 'Request cancelled',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.unknown:
      default:
        return UnknownException(
          message: error.message ?? 'An unexpected error occurred',
          code: 'UNKNOWN_DIO_ERROR',
        );
    }
  }

  static String _getDioErrorCode(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return 'CONNECTION_TIMEOUT';
      case DioExceptionType.sendTimeout:
        return 'SEND_TIMEOUT';
      case DioExceptionType.receiveTimeout:
        return 'RECEIVE_TIMEOUT';
      case DioExceptionType.connectionError:
        return 'CONNECTION_ERROR';
      default:
        return 'DIO_ERROR';
    }
  }

  static AppException _handleBadResponse(int? statusCode) {
    switch (statusCode) {
    // 4xx - Client Errors
      case 400:
      case 422:
        return ClientException(
          message: 'Invalid data',
          code: 'BAD_REQUEST',
          statusCode: statusCode,
        );

      case 401:
      case 403:
        return SecurityException(
          message: statusCode == 401
              ? 'Please login again'
              : 'You do not have permission to access',
          code: statusCode == 401 ? 'UNAUTHORIZED' : 'FORBIDDEN',
          statusCode: statusCode,
        );

      case 404:
      case 410:
        return ClientException(
          message: 'Data not found',
          code: 'NOT_FOUND',
          statusCode: statusCode,
        );

      case 409:
      case 412:
        return ClientException(
          message: 'Data conflict',
          code: 'CONFLICT',
          statusCode: statusCode,
        );

      case 429:
        return ClientException(
          message: 'Request limit exceeded, please try again later',
          code: 'TOO_MANY_REQUESTS',
          statusCode: statusCode,
        );

    // 5xx - Server Errors
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'Server error, please try again later',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
        );

      default:
        return ServerException(
          message: 'Server error: $statusCode',
          statusCode: statusCode,
        );
    }
  }

  // ==================== HTTP Error Handler ====================

  static AppException _handleHttpError(ClientException error) {
    final message = error.message.toLowerCase();

    if (message.contains('socket') ||
        message.contains('connection') ||
        message.contains('network') ||
        message.contains('timeout')) {
      return NetworkException(message: _noInternetMessage);
    }

    if (message.contains('host') ||
        message.contains('dns') ||
        message.contains('unable to resolve')) {
      return NetworkException(message: 'Cannot reach the server');
    }

    return ClientException(message: 'HTTP request error: ${error.message}');
  }

  // ==================== Url Launcher Error Handler ====================

  static AppException _handleUrlLauncherError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('platformexception')) {
      if (errorString.contains('activitynotfound') ||
          errorString.contains('cannotopenurl')) {
        return CantLaunchUrlAppException(
            message: 'No application available to open this link');
      }
      return PlatformUrlAppException(message: 'System error occurred');
    }

    if (errorString.contains('missingpluginexception')) {
      return MissingPluginUrlAppException(message: 'Application initialization issue');
    }

    if (errorString.contains('formatexception')) {
      return InvalidUrlAppException(message: 'Invalid URL format');
    }

    return UrlLauncherAppException(message: 'Failed to open link');
  }

  // ==================== SharedPreferences Error Handler ====================

  static AppException _handleSharedPrefsError(dynamic error,
      StackTrace? stackTrace) {
    final errorStr = error.toString().toLowerCase();

    // PlatformException (most common)
    if (error is PlatformException) {
      final message = error.message?.toLowerCase() ?? '';

      if (message.contains('streamcorrupted') ||
          message.contains('invalid stream header')) {
        return SharedPrefsInitException(
          message: 'Local storage file is corrupted, will be reinitialized',
          platformCode: error.code,
          stackTrace: stackTrace,
        );
      }

      if (message.contains('channel-error') ||
          message.contains('unable to establish connection')) {
        return SharedPrefsPlatformException(
          message: 'Connection issue with storage system',
          platformCode: error.code,
          stackTrace: stackTrace,
        );
      }

      return SharedPrefsPlatformException(
        message: error.message ?? 'Local storage platform error',
        platformCode: error.code,
        stackTrace: stackTrace,
      );
    }

    // MissingPluginException
    if (error is MissingPluginException) {
      return SharedPrefsPluginException(
        message: 'Local storage initialization issue, please restart the application',
        stackTrace: stackTrace,
      );
    }

    // _CastError (type conversion error)
    if (errorStr.contains('_casterror') ||
        errorStr.contains('null check operator')) {
      return SharedPrefsCastException(
        message: 'Stored data type error',
        stackTrace: stackTrace,
      );
    }

    // General initialization errors
    if (errorStr.contains('getinstance') ||
        errorStr.contains('not initialized') ||
        errorStr.contains('binding has not been initialized')) {
      return SharedPrefsInitException(
        message: 'Local storage not properly initialized',
        stackTrace: stackTrace,
      );
    }

    // Read/write errors
    if (errorStr.contains('read') || errorStr.contains('get')) {
      return SharedPrefsOperationException(
        message: 'Failed to read data from local storage',
        operation: 'read',
        stackTrace: stackTrace,
      );
    }

    if (errorStr.contains('write') || errorStr.contains('set') ||
        errorStr.contains('save')) {
      return SharedPrefsOperationException(
        message: 'Failed to save data to local storage',
        operation: 'write',
        stackTrace: stackTrace,
      );
    }

    // Any other error
    return SharedPrefsOperationException(
      message: 'Local storage error: ${error.toString()}',
      stackTrace: stackTrace,
    );
  }

  // ==================== Hive Error Handler ====================

  static AppException _handleHiveError(dynamic error, StackTrace? stackTrace) {
    final errorString = error.toString().toLowerCase();

    // Box Errors
    if (errorString.contains('box has already been closed')) {
      return HiveBoxException(
        message: 'Attempting to access a closed database',
        code: 'HIVE_BOX_CLOSED',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('box not found') ||
        errorString.contains('box doesn\'t exist')) {
      return HiveBoxException(
        message: 'Database does not exist',
        code: 'HIVE_BOX_NOT_FOUND',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('null') && errorString.contains('box')) {
      return HiveBoxException(
        message: 'Database not properly initialized',
        code: 'HIVE_BOX_NULL',
        stackTrace: stackTrace,
      );
    }

    // Box Opening Errors
    if (errorString.contains('openbox') ||
        errorString.contains('failed to open')) {
      final boxName = _extractBoxName(errorString);
      return HiveOpenBoxException(
        boxName: boxName ?? 'unknown',
        message: 'Failed to open database: ${error.toString()}',
        stackTrace: stackTrace,
      );
    }

    // Hive File Errors
    if (errorString.contains('filesystemexception') ||
        errorString.contains('file closed')) {
      return HiveOperationException(
        message: 'Database file error occurred',
        operation: 'file_system',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('compaction')) {
      return HiveOperationException(
        message: 'Error occurred while compacting database',
        operation: 'compaction',
        stackTrace: stackTrace,
      );
    }

    // Encryption Errors
    if (errorString.contains('encryption') ||
        errorString.contains('decryption')) {
      return HiveOperationException(
        message: 'Database encryption/decryption error',
        operation: 'encryption',
        stackTrace: stackTrace,
      );
    }

    // CRUD Operation Errors
    if (errorString.contains('put')) {
      return HiveOperationException(
        message: 'Failed to save data to database',
        operation: 'put',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('get')) {
      return HiveOperationException(
        message: 'Failed to read data from database',
        operation: 'get',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('delete')) {
      return HiveOperationException(
        message: 'Failed to delete data from database',
        operation: 'delete',
        stackTrace: stackTrace,
      );
    }

    // Any other Hive error
    if (error is HiveError) {
      return HiveOperationException(
        message: error.message,
        stackTrace: stackTrace,
      );
    }

    return HiveCacheException(
      message: 'Local storage error: ${error.toString()}',
      stackTrace: stackTrace,
    );
  }

  // ==================== Helper Functions ====================

  static String? _extractBoxName(String errorString) {
    // Create regex separately and safely
    const pattern = r'box\s+["'']?(\w+)["'']?';
    final regex = RegExp(pattern);
    final match = regex.firstMatch(errorString);
    return match?.group(1);
  }

  static void _logError(dynamic error, StackTrace? stackTrace) {
    // For tracking and analytics
    print('════════════════════════════════════════');
    print('❌ Error caught: ${error.runtimeType}');
    print('Message: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
    print('════════════════════════════════════════');
  }
}