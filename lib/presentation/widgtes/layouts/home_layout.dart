import 'dart:async';
import '../../cubits/News_cubit.dart';
import '../../states/news_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/search_screen.dart';
import '../../../core/themes/screen_theme.dart';
import '../../../domain/repositories/data_repository.dart';
import '../../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';
import 'package:todays_news/data/repositories_impl/api_articles_repository.dart';
import '../../../domain/services/connectivity_service/connectivity_provider.dart';


class HomeLayout extends StatelessWidget {
  final NewsCubit _cubit;
  final NewsState _state;
  final ConnectivityProvider _connectivityService;
  const HomeLayout({super.key,
    required NewsCubit cubit,
    required NewsState state,
    required ConnectivityProvider connectivityService,
  })
      : _cubit = cubit,
        _state = state,
        _connectivityService = connectivityService;


  void _navPushSearchScreen(BuildContext context) {
    final DataRepository repository = ApiArticlesRepository();
    final loadDataUseCase = LoadDataUseCase(repository);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => SearchScreen(loadDataUseCase: loadDataUseCase)));
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = _connectivityService.isConnected;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's News"),
        actions: [
          IconButton(
            onPressed: () => _navPushSearchScreen(context),
            icon: const Icon(Icons.search),
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
                bgColor: isConnected? Colors.green.shade700 : Colors.red.shade700,
                icon: isConnected? Icons.wifi : Icons.signal_wifi_off,
                text: isConnected? 'online' : 'offline'),
            Expanded(
                child: _cubit.screenItems[_state.currentIndex])
          ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _state.currentIndex,
        onTap: (index) => _cubit.changeScreen(index),
        items: _cubit.barItems,
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
  final VoidCallback? reload;

  const ConnectionBanner({
    super.key,
    required this.isVisible,
    required this.bgColor,
    required this.icon,
    required this.text,
    this.duration = 0,
    this.reload
  });

  @override
  _ConnectionBannerState createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends State<ConnectionBanner> {
  late double _height;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _height = 40.0;
    _restLocks();
    _startTimer();
  }


  void _restLocks() {
    if (widget.isVisible) {
      widget.reload!();
    }
  }

  void _startTimer() {
    _timer?.cancel();

    if (widget.duration > 0) {
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
      child: _height > 0
          ? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
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


