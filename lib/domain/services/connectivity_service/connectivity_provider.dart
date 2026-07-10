import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class ConnectivityProvider with ChangeNotifier {
  // المتغيرات الأساسية
  bool _isConnected = false;
  bool _showOnlineMessage = false;
  bool _showOfflineMessage = false;
  String _connectionType = 'Unknown';
  bool _isInitialized = false;

  // الـ Subscriptions والـ Timers
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
  Timer? _onlineMessageTimer;
  Timer? _offlineMessageTimer;
  Timer? _checkTimer;

  static const _none = 'None';

  // Getters
  bool get isConnected => _isConnected;
  bool get showOnlineMessage => _showOnlineMessage;
  bool get showOfflineMessage => _showOfflineMessage;
  String get connectionType => _connectionType;
  bool get isInitialized => _isInitialized;

  final Connectivity _connectivity = Connectivity();

  // Constructor
  ConnectivityProvider() {
    _initConnectivity();
    _startPeriodicCheck();
  }

  // ==================== التهيئة ====================

  void _initConnectivity() async {
    try {
      // التحقق من الحالة الأولية
      final result = await _connectivity.checkConnectivity();
      final bool initialStatus = _hasConnection(result);
      final String initialType = _getConnectionType(result);

      // تحديث القيم مباشرة
      _isConnected = initialStatus;
      _connectionType = initialType;
      _isInitialized = true;

      // إشعار واحد فقط بعد التهيئة
      notifyListeners();

      // عرض الرسالة المناسبة بعد التأكد من الحالة
      if (_isConnected) {
        _showTemporaryOnlineMessage();
      } else {
        _showTemporaryOfflineMessage();
      }

      // بدء الاستماع للتغيرات
      connectivitySubscription = listenToStatus(updateConnectionStatus);

    } catch (e) {
      print('Error initializing connectivity: $e');
      _isConnected = false;
      _connectionType = _none;
      _isInitialized = true;
      notifyListeners();

      // عرض رسالة عدم الاتصال
      _showTemporaryOfflineMessage();
    }
  }

  // ==================== التحقق من الاتصال ====================

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      updateConnectionStatus(result);
    } catch (e) {
      print('Error checking connectivity: $e');
      updateConnectionStatus([ConnectivityResult.none]);
    }
  }

  // ==================== الاستماع للتغيرات ====================

  StreamSubscription<List<ConnectivityResult>> listenToStatus(
      void Function(List<ConnectivityResult> event) onData) {
    return _connectivity.onConnectivityChanged.listen(
      onData,
      onError: (error) {
        print('Connectivity error: $error');
        updateConnectionStatus([ConnectivityResult.none]);
      },
    );
  }

  // ==================== الفحص الدوري ====================

  void _startPeriodicCheck() {
    // فحص دوري كل 10 ثوان للتأكد من الاتصال
    _checkTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _checkConnectivity();
    });
  }

  // ==================== تحديث حالة الاتصال ====================

  void updateConnectionStatus(List<ConnectivityResult> results) {
    // تجاهل التحديثات قبل التهيئة
    if (!_isInitialized) return;

    final bool newStatus = _hasConnection(results);
    final String newType = _getConnectionType(results);

    print('Connection status: $newStatus, Type: $newType');

    if (_isConnected != newStatus || _connectionType != newType) {
      final bool wasConnected = _isConnected;
      _isConnected = newStatus;
      _connectionType = newType;

      if (wasConnected && !newStatus) {
        // فقدان الاتصال
        print('Connection lost');
        _hideOnlineMessage();
        _showTemporaryOfflineMessage();
        _notifyWithDelay();

      } else if (!wasConnected && newStatus) {
        // استعادة الاتصال
        print('Connection restored');
        _hideOfflineMessage();
        _showTemporaryOnlineMessage();
        notifyListeners();
        _tryReloadData();

      } else {
        // تغيير في نوع الاتصال فقط
        notifyListeners();
      }
    }
  }

  // ==================== دوال المساعدة ====================

  bool _hasConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;

    for (var result in results) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn ||
          result == ConnectivityResult.other) {
        return true;
      }
    }
    return false;
  }

  String _getConnectionType(List<ConnectivityResult> results) {
    if (results.isEmpty) return _none;

    if (results.contains(ConnectivityResult.wifi)) return 'WiFi';
    if (results.contains(ConnectivityResult.mobile)) return 'Mobile Data';
    if (results.contains(ConnectivityResult.ethernet)) return 'Ethernet';
    if (results.contains(ConnectivityResult.vpn)) return 'VPN';
    if (results.contains(ConnectivityResult.other)) return 'Other';

    return _none;
  }

  // ==================== عرض وإخفاء الرسائل ====================

  void _showTemporaryOnlineMessage() {
    _onlineMessageTimer?.cancel();
    _showOnlineMessage = true;
    notifyListeners();

    _onlineMessageTimer = Timer(const Duration(seconds: 5), () {
      _showOnlineMessage = false;
      notifyListeners();
    });
  }

  void _showTemporaryOfflineMessage() {
    _offlineMessageTimer?.cancel();
    _showOfflineMessage = true;
    notifyListeners();

    _offlineMessageTimer = Timer(const Duration(seconds: 5), () {
      _showOfflineMessage = false;
      notifyListeners();
    });
  }

  void _hideOnlineMessage() {
    _onlineMessageTimer?.cancel();
    _showOnlineMessage = false;
    notifyListeners();
  }

  void _hideOfflineMessage() {
    _offlineMessageTimer?.cancel();
    _showOfflineMessage = false;
    notifyListeners();
  }

  // ==================== دوال إضافية ====================

  void _notifyWithDelay() {
    // تأخير صغير للتأكد من أن UI قد استقبل التحديث
    Future.delayed(const Duration(milliseconds: 300), () {
      notifyListeners();
    });
  }

  void _tryReloadData() {
    // محاولة إعادة تحميل البيانات بعد استعادة الاتصال
    Future.delayed(const Duration(seconds: 2), () {
      // يمكنك هنا استدعاء دالة لإعادة تحميل البيانات
      print('Attempting to reload data...');

      // مثال: إذا كان لديك Cubit أو Provider للبيانات
      // context.read<TodaysNewsCubit>().loadData();
    });
  }

  // ==================== تحديث يدوي ====================

  Future<void> refreshConnection() async {
    // تحديث يدوي لحالة الاتصال
    await _checkConnectivity();
  }

  // ==================== تنظيف الموارد ====================

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    _onlineMessageTimer?.cancel();
    _offlineMessageTimer?.cancel();
    _checkTimer?.cancel();
    super.dispose();
  }
}