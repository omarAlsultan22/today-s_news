import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../cubits/News_cubit.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class ConnectivityAwareScreen extends StatelessWidget {
  final Widget child;
  final int screenIndex;
  final bool shouldCallRestLock;

  const ConnectivityAwareScreen({
    super.key,
    required this.child,
    required this.screenIndex,
    this.shouldCallRestLock = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, childWidget) {
        if (shouldCallRestLock) {
          _callRestLockIfNeeded(context, screenIndex);
        }
        return child;
      },
    );
  }

  void _callRestLockIfNeeded(BuildContext context, int screenIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final newsCubit = context.read<NewsCubit>();
        final currentState = newsCubit.state;
        if (currentState.currentIndex == screenIndex) {
          newsCubit.restLock();
        }
      } catch (e) {
        debugPrint('Error calling restLock: $e');
      }
    });
  }
}