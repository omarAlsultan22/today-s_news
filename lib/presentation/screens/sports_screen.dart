import '../cubits/news_cubit.dart';
import 'package:flutter/material.dart';
import 'connectivity_aware_screen.dart';
import '../widgets/lists/list_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/home_screen_constants.dart';
import '../../../presentation/states/news_state.dart';
import '../widgets/states/error_widgets/connection_error_state_widget.dart';
import 'package:todays_news/presentation/widgets/states/initial_state_widget.dart';
import 'package:todays_news/presentation/widgets/states/loading_state_widget.dart';
import 'package:todays_news/presentation/widgets/states/error_widgets/error_state_widget.dart';


class SportsScreen extends StatelessWidget {
  const SportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const screenIndex = HomeScreenConstants.screenSportsIndex;
    return ConnectivityAwareService(
        screenIndex: screenIndex,
        child: BlocBuilder<NewsCubit, NewsState>(
            buildWhen: (previous, current)=> current.currentIndex == screenIndex,
            builder: (context, state) {
              final currentTabData = state.currentTabData;
              final currentCubit = context.read<NewsCubit>();

              return state.when(
                  initial: () =>
                  const InitialStateWidget(
                      icon: Icons.sports, category: 'sports'),
                  loading: () =>
                  const LoadingStateWidget(),
                  loaded: (newTabData) =>
                      ListBuilder(
                          list: newTabData!.products,
                          hasMore: currentTabData!.hasMore,
                          onScroll: () => currentCubit.getMoreData()),
                  onError: (error) =>
                  error.isConnectionError ? Center(
                      child: ConnectionErrorStateWidget(
                          error: error.message,
                          onRetry: () =>
                              currentCubit.changeScreen(state
                                  .currentIndex)
                      )) : ErrorStateWidget(
                      error: error.message,
                      onRetry: () =>
                          currentCubit.changeScreen(state.currentIndex))
              );
            }
        )
    );
  }
}