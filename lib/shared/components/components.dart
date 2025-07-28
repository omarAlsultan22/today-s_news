import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../modules/cubit.dart';
import '../../modules/states.dart';

Widget buildNewsItem(Map<String, dynamic> article, BuildContext context) {
  final String imageUrl = article['urlToImage'] ??
      'https://placeholder.com/image';
  final String publishedAt = article['publishedAt'] ?? 'No Title';
  final String title = article['title'] ?? 'No Title';
  final String url = article['url'] ?? '';

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
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Container(
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


class ConditionalBuilder extends StatefulWidget {
  final List<dynamic> list;
  final bool isLoadingMore;
  final VoidCallback onPressed;
  final int? length;
  const ConditionalBuilder({
    required this.list,
    required this.isLoadingMore,
    required this.onPressed,
    this.length,
    super.key
  });

  @override
  State<ConditionalBuilder> createState() => _ConditionalBuilderState();
}

class _ConditionalBuilderState extends State<ConditionalBuilder> {
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
    return conditionalBuilder(
      list: widget.list,
      isLoadingMore: widget.isLoadingMore,
      scrollController: _scrollController
    );
  }
}

Widget conditionalBuilder({
  int? length,
  bool? isLoadingMore,
  required List<dynamic> list,
  ScrollController? scrollController
}) {
  return BlocConsumer<TodayNewsCubit, TodayNewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        if (list.isEmpty) {
          return const Center(
              child: CircularProgressIndicator());
        }
        return Scaffold(
          body: ListView.builder(
            controller: scrollController,
            itemCount: length ?? list.length + 1,
            itemBuilder: (context, index) {
              if (index < list.length) {
                return buildNewsItem(list[index], context);
              } else {
                return Center(
                  child: !isLoadingMore!
                      ? const CircularProgressIndicator()
                      : const SizedBox(),
                );
              }
            },
          ),
        );
      });
}