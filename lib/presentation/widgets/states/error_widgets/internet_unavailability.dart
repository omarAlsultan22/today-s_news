import 'package:flutter/material.dart';
import 'package:todays_news/constants/app_strings.dart';
import 'package:todays_news/presentation/constants/ui_sizes.dart';


class InternetUnavailability extends StatelessWidget {
  final String? message;
  final String? buttonText;
  final VoidCallback? onRetry;

  const InternetUnavailability({
    super.key,
    this.onRetry,
    required this.message,
    this.buttonText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: UiSizes.largeSize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off),
                const SizedBox(width: UiSizes.smallSize),
                Text(message ?? AppStrings.noInternetMessage)
              ],
            ),
          ),
          const SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(buttonText!),
          ),
        ],
      ),
    );
  }
}
