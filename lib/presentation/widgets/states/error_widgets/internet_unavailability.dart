import 'package:flutter/material.dart';
import 'package:todays_news/constants/app_strings.dart';
import 'package:todays_news/presentation/constants/ui_sizes.dart';


class InternetUnavailability extends StatelessWidget {
  final String? message;

  const InternetUnavailability({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off),
            const SizedBox(width: UiSizes.smallSize),
            Text(message ?? AppStrings.noInternetMessage)
          ],
        )
    );
  }
}
