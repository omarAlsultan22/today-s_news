import '../cubits/news_cubit.dart';
import '../states/news_state.dart';
import 'package:flutter/cupertino.dart';


mixin TabListenerMixin<T extends StatefulWidget> on State<T> {
  late NewsCubit cubit;
  late int screenIndex;

  void initializeTabListener(int index) {
    screenIndex = index;
    cubit = NewsCubit.get(context);
  }

  /// Handles tab update sequence:
  /// 1. Resets lock state
  /// 2. Updates existing data
  /// 3. Loads fresh data

  void handleTabListener(NewsState state) async {
    cubit.restLock(screenIndex);
    await cubit.updateData(
      index: screenIndex,
      isConnected: state.isConnected!,
    );
    if(state.currentTabIndex == screenIndex) {
      await cubit.loadCurrentTabData(screenIndex);
    }
  }
}