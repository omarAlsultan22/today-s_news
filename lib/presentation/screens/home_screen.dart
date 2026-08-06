import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/layouts/home_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/connectivity_provider.dart';
import '../../../presentation/states/news_state.dart';
import 'package:todays_news/presentation/cubits/news_cubit.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          final cubit = NewsCubit.get(context);
          return Consumer<ConnectivityProvider>(
              builder: (context, connectivityService, child) {
                return HomeLayout(
                    barItems: cubit.barItems,
                    screenItems: cubit.screenItems,
                    currentIndex: state.currentTabIndex,
                    connectivityService: connectivityService,
                    onChange: (index) =>
                        cubit.switchTabAndLoadData(index: index)
                );
              }
          );
        }

    );
  }
}






