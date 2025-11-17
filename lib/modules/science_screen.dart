import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/components.dart';
import '../models/states_keys_model.dart';
import 'package:flutter/material.dart';
import '../shared/cubit/states.dart';
import '../shared/cubit/cubit.dart';


class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodaysNewsCubit, TodaysNewsStates>(
        listener: (context, state) =>
          scaffoldMessenger(
              state: state,
              context: context,
              key: StatesKeys.science
          ),

        builder: (context, state) {
          final currentCubit = TodaysNewsCubit.get(context);
          final scienceList = currentCubit.scienceList;
          final isLoadingMore = currentCubit.isScienceLoadingMore;
          return ListBuilder(
              list: scienceList,
              isLoadingMore: isLoadingMore,
              onPressed: () => currentCubit.loadMoreData()
          );
        }
    );
  }
}