import 'package:flutter/material.dart';
import 'package:todays_news/presentation/constants/ui_sizes.dart';


class InternetUnavailability extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const InternetUnavailability({
    required this.message,
    this.onRetry,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off),
            const SizedBox(width: UiSizes.smallSize),
            Text(message)
          ],
        ),
      ],
    );
  }
}
