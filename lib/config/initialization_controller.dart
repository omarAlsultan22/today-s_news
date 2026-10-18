import 'package:todays_news/errors/exceptions/components_exception.dart';
import '../data/data_sources/local/cache_helper_impl.dart';
import '../data/data_sources/remote/dio_helper_impl.dart';
import '../data/data_sources/local/hive_operations_impl.dart';
import '../di/service _locator.dart';


class InitializationController {
  static final InitializationController _instance =
  InitializationController._internal();

  factory InitializationController() => _instance;

  InitializationController._internal();

  late final DioHelperImpl _dio;
  late final CacheHelperImpl _cacheHelper;
  late final HiveOperationsImpl _hiveOperations;

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

    _dio = sl<DioHelperImpl>();
    _cacheHelper = sl<CacheHelperImpl>();
    _hiveOperations = sl<HiveOperationsImpl>();

    try {
      await _initializeServices();
    }
    catch(e){
      throw ComponentsException(error: e);
    }

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