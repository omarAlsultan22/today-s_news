import '../base/app_exception.dart';


class HiveAppExceptions extends AppException{
  const HiveAppExceptions({
    super.code,
    super.error,
    super.message,
  });
}

class HiveInitializeException extends HiveAppExceptions {
  const HiveInitializeException({super.error}) : super(
    message: 'HiveOperations not initialized. Call init() first.',
    code: 'HIVE_INITIALIZE_ERROR',
  );
}

class HiveSaveException extends HiveAppExceptions {
  const HiveSaveException({super.error}) : super(
    message: 'Failed to save data. Please try again.',
    code: 'HIVE_SAVE_ERROR',
  );
}

class HiveReadException extends HiveAppExceptions {
  const HiveReadException({super.error}) : super(
      message: 'Failed to load data. Try again.',
      code: 'HIVE_READ_ERROR');
}

class HiveClearException extends HiveAppExceptions {
  const HiveClearException({super.error}) : super(
    message: 'Failed to delete data. Try again.',
    code: 'HIVE_CLEAR_ERROR',
  );
}
