import 'package:todays_news/shared/cubit/states.dart';
import 'package:todays_news/model/dataModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../networks/remote/dio_helper.dart';
import 'package:flutter/material.dart';


Future<List<dynamic>> getCategoryData({
  required String category,
  required int pageSize,
  required int currentBusinessPage,
}) async {
  final response = await DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country': 'us',
        'category': category,
        'page': currentBusinessPage,
        'pageSize': pageSize,
        'sortBy': 'publishedAt',
        'apiKey': 'd1412c4e454044d481709aad5ec6c572',
      });
  return response.data['articles'];
}


Future<List<dynamic>> getSearchData({
  required String value,
  required int pageSize,
  required int currentSearchPage,
}) async {
  final response = await DioHelper.getData(
    url: 'v2/everything',
    query: {
      'q': value,
      'pageSize': pageSize,
      'page': currentSearchPage,
      'apiKey': 'd1412c4e454044d481709aad5ec6c572',
    },
  );
  return response.data['articles'];
}


Widget buildNewsItem(Article article, BuildContext context) {
  final String publishedAt = article.publishedAt;
  final String imageUrl = article.urlToImage;
  final String title = article.title;
  final String url = article.url;

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
            height: 120.0,
            width: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: SizedBox(
              height: 120.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
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

void launchURL(String url) async {
  final Uri uri = Uri.parse(Uri.encodeFull(url));
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

void navPush(BuildContext context, Widget widget){
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}


ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? scaffoldMessenger({
  required TodaysNewsStates state,
  required BuildContext context,
  required StatesKeys key,
}) {
  if (state is ErrorState && state.key == key) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!)));
  }
  return null;
}


class ListBuilder extends StatefulWidget {
  final List<Article> list;
  bool isLoadingMore;
  final VoidCallback onPressed;
  ListBuilder({
    required this.list,
    required this.isLoadingMore,
    required this.onPressed,
    super.key
  });

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollData);
  }

  void _onScrollData() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50.0 &&
        !widget.isLoadingMore) {
      widget.onPressed();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_onScrollData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return listBuilder(
        data: widget.list,
        isLoadingMore: widget.isLoadingMore,
        scrollController: _scrollController
    );
  }
}

Widget listBuilder({
  int? length,
  bool? isLoadingMore,
  required List<Article> data,
  ScrollController? scrollController
}) {
  return data.isNotEmpty ?
  ListView.builder(
    controller: scrollController,
    itemCount: length ?? data.length + 1,
    itemBuilder: (context, index) {
      if (index < data.length) {
        return buildNewsItem(data[index], context);
      } else {
        return Center(
          child: !isLoadingMore!
              ? const SizedBox() :
          const CircularProgressIndicator(),
        );
      }
    },
  ) : const Center(
    child: CircularProgressIndicator(),
  );
}
