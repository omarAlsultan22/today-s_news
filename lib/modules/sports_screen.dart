import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/components.dart';
import '../models/states_keys_model.dart';
import 'package:flutter/material.dart';
import '../shared/cubit/states.dart';
import '../shared/cubit/cubit.dart';


class SportsScreen extends StatelessWidget {
  const SportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodaysNewsCubit, TodaysNewsStates>(
        listener: (context, state) =>
            scaffoldMessenger(
                state: state,
                context: context,
                key: StatesKeys.sports
            ),

        builder: (context, state) {
          final currentCubit = TodaysNewsCubit.get(context);
          final sportList = currentCubit.sportList;
          final isLoadingMore = currentCubit.isSportLoadingMore;
          return ListBuilder(
              list: sportList,
              isLoadingMore: isLoadingMore,
              onPressed: () => currentCubit.loadMoreData()
          );
        }
    );
  }
}