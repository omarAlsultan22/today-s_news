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


class ErrorHandler {

  // ==================== الدالة الرئيسية ====================

  static const String _noInternetMessage = 'لا يوجد اتصال بالإنترنت';

  static AppException handleException(dynamic error, {StackTrace? stackTrace}) {
    // تسجيل الخطأ (للتحليلات)
    _logError(error, stackTrace);

    // 1. أخطاء Dio
    if (error is DioException) {
      return _handleDioError(error);
    }

    // 2. أخطاء HTTP Client
    if (error is ClientException) {
      return _handleHttpError(error);
    }

    // 3. أخطاء Url Launcher
    if (_isUrlLauncherError(error)) {
      return _handleUrlLauncherError(error);
    }

    // 4. أخطاء SharedPreferences (بدون كلاس خاص)
    if (_isSharedPrefsError(error)) {
      return _handleSharedPrefsError(error, stackTrace);
    }

    // 5. أخطاء Hive (لديه كلاس خاص)
    if (error is HiveError) {
      return _handleHiveError(error, stackTrace);
    }

    // 6. أخطاء الشبكة الأساسية
    if (error is SocketException) {
      return NetworkException(message: _noInternetMessage);
    }

    if (error is TimeoutException) {
      return NetworkException(message: 'انتهت المهلة، يرجى المحاولة لاحقاً');
    }

    if (error is FormatException) {
      return ClientException(message: 'تنسيق البيانات غير صالح');
    }

    // 7. أي خطأ آخر
    return UnknownException(message: error.toString());
  }

