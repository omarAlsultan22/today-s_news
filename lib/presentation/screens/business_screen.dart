import '../cubits/news_cubit.dart';
import 'package:flutter/material.dart';
import '../widgets/lists/list_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/states/news_state.dart';
import 'connectivity_aware_screen_for_categories.dart';
import 'package:todays_news/presentation/widgets/states/initial_state_widget.dart';
import 'package:todays_news/presentation/widgets/states/loading_state_widget.dart';


class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  static const _screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ConnectivityAwareScreenForCategories(
        screenIndex: _screenIndex,
        child: BlocBuilder<NewsCubit, NewsState>(
            buildWhen: (previous, current) =>
            current.currentTabIndex == _screenIndex,
            builder: (context, state) {
              final currentCubit = context.read<NewsCubit>();

              return state.when(
                  onInitial: () =>
                  const InitialStateWidget(
                      icon: Icons.business, category: 'business'),
                  onLoading: () =>
                  const LoadingStateWidget(),
                  onLoaded: (newTabData) =>
                      ListBuilder(
                          isLocked: false,
                          list: newTabData.products,
                          hasMore: newTabData.hasMore,
                          onScroll: () => currentCubit.loadMoreData()),
                  onError: (error) =>
                      error.buildErrorWidget(
                          onRetry: () => currentCubit.changeScreen
                      )
              );
            }
        )
    );
  }
}

