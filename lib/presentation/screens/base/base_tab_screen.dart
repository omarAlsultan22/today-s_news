import '../../cubits/news_cubit.dart';
import '../../states/news_state.dart';
import 'package:flutter/cupertino.dart';
import '../../mixins/tab_listener_mixin.dart';
import '../../widgets/lists/list_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/states/initial_state_widget.dart';
import '../../widgets/states/loading_state_widget.dart';


abstract class BaseTabScreen extends StatefulWidget {
  const BaseTabScreen({super.key});

  IconData get icon;

  String get category;

  int get screenIndex;
}

abstract class BaseTabScreenState<T extends BaseTabScreen>
    extends State<T> with TabListenerMixin {

  @override
  void initState() {
    super.initState();
    initializeTabListener(widget.screenIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) => handleTabListener(state),
      listenWhen: (previous, current) => current.isConnected != null,
      buildWhen: (previous, current) =>
      current.currentTabIndex == widget.screenIndex,
      builder: (context, state) {
        return state.when(
          onInitial: () =>
              InitialStateWidget(
                icon: widget.icon,
                category: widget.category,
              ),
          onLoading: () => const LoadingStateWidget(),
          onLoaded: (data) =>
              ListBuilder(
                isLocked: false,
                list: data.products,
                hasMore: data.hasMore,
                messageResult: data.messageResult,
                onScroll: () => cubit.loadMoreData(),
              ),
          onError: (error) =>
              error.buildErrorWidget(
                onRetry: () =>
                    cubit.switchTabAndLoadData(
                      index: widget.screenIndex,
                    ),
              ),
        );
      },
    );
  }
}