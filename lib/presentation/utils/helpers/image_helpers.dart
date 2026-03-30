import 'package:flutter/material.dart';


class ImageHelpers {
  static const _qualityFactor = 1.0;

  static int calculateOptimalCacheHeight(BuildContext context, {
    required double targetHeight,
    double qualityFactor = _qualityFactor,
  }) {
    final pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    return (targetHeight * pixelRatio * qualityFactor).round();
  }

  static int calculateOptimalCacheWidth(BuildContext context, {
    required double targetWidth,
    double qualityFactor = _qualityFactor,
  }) {
    final pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    return (targetWidth * pixelRatio * qualityFactor).round();
  }
}