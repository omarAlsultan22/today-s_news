import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/screen_theme.dart';
import '../../../presentation/states/news_states.dart';
import '../../../presentation/screens/search_screen.dart';
import '../../../presentation/cubits/categories_cubit.dart';
import 'package:todays_news/data/repositories_impl/api_repository.dart';
import '../../../domain/useCases/tab_useCases/load_tab_data_useCase.dart';


class HomeLayout extends StatelessWidget {
  final CategoriesCubit _cubit;
  final NewsStates _state;
  const HomeLayout(this._cubit,this._state, {super.key});

  void _navPushSearchScreen(BuildContext context) {
    final newsApiRepository = NewsApiRepository();
    final loadDataUseCase = LoadDataUseCase(newsApiRepository);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => SearchScreen(loadDataUseCase: loadDataUseCase)));
  }

  @override
  Widget build(BuildContext context) {
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
      body: Expanded(child: _cubit.screenItems[_state.currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _state.currentIndex,
        onTap: (index)=> _cubit.changeScreen(index),
        items: _cubit.barItems,
      ),
    );
  }
}


class ConnectionBanner extends StatefulWidget {
  final bool isVisible;
  final Color color;
  final IconData icon;
  final String text;
  final int duration;
  final VoidCallback? reload;

  const ConnectionBanner({
    super.key,
    required this.isVisible,
    required this.color,
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
      color: widget.color,
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


