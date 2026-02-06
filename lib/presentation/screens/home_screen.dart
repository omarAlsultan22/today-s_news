import '../states/news_state.dart';
import '../cubits/News_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgtes/layouts/home_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext? context) {
    return BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          final cubit = NewsCubit.get(context);
          return Consumer<ConnectivityProvider>(
              builder: (context, connectivityService, child) =>
                  HomeLayout(state: state,
                      cubit: cubit,
                      connectivityService: connectivityService)
          );
        }
    );
  }
}






