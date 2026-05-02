import 'package:flutter/material.dart';
import 'package:todays_news/presentation/constants/ui_sizes.dart';


class ErrorStateWidget extends StatelessWidget {
  final String? error;
  final String? buttonText;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.error,
    this.onRetry,
    this.buttonText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: UiSizes.largeSize),
            child: Text('Error: $error'),
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