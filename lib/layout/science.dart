import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/cubit.dart';
import '../modules/states.dart';
import '../shared/components/components.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodayNewsCubit, TodayNewsStates>(
        listener: (context, state) {
          if (state is BusinessErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {

          final cubit = TodayNewsCubit.get(context);
          final list = cubit.scienceList;
          final isScienceLoadingMore = cubit.isScienceLoadingMore;
          return ConditionalBuilder(
              list: list,
              isLoadingMore: isScienceLoadingMore,
              onPressed: () => cubit.loadMoreData()
          );
        }
    );
  }
}