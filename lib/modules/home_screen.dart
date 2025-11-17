import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
import '../layouts/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodaysNewsCubit, TodaysNewsStates>(
      builder: (context, state) {
        return HomeLayout();
      },
    );
  }
}


