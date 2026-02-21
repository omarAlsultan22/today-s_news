import '../cubits/News_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';


class ConnectivityAwareService extends StatelessWidget {
  final Widget child;
  final int screenIndex;

  const ConnectivityAwareService({
    super.key,
    required this.child,
    required this.screenIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, childWidget) {
        if (connectivityProvider.isConnected) {
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