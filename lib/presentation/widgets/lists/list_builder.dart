import 'package:flutter/material.dart';
import '../layouts/build_news_item_layout.dart';
import '../../../data/models/article_Model.dart';
import 'package:todays_news/presentation/constants/ui_sizes.dart';


class ListBuilder extends StatefulWidget {
  bool isLocked;
  final List<Article> list;
  final bool hasMore;
  final VoidCallback onScroll;
  ListBuilder({
    super.key,
    required this.list,
    required this.hasMore,
    required this.onScroll,
    required this.isLocked
  });

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  final ScrollController _scrollController = ScrollController();
  static const _smallSpacing = UiSizes.largeSize;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollData);
  }

  void _onScrollData() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - _smallSpacing &&
        widget.hasMore && !widget.isLocked) {
      widget.isLocked = true;
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
          return BuildNewsItemLayout(data[index]);
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