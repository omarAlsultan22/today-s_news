import 'package:cached_network_image/cached_network_image.dart';
import '../../../../data/models/article_Model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/helpers/image_helpers.dart';
import 'package:flutter/material.dart';


class BuildNewsItemLayout extends StatelessWidget {
  final Article article;
  BuildNewsItemLayout(this.article,{super.key});

  late String publishedAt = article.publishedAt;
  late String imageUrl = article.urlToImage;
  late String title = article.title;
  late String url = article.url;

  static const _height120 = 120.0;

  void launchURL(String url) async {
    final Uri uri = Uri.parse(Uri.encodeFull(url));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (url.isNotEmpty) {
          launchURL(url);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              height: _height120,
              width: _height120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                memCacheHeight: ImageHelpers.calculateOptimalCacheHeight(
                    context,
                    targetHeight: _height120,
                    qualityFactor: 1.5
                ),
                memCacheWidth: ImageHelpers.calculateOptimalCacheWidth(
                    context,
                    targetWidth: _height120
                ),
                errorWidget: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: _height120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    Text(publishedAt)
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


