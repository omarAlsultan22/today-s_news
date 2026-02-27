import '../cubits/News_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/layouts/home_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/states/news_state.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivityService, child) {
          return BlocBuilder<NewsCubit, NewsState>(
              builder: (context, state) {
                return HomeLayout(
                    connectivityService: connectivityService
                );
              }
          );
        }
    );
  }
}






