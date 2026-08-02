import '../../constants/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mixins/debounce_mixin.dart';
import '../../screens/search_screen.dart';
import '../../../themes/screen_theme.dart';
import 'package:todays_news/constants/app_colors.dart';
import '../../../data/data_sources/remote/dio_helper.dart';
import '../../../data/repositories_impl/search_repository.dart';
import 'package:todays_news/presentation/constants/ui_sizes.dart';
import '../../../domain/useCases/tab_useCases/change_tab_useCase.dart';
import '../../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import '../../providers/connectivity_provider.dart';
import 'package:todays_news/presentation/utils/helpers/pagination_state_manager.dart';


class HomeLayout extends StatelessWidget {
  final int currentIndex;
  final List<Widget> screenItems;
  final void Function(int) onChange;
  final List<BottomNavigationBarItem> barItems;
  final ConnectivityProvider connectivityService;

  const HomeLayout({
    super.key,
    required this.onChange,
    required this.barItems,
    required this.screenItems,
    required this.currentIndex,
    required this.connectivityService,
  });

  void _navPushSearchScreen(BuildContext context) {
    final dioHelper = DioHelper();
    final repository = SearchRepository(dioHelper: dioHelper);
    final paginationHandler = PaginationHandler();
    final loadDataUseCase = LoadDataUseCase(
        repository: repository, paginationHandler: paginationHandler);
    final changeTabUseCase = ChangeTabUseCase(loadDataUseCase: loadDataUseCase);
    final connectivityProvider = ConnectivityProvider();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchScreen(
                loadDataUseCase: loadDataUseCase,
                changeTabUseCase: changeTabUseCase,
                connectivityProvider: connectivityProvider
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final showOnlineMessage = connectivityService.showOnlineMessage;
    final showOfflineMessage = connectivityService.showOfflineMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's News"),
        actions: [
          IconButton(
            onPressed: () => _navPushSearchScreen(context),
            icon: UiIcons.searchIcon,
          ),
          IconButton(
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
            icon: const Icon(Icons.brightness_4_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          if (showOfflineMessage)
             const ConnectionBanner(
              bgColor: Color(0xFFD32F2F),
              icon: Icons.signal_wifi_off,
              text: 'Offline',
            ),

          if (showOnlineMessage)
            const ConnectionBanner(
              bgColor: Color(0xFF388E3C),
              icon: Icons.wifi,
              text: 'Online',
            ),

          Expanded(
              child: screenItems[currentIndex]
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => onChange(index),
        items: barItems,
      ),
    );
  }
}


class ConnectionBanner extends StatefulWidget {
  final String text;
  final Color bgColor;
  final IconData icon;

  const ConnectionBanner({
    super.key,
    required this.icon,
    required this.text,
    required this.bgColor
  });

  @override
  _ConnectionBannerState createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends State<ConnectionBanner> with DebounceMixin {
  late double _height;

  static const _milliseconds = 300;

  @override
  void initState() {
    super.initState();
    _height = 40.0;
    _executeAfterBuild();
  }

  @override
  void didUpdateWidget(ConnectionBanner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.bgColor != oldWidget.bgColor) {
      _executeAfterBuild();
    }
    else {
      _hideBanner();
    }
  }

  void _executeAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBanner();
      _startAutoHideTimer();
    });
  }

  void _startAutoHideTimer() {
    disposeDebounce();
    runDebounced(const Duration(seconds: 3),
            () => _hideBanner()
    );
  }

  void _showBanner() {
    if (mounted) {
      setState(() {
        _height = 40.0;
      });
    }
  }

  void _hideBanner() {
    if (mounted) {
      setState(() {
        _height = UiSizes.none;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: _milliseconds),
      curve: Curves.easeInOut,
      height: _height,
      color: widget.bgColor,
      child: _height > UiSizes.none
          ? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: AppColors.white),
            const SizedBox(width: 8.0),
            Text(
              widget.text,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }

  @override
  void dispose() {
    disposeDebounce();
    super.dispose();
  }
}