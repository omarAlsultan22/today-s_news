import '../states/news_state.dart';
import 'package:flutter/material.dart';
import '../cubits/categories_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/lists/list_builder.dart';
import 'package:todays_news/presentation/mappers/news_state_mapper.dart';
import 'package:todays_news/core/widgets/error_widgets/error_state.dart';
import '../../core/widgets/error_widgets/no_internet_connection_state.dart';
import 'package:todays_news/features/home/constants/home_screen_constants.dart';


class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, NewsState>(
        builder: (context, state) {
          final currentTabData = state.currentTabData;
          final currentCubit = CategoriesCubit.get(context);
          const screenIndex = HomeScreenConstants.screenBusinessIndex;

          if (state.currentIndex != screenIndex) {
            final products = state.tabsData[screenIndex]!.products;
            if (products.isEmpty) {
              const Center(child: CircularProgressIndicator());
            }
            return ListBuilder(
                list: products,
                isLoadingMore: false,
                onPressed: () {});
          }

          return NewsStateMapper.when(
              state: state,
              initial: () => const SizedBox(),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (newTabData) =>
                  ListBuilder(
                      list: newTabData!.products,
                      isLoadingMore: currentTabData!.hasMore,
                      onPressed: () => currentCubit.getMoreData()),
              onError: (error) =>
              error.isConnectionError ? TasksErrorStateWidget(
                  error: error.message,
                  onRetry: () =>
                      currentCubit.changeScreen(state.currentIndex)) :
              Center(child: NoInternetConnection(
                  error: error.message,
                  onRetry: () => currentCubit.changeScreen(state.currentIndex)
              ))
          );
        }
    );
  }
}
