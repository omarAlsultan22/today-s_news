import 'package:flutter/material.dart';


class NoInternetConnection extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetConnection({this.onRetry, super.key});

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
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off),
            SizedBox(width: 10.0),
            Text('No internet connection')
          ],
        ),
        onRetry != null ? retryButton() : const SizedBox()
      ],
    );
  }
}
