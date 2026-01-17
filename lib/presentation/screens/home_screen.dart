import '../states/news_states.dart';
import 'package:flutter/material.dart';
import '../cubits/categories_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/layouts/navigation/home_layout.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext? context) {
    return BlocBuilder<CategoriesCubit, NewsStates>(
      builder: (context, state) {
        final cubit = CategoriesCubit.get(context);
        return HomeLayout(cubit, state);
      },
    );
  }
}





