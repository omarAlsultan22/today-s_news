import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class CustomCacheManager extends CacheManager {
  static const String key = 'my_image_cache';

  static final CustomCacheManager _instance = CustomCacheManager._internal();

  factory CustomCacheManager() => _instance;

  CustomCacheManager._internal()
      : super(
    Config(
      key,
      stalePeriod: const Duration(hours: 24),
      maxNrOfCacheObjects: 150,
    ),
  );
}