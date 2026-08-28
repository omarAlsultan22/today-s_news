import 'package:todays_news/errors/exceptions/components_exception.dart';
import '../data/data_sources/local/cacheHelper.dart';
import '../data/data_sources/remote/dio_helper.dart';
import '../data/data_sources/local/hive.dart';
import '../di/service _locator.dart';


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

    _dio = sl<DioHelper>();
    _cacheHelper = sl<CacheHelper>();
    _hiveOperations = sl<HiveOperations>();

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