  // ==================== دوال المساعدة للتحقق ====================

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
          message: ' أو انتهت المهلة$_noInternetMessage',
          code: _getDioErrorCode(error.type),
        );

      case DioExceptionType.badCertificate:
        return SecurityException(
          message: 'شهادة الأمان غير صالحة',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response?.statusCode);

      case DioExceptionType.cancel:
        return ClientException(
          message: 'تم إلغاء الطلب',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.unknown:
      default:
        return UnknownException(
          message: error.message ?? 'حدث خطأ غير متوقع',
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
    // 4xx - أخطاء العميل
      case 400:
      case 422:
        return ClientException(
          message: 'بيانات غير صالحة',
          code: 'BAD_REQUEST',
          statusCode: statusCode,
        );

      case 401:
      case 403:
        return SecurityException(
          message: statusCode == 401
              ? 'يرجى تسجيل الدخول مجدداً'
              : 'ليس لديك صلاحية للوصول',
          code: statusCode == 401 ? 'UNAUTHORIZED' : 'FORBIDDEN',
          statusCode: statusCode,
        );

      case 404:
      case 410:
        return ClientException(
          message: 'البيانات غير موجودة',
          code: 'NOT_FOUND',
          statusCode: statusCode,
        );

      case 409:
      case 412:
        return ClientException(
          message: 'تعارض في البيانات',
          code: 'CONFLICT',
          statusCode: statusCode,
        );

      case 429:
        return ClientException(
          message: 'تم تجاوز حد الطلبات، يرجى المحاولة لاحقاً',
          code: 'TOO_MANY_REQUESTS',
          statusCode: statusCode,
        );

    // 5xx - أخطاء الخادم
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'خطأ في الخادم، يرجى المحاولة لاحقاً',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
        );

      default:
        return ServerException(
          message: 'خطأ في الخادم: $statusCode',
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
      return NetworkException(message: 'لا يمكن الوصول إلى الخادم');
    }

    return ClientException(message: 'خطأ في طلب HTTP: ${error.message}');
  }

  // ==================== Url Launcher Error Handler ====================

  static AppException _handleUrlLauncherError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('platformexception')) {
      if (errorString.contains('activitynotfound') ||
          errorString.contains('cannotopenurl')) {
        return CantLaunchUrlAppException(
            message: 'لا يوجد تطبيق لفتح هذا الرابط');
      }
      return PlatformUrlAppException(message: 'حدث خطأ في النظام');
    }

    if (errorString.contains('missingpluginexception')) {
      return MissingPluginUrlAppException(message: 'مشكلة في تهيئة التطبيق');
    }

    if (errorString.contains('formatexception')) {
      return InvalidUrlAppException(message: 'صيغة الرابط غير صحيحة');
    }

    return UrlLauncherAppException(message: 'فشل فتح الرابط');
  }

  // ==================== SharedPreferences Error Handler ====================

  static AppException _handleSharedPrefsError(dynamic error,
      StackTrace? stackTrace) {
    final errorStr = error.toString().toLowerCase();

    // PlatformException (الأكثر شيوعاً)
    if (error is PlatformException) {
      final message = error.message?.toLowerCase() ?? '';

      if (message.contains('streamcorrupted') ||
          message.contains('invalid stream header')) {
        return SharedPrefsInitException(
          message: 'ملف التخزين المحلي تالف، سيتم إعادة تهيئته',
          platformCode: error.code,
          stackTrace: stackTrace,
        );
      }

      if (message.contains('channel-error') ||
          message.contains('unable to establish connection')) {
        return SharedPrefsPlatformException(
          message: 'مشكلة في الاتصال مع نظام التخزين',
          platformCode: error.code,
          stackTrace: stackTrace,
        );
      }

      return SharedPrefsPlatformException(
        message: error.message ?? 'خطأ في منصة التخزين المحلي',
        platformCode: error.code,
        stackTrace: stackTrace,
      );
    }

    // MissingPluginException
    if (error is MissingPluginException) {
      return SharedPrefsPluginException(
        message: 'مشكلة في تهيئة التخزين المحلي، يرجى إعادة تشغيل التطبيق',
        stackTrace: stackTrace,
      );
    }

    // _CastError (خطأ في تحويل النوع)
    if (errorStr.contains('_casterror') ||
        errorStr.contains('null check operator')) {
      return SharedPrefsCastException(
        message: 'خطأ في نوع البيانات المخزنة',
        stackTrace: stackTrace,
      );
    }

    // أخطاء التهيئة العامة
    if (errorStr.contains('getinstance') ||
        errorStr.contains('not initialized') ||
        errorStr.contains('binding has not been initialized')) {
      return SharedPrefsInitException(
        message: 'لم يتم تهيئة التخزين المحلي بشكل صحيح',
        stackTrace: stackTrace,
      );
    }

    // أخطاء القراءة/الكتابة
    if (errorStr.contains('read') || errorStr.contains('get')) {
      return SharedPrefsOperationException(
        message: 'فشل قراءة البيانات من التخزين المحلي',
        operation: 'read',
        stackTrace: stackTrace,
      );
    }

    if (errorStr.contains('write') || errorStr.contains('set') ||
        errorStr.contains('save')) {
      return SharedPrefsOperationException(
        message: 'فشل حفظ البيانات في التخزين المحلي',
        operation: 'write',
        stackTrace: stackTrace,
      );
    }

    // أي خطأ آخر
    return SharedPrefsOperationException(
      message: 'خطأ في التخزين المحلي: ${error.toString()}',
      stackTrace: stackTrace,
    );
  }

  // ==================== Hive Error Handler ====================

  static AppException _handleHiveError(dynamic error, StackTrace? stackTrace) {
    final errorString = error.toString().toLowerCase();

    // أخطاء الـ Box
    if (errorString.contains('box has already been closed')) {
      return HiveBoxException(
        message: 'محاولة الوصول إلى قاعدة بيانات مغلقة',
        code: 'HIVE_BOX_CLOSED',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('box not found') ||
        errorString.contains('box doesn\'t exist')) {
      return HiveBoxException(
        message: 'قاعدة البيانات غير موجودة',
        code: 'HIVE_BOX_NOT_FOUND',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('null') && errorString.contains('box')) {
      return HiveBoxException(
        message: 'لم يتم تهيئة قاعدة البيانات بشكل صحيح',
        code: 'HIVE_BOX_NULL',
        stackTrace: stackTrace,
      );
    }

    // أخطاء فتح الـ Box
    if (errorString.contains('openbox') ||
        errorString.contains('failed to open')) {
      final boxName = _extractBoxName(errorString);
      return HiveOpenBoxException(
        boxName: boxName ?? 'unknown',
        message: 'فشل فتح قاعدة البيانات: ${error.toString()}',
        stackTrace: stackTrace,
      );
    }

    // أخطاء ملفات Hive
    if (errorString.contains('filesystemexception') ||
        errorString.contains('file closed')) {
      return HiveOperationException(
        message: 'حدث خطأ في ملف قاعدة البيانات',
        operation: 'file_system',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('compaction')) {
      return HiveOperationException(
        message: 'حدث خطأ أثناء ضغط قاعدة البيانات',
        operation: 'compaction',
        stackTrace: stackTrace,
      );
    }

    // أخطاء التشفير
    if (errorString.contains('encryption') ||
        errorString.contains('decryption')) {
      return HiveOperationException(
        message: 'خطأ في تشفير/فك تشفير قاعدة البيانات',
        operation: 'encryption',
        stackTrace: stackTrace,
      );
    }

    // أخطاء عمليات CRUD
    if (errorString.contains('put')) {
      return HiveOperationException(
        message: 'فشل حفظ البيانات في قاعدة البيانات',
        operation: 'put',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('get')) {
      return HiveOperationException(
        message: 'فشل قراءة البيانات من قاعدة البيانات',
        operation: 'get',
        stackTrace: stackTrace,
      );
    }

    if (errorString.contains('delete')) {
      return HiveOperationException(
        message: 'فشل حذف البيانات من قاعدة البيانات',
        operation: 'delete',
        stackTrace: stackTrace,
      );
    }

    // أي خطأ آخر في Hive
    if (error is HiveError) {
      return HiveOperationException(
        message: error.message,
        stackTrace: stackTrace,
      );
    }

    return HiveCacheException(
      message: 'خطأ في التخزين المحلي: ${error.toString()}',
      stackTrace: stackTrace,
    );
  }

  // ==================== دوال مساعدة ====================

  static String? _extractBoxName(String errorString) {
    // إنشاء الـ Regex بشكل منفصل وآمن
    const pattern = r'box\s+["'']?(\w+)["'']?';
    final regex = RegExp(pattern);
    final match = regex.firstMatch(errorString);
    return match?.group(1);
  }

  static void _logError(dynamic error, StackTrace? stackTrace) {
    // للتتبع والتحليلات
    print('════════════════════════════════════════');
    print('❌ Error caught: ${error.runtimeType}');
    print('Message: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
    print('════════════════════════════════════════');
  }
}
