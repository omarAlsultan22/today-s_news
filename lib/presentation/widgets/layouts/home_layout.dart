import 'dart:async';
import '../../cubits/News_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/search_screen.dart';
import '../../../core/themes/screen_theme.dart';
import 'package:todays_news/core/constants/app_constants.dart';
import '../../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/data/repositories_impl/api_articles_repository.dart';
import '../../../domain/services/connectivity_service/connectivity_provider.dart';


class HomeLayout extends StatelessWidget {
  final ConnectivityProvider _connectivityService;

  const HomeLayout({super.key,
    required ConnectivityProvider connectivityService,
  }) : _connectivityService = connectivityService;


  void _navPushSearchScreen(BuildContext context) {
    final repository = ApiArticlesRepository();
    final loadDataUseCase = LoadDataUseCase(repository: repository);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => SearchScreen(loadDataUseCase: loadDataUseCase)));
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = _connectivityService.isConnected;
    final cubit = context.read<NewsCubit>();
    final state = cubit.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's News"),
        actions: [
          IconButton(
            onPressed: () => _navPushSearchScreen(context),
            icon: AppConstants.searchIcon,
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
                text: isConnected ? 'online' : 'offline'
            ),
            Expanded(
                child: cubit.screenItems[state.currentIndex])
          ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.currentIndex,
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

  static const _white = AppConstants.white;
  static const _zero = AppConstants.zero;

  @override
  void initState() {
    super.initState();
    _height = 40.0;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    if (widget.duration > _zero) {
      _timer = Timer(Duration(seconds: widget.duration), () {
        _hideBanner();
      });
    }
  }

  void _hideBanner() {
    if (mounted) {
      setState(() {
        _height = 0.0;
      });
    }
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _height,
      color: widget.bgColor,
      child: _height > _zero
          ? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: _white),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: const TextStyle(
                color: _white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
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


