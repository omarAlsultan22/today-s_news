import '../shared/cubit/cubit.dart';
import 'package:flutter/material.dart';
import '../modules/search_screen.dart';
import 'package:provider/provider.dart';
import '../shared/components/components.dart';


class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = TodaysNewsCubit.get(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's News"),
        actions: [
          IconButton(
            onPressed: () => navPush(context, const SearchScreen()),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
            icon: const Icon(Icons.brightness_4_outlined),
          ),
        ],
      ),
      body: cubit.screenItems[cubit.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: cubit.currentIndex,
        onTap: cubit.changeIndex,
        items: cubit.items,
      ),
    );
  }
}