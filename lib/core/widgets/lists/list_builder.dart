import 'package:flutter/material.dart';
import '../../../data/models/article_Model.dart';
import '../../../features/news/widgets/build_news_item.dart';


class ListBuilder extends StatefulWidget {
  final List<Article> list;
  final bool isLoadingMore;
  final VoidCallback onPressed;
  const ListBuilder({
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
    return _listBuilder(
        data: widget.list,
        isLoadingMore: widget.isLoadingMore,
        scrollController: _scrollController
    );
  }

  Widget _listBuilder({
    final int? length,
    final bool? isLoadingMore,
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
            child: isLoadingMore!
                ? const SizedBox() :
            const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}