import 'package:todays_news/errors/exceptions/base/app_exception.dart';


class SharedPrefsAppException extends AppException {
  const SharedPrefsAppException({
    super.code,
    super.error,
    super.message,
    super.statusCode,
  });

  @override
  String toString() {
    return error.message;
  }
}

class SharedPrefsInitializeException extends SharedPrefsAppException {
  const SharedPrefsInitializeException({super.error}) : super(
    message: 'SharedPrefs not initialized. Please try again.',
    code: 'SHARED_PREFS_INITIALIZE_ERROR',
  );
}

class SharedPrefsSaveException extends SharedPrefsAppException {
  const SharedPrefsSaveException({super.error}) : super(
    message: 'Failed to save key. Please try again.',
    code: 'SHARED_PREFS_SAVE_ERROR',
  );
}

class SharedPrefsReadException extends SharedPrefsAppException {
  const SharedPrefsReadException({super.error}) : super(
    message: 'Failed to load key. Try again.',
    code: 'SHARED_PREFS_READ_ERROR');
}
