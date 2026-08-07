import 'package:todays_news/presentation/widgets/build_snack_bar.dart';
import 'package:todays_news/presentation/constants/ui_sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:todays_news/constants/app_colors.dart';
import '../../../../data/models/article_Model.dart';
import '../../utils/helpers/image_helpers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/app_durations.dart';
import 'package:flutter/material.dart';
import '../news_image.dart';


class BuildNewsItemLayout extends StatelessWidget {
  final Article article;

  const BuildNewsItemLayout(this.article, {super.key});

  static const _largeSpacing = 120.0;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _scaffoldMessenger({
    required String message,
    required BuildContext context,
    required Color backgroundColor
  }) {
    return BuildSnackBar.show(
        message: message,
        context: context,
        backgroundColor: backgroundColor);
  }

  void launchURL({required String url, required BuildContext context}) async {
    final Uri uri = Uri.parse(Uri.encodeFull(url));
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication).timeout(
            AppDurations.seconds);
      } else {
        _scaffoldMessenger(
            context: context,
            message: 'Could not launch $url',
            backgroundColor: AppColors.red);
      }
    }
    catch (e) {
      _scaffoldMessenger(
          context: context,
          message: e.toString(),
          backgroundColor: AppColors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (article.urlIsNotEmpty) {
          launchURL(url: article.url, context: context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(UiSizes.mediumSize),
        child: Row(
          children: [
            Container(
              height: _largeSpacing,
              width: _largeSpacing,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UiSizes.smallSize),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: article.urlToImage,
                cacheManager: CustomCacheManager(),
                memCacheHeight: ImageHelpers.calculateOptimalCacheHeight(
                    context,
                    targetHeight: _largeSpacing,
                    qualityFactor: 1.5
                ),
                memCacheWidth: ImageHelpers.calculateOptimalCacheWidth(
                    context,
                    targetWidth: _largeSpacing
                ),
                errorWidget: (context, error, stackTrace) =>
                const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: UiSizes.mediumSize),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: _largeSpacing,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: UiSizes.mediumSize,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    Text(article.publishedAt)
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15.0),
          ],
        ),
      ),
    );
  }
}




