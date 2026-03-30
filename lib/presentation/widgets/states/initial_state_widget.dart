import 'package:flutter/material.dart';
import 'package:todays_news/core/constants/app_constants.dart';


class InitialStateWidget extends StatelessWidget {
  final IconData icon;
  final String category;
  final double iconSize;
  final TextStyle? textStyle;

  const InitialStateWidget({
    super.key,
    required this.icon,
    required this.category,
    this.iconSize = AppConstants.largeSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize),
          const SizedBox(height: 16),
          Text(
            'There is no news for $category',
            style: textStyle ?? Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}