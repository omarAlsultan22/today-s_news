import '../states/news_state.dart';
import '../cubits/news_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/lists/list_builder.dart';
import 'package:todays_news/core/widgets/no_data_widget.dart';
import 'package:todays_news/core/widgets/connectivity_aware_screen.dart';
import 'package:todays_news/core/widgets/error_widgets/error_state.dart';
import '../../core/widgets/error_widgets/no_internet_connection_state.dart';
import 'package:todays_news/features/home/constants/home_screen_constants.dart';


class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const screenIndex = HomeScreenConstants.screenBusinessIndex;
    return ConnectivityAwareScreen(
        screenIndex: screenIndex,
        child: BlocBuilder<NewsCubit, NewsState>(
            builder: (context, state) {
              final currentTabData = state.currentTabData;
              final currentCubit = NewsCubit.get(context);
              const screenIndex = HomeScreenConstants.screenBusinessIndex;
              if (state.currentIndex != screenIndex) {
                final products = state.tabsData[screenIndex]!.products;
                if (products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
              }

              return state.when(
                  initial: () =>
                  const NoDataWidget(
                      icon: Icons.business, category: 'business'),
                  loading: () =>
                  const Center(child: CircularProgressIndicator()),
                  loaded: (newTabData) =>
                      ListBuilder(
                          list: newTabData!.products,
                          hasMore: currentTabData!.hasMore,
                          onScroll: () => currentCubit.getMoreData()),
                  onError: (error) =>
                  error.isConnectionError ? Center(
                      child: NoInternetConnection(
                          error: error.message,
                          onRetry: () =>
                              currentCubit.changeScreen(state
                                  .currentIndex)
                      )) : TasksErrorStateWidget(
                      error: error.message,
                      onRetry: () =>
                          currentCubit.changeScreen(state.currentIndex))
              );
            }
        )
    );
  }
}

