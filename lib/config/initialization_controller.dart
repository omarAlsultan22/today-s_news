import '../data/data_sources/local/hive.dart';
import '../data/data_sources/local/cacheHelper.dart';
import '../data/data_sources/remote/dio_helper.dart';


class InitializationController {
  static final InitializationController _instance =
  InitializationController._internal();

  factory InitializationController() => _instance;

  InitializationController._internal();

  late final DioHelper _dio;
  late final CacheHelper _cacheHelper;
  late final HiveOperations _hiveOperations;

  bool _isInitialized = false;

  Future<void> _initializeServices() async {
    await Future.wait<void>([
      _dio.init(),
      _cacheHelper.init(),
      _hiveOperations.init()
    ]);
  }

  Future<void> init() async {
    if (_isInitialized) return;

    _dio = DioHelper();
    _cacheHelper = CacheHelper();
    _hiveOperations = HiveOperations(cacheHelper: _cacheHelper);

    await _initializeServices();

    _isInitialized = true;
  }

  Future<void> retryInit() async {
    await Future.wait<void>([
      _dio.init(),
      _cacheHelper.init(),
      _hiveOperations.init(),
    ]);
  }
}