import 'package:flutter/material.dart';
import 'package:todays_news/core/constants/app_constants.dart';


class ConnectionErrorStateWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ConnectionErrorStateWidget({
    this.onRetry,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off),
            SizedBox(width: AppConstants.smallSize),
            Text('No Internet Connection')
          ],
        ),
      ],
    );
  }
}
