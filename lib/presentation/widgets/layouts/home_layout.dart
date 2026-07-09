import '../../constants/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mixins/debounce_mixin.dart';
import '../../screens/search_screen.dart';
import '../../../themes/screen_theme.dart';
import 'package:todays_news/constants/app_colors.dart';
import 'package:todays_news/constants/app_durations.dart';
import '../../../data/data_sources/remote/dio_helper.dart';
import 'package:todays_news/presentation/constants/ui_sizes.dart';
import '../../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/data/repositories_impl/api_articles_repository.dart';
import '../../../domain/services/connectivity_service/connectivity_provider.dart';
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
    final repository = ApiArticlesRepository(dioHelper: dioHelper);
    final paginationHandler = PaginationHandler();
    final loadDataUseCase = LoadDataUseCase(
        repository: repository, paginationHandler: paginationHandler);
    final connectivityProvider = ConnectivityProvider();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SearchScreen(loadDataUseCase: loadDataUseCase,
                    connectivityProvider: connectivityProvider
                )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = connectivityService.isConnected;
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
              Provider.of<ThemeNotifier>(context, listen: false)
                  .toggleTheme();
            },
            icon: const Icon(Icons.brightness_4_outlined),
          ),
        ],
      ),
      body: Column(
          children: [
            ConnectionBanner(
                isVisible: isConnected,
                bgColor: isConnected ? const Color(0xFF388E3C) : const Color(
                    0xFFD32F2F),
                icon: isConnected ? Icons.wifi : Icons.signal_wifi_off,
                text: isConnected ? 'online' : 'offline'
            ),
            Expanded(
                child: screenItems[currentIndex])
          ]
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
  final bool isVisible;
  final Color bgColor;
  final IconData icon;
  final String text;

  const ConnectionBanner({
    super.key,
    required this.isVisible,
    required this.bgColor,
    required this.icon,
    required this.text,
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
    _startTimer();
  }

  void _startTimer() {
    if (widget.isVisible) {
      runDebounced(
          AppDurations.seconds, () =>
          _hideBanner()
      );
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


