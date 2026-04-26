import '../cubits/news_cubit.dart';
import 'package:flutter/material.dart';
import '../widgets/lists/list_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/home_screen_constants.dart';
import '../../../presentation/states/news_state.dart';
import 'connectivity_aware_screen_for_categories.dart';
import 'package:todays_news/presentation/widgets/states/initial_state_widget.dart';
import 'package:todays_news/presentation/widgets/states/loading_state_widget.dart';


class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  static const screenIndex = HomeScreenConstants.screenBusinessIndex;

  @override
  Widget build(BuildContext context) {
    return ConnectivityAwareScreenForCategories(
        screenIndex: screenIndex,
        child: BlocBuilder<NewsCubit, NewsState>(
            buildWhen: (previous, current) =>
            current.currentTabIndex == screenIndex,
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
                          onScroll: () => currentCubit.getMoreData()),
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

