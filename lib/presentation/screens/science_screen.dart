import '../cubits/news_cubit.dart';
import 'package:flutter/material.dart';
import '../widgets/lists/list_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/home_screen_constants.dart';
import '../../../presentation/states/news_state.dart';
import 'connectivity_aware_screen_for_categories.dart';
import 'package:todays_news/presentation/widgets/states/initial_state_widget.dart';
import 'package:todays_news/presentation/widgets/states/loading_state_widget.dart';
import 'package:todays_news/presentation/widgets/states/error_widgets/error_state_widget.dart';


class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  static const screenIndex = HomeScreenConstants.screenScienceIndex;

  @override
  Widget build(BuildContext context) {
    return ConnectivityAwareScreenForCategories(
        screenIndex: screenIndex,
        child: BlocBuilder<NewsCubit, NewsState>(
            buildWhen: (previous, current) =>
            current.currentIndex == screenIndex,
            builder: (context, state) {
              final currentCubit = context.read<NewsCubit>();

              return state.when(
                  onInitial: () =>
                  const InitialStateWidget(
                      icon: Icons.science, category: 'science'),
                  onLoading: () =>
                  const LoadingStateWidget(),
                  onLoaded: (newTabData) =>
                      ListBuilder(
                          isLocked: false,
                          list: newTabData.products,
                          hasMore: newTabData.hasMore,
                          onScroll: () => currentCubit.getMoreData()),
                  onError: (error) =>
                      Center(
                          child: ErrorStateWidget(
                              error: error.message,
                              onRetry: () =>
                                  currentCubit.changeScreen(state.currentIndex)
                          )
                      )
              );
            }
        )
    );
  }
}