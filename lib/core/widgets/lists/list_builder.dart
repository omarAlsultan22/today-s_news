import 'package:flutter/material.dart';
import '../../../data/models/article_Model.dart';
import '../../../features/news/widgets/build_news_item.dart';


class ListBuilder extends StatefulWidget {
  final List<Article> list;
  final bool hasMore;
  final VoidCallback onScroll;
  const ListBuilder({
    required this.list,
    required this.hasMore,
    required this.onScroll,
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
        !widget.hasMore) {
      widget.onScroll();
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
    return _listBuilder(
        data: widget.list,
        hasMore: widget.hasMore,
        scrollController: _scrollController
    );
  }

  Widget _listBuilder({
    final int? length,
    final bool? hasMore,
    required List<Article> data,
    ScrollController? scrollController
  }) {


    return ListView.builder(
      controller: scrollController,
      itemCount: length ?? data.length + 1,
      itemBuilder: (context, index) {
        if (index < data.length) {
          return BuildNewsItem(data[index]);
        } else {
          return Center(
            child: hasMore!
                ? const CircularProgressIndicator() :
            const SizedBox(),
          );
        }
      },
    );
  }
}