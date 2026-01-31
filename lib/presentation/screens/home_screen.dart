import '../states/news_state.dart';
import 'package:flutter/material.dart';
import '../cubits/categories_cubit.dart';
import '../widgtes/layouts/home_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext? context) {
    return BlocBuilder<CategoriesCubit, NewsState>(
      builder: (context, state) {
        final cubit = CategoriesCubit.get(context);
        return HomeLayout(cubit, state);
      },
    );
  }
}





