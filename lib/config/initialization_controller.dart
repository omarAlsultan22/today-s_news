import '../data/data_sources/local/hive.dart';
import '../data/data_sources/local/cacheHelper.dart';
import '../data/data_sources/remote/dio_helper.dart';


class InitializationController {
  static final InitializationController _instance =
  InitializationController._internal();

  factory InitializationController() => _instance;

  InitializationController._internal();

  late final DioHelper dio;
  late final CacheHelper cacheHelper;
  late final HiveOperations hiveOperations;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    dio = DioHelper();
    cacheHelper = CacheHelper();
    hiveOperations = HiveOperations(cacheHelper: cacheHelper);

    await Future.wait<void>([
      dio.init(),
      cacheHelper.init(),
      hiveOperations.init()
    ]);

    _isInitialized = true;
  }

  Future<void> retryInit() async {
    await Future.wait<void>([
      dio.init(),
      cacheHelper.init(),
      hiveOperations.init(),
    ]);
  }
}