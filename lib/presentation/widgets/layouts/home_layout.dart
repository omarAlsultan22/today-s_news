import 'dart:async';
import '../../cubits/News_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/search_screen.dart';
import '../../../constants/app_icons.dart';
import '../../../themes/screen_theme.dart';
import 'package:todays_news/constants/app_sizes.dart';
import 'package:todays_news/constants/app_colors.dart';
import 'package:todays_news/data/datasources/remote/dio_helper.dart';
import '../../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/data/repositories_impl/api_articles_repository.dart';
import '../../../domain/services/connectivity_service/connectivity_provider.dart';
import 'package:todays_news/presentation/utils/helpers/pagination_state_manager.dart';


class HomeLayout extends StatelessWidget {
  final int currentIndex;
  final ConnectivityProvider connectivityService;

  const HomeLayout({
    super.key,
    required this.currentIndex,
    required this.connectivityService,
  });


  void _navPushSearchScreen(BuildContext context) {
    final dioHelper = DioHelper();
    final repository = ApiArticlesRepository(dioHelper: dioHelper);
    final paginationHandler = PaginationHandler();
    final loadDataUseCase = LoadDataUseCase(
        repository: repository, paginationHandler: paginationHandler);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => SearchScreen(loadDataUseCase: loadDataUseCase)));
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = connectivityService.isConnected;
    final cubit = context.read<NewsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's News"),
        actions: [
          IconButton(
            onPressed: () => _navPushSearchScreen(context),
            icon: AppIcons.searchIcon,
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
                bgColor: isConnected ? const Color(0xFF388E3C) : const Color(0xFFD32F2F),
                icon: isConnected ? Icons.wifi : Icons.signal_wifi_off,
                text: isConnected ?  'online' : 'offline'
            ),
            Expanded(
                child: cubit.screenItems[currentIndex])
          ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => cubit.changeScreen(index),
        items: cubit.barItems,
      ),
    );
  }
}


class ConnectionBanner extends StatefulWidget {
  final bool isVisible;
  final Color bgColor;
  final IconData icon;
  final String text;
  final int duration;

  const ConnectionBanner({
    super.key,
    required this.isVisible,
    required this.bgColor,
    required this.icon,
    required this.text,
    this.duration = 0,
  });

  @override
  _ConnectionBannerState createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends State<ConnectionBanner> {
  late double _height;
  Timer? _timer;

  static const _milliseconds = 300;
  static const _white = AppColors.white;
  static const _noneValue = AppSizes.none;

  @override
  void initState() {
    super.initState();
    _height = 40.0;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    if (widget.duration > _noneValue) {
      _timer = Timer(Duration(seconds: widget.duration), () {
        _hideBanner();
      });
    }
  }

  void _hideBanner() {
    if (mounted) {
      setState(() {
        _height = AppSizes.none;
      });
    }
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: _milliseconds),
      curve: Curves.easeInOut,
      height: _height,
      color: widget.bgColor,
      child: _height > _noneValue
          ? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: _white),
            const SizedBox(width: 8.0),
            Text(
              widget.text,
              style: const TextStyle(
                color: _white,
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
    _timer?.cancel();
    super.dispose();
  }
}


