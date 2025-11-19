import '../shared/cubit/states.dart';
import 'package:flutter/material.dart';
import '../shared/constants/state_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/shared/cubit/cubit.dart';
import 'package:todays_news/shared/components/components.dart';


class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodaysNewsCubit, TodaysNewsStates>(
      listener: (context, state) {
        scaffoldMessenger(
            context: context,
            state: state,
            key: StatesKeys.business
        );
      },
      builder: (context, state) {
        final currentCubit = TodaysNewsCubit.get(context);
        final businessList = currentCubit.businessList;
        final isLoadingMore = currentCubit.isBusinessLoadingMore;
        return ListBuilder(
            list: businessList,
            isLoadingMore: isLoadingMore,
            onPressed: () => currentCubit.loadMoreData()
        );
      },
    );
  }
}
