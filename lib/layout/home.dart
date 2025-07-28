import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todays_news/layout/search.dart';
import 'package:todays_news/shared/components/components.dart';
import '../modules/cubit.dart';
import '../modules/states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer <TodayNewsCubit, TodayNewsStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = TodayNewsCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Today's News",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),),
                  actions: [
                    IconButton(
                        onPressed: () {
                          navPush(context, const SearchScreen());
                        }, icon: const Icon(Icons.search)),
                    IconButton(
                        onPressed: () {
                         Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
                        }, icon: const Icon(Icons.brightness_4_outlined)),
                  ],
                ),
                body: cubit.screenItems[cubit.currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: cubit.currentIndex,
                  selectedItemColor: const Color(0xFFFF5722),
                  items: cubit.items,
                  onTap: (index) {
                      cubit.changeIndex(index);
                  },
                ),
              );
            }
    );
  }
}

