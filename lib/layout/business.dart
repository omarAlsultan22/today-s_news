import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/modules/cubit.dart';
import 'package:todays_news/modules/states.dart';
import 'package:todays_news/shared/components/components.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

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
        final list = cubit.businessList;
        final isBusinessLoadingMore = cubit.isBusinessLoadingMore;
        return ConditionalBuilder(list: list,
            isLoadingMore: isBusinessLoadingMore,
            onPressed: () => cubit.loadMoreData()
        );
      },
    );
  }
}
