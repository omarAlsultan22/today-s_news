import 'package:flutter/material.dart';


class NoInternetConnection extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const NoInternetConnection({required this.error, this.onRetry, super.key});

  Widget retryButton() {
    return Column(
      children: [
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off),
            const SizedBox(width: 10.0),
            Text(error)
          ],
        ),
        onRetry != null ? retryButton() : const SizedBox()
      ],
    );
  }
}
