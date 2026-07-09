import 'package:flutter/material.dart';
import 'package:todays_news/presentation/constants/ui_sizes.dart';


class InitialStateWidget extends StatelessWidget {
  final IconData icon;
  final String category;
  final double iconSize;

  const InitialStateWidget({
    super.key,
    required this.icon,
    required this.category,
    this.iconSize = UiSizes.largeSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize),
          const SizedBox(height: 16.0),
          Text(
              'There is no news for $category',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}