import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/cubit.dart';
import '../modules/states.dart';
import '../shared/components/components.dart';

class SportScreen extends StatelessWidget {
  const SportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider(create: (context) => TodayNewsCubit());
    return BlocConsumer<TodayNewsCubit, TodayNewsStates>(
        listener: (context, state) {
          if (state is BusinessErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {

          final cubit = TodayNewsCubit.get(context);
          final list = cubit.sportList;
          final isSportLoadingMore = cubit.isSportLoadingMore;
          return ConditionalBuilder(
              list: list,
              isLoadingMore: isSportLoadingMore,
              onPressed: () => cubit.loadMoreData()
          );
        }
    );
  }
}