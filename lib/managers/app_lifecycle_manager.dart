import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class AppLifecycleManager extends StatefulWidget {
  final Widget child;

  const AppLifecycleManager({super.key, required this.child});

  @override
  _AppLifecycleManagerState createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.inactive:
        _onAppInactive();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.hidden:
        _onAppHidden();
        break;
    }
  }

  Future<void> _onAppPaused() async {
    print('🔄 التطبيق في الخلفية - حفظ بيانات Hive');
    try {
      // حفظ جميع Boxes المفتوحة
      await Hive.box('settings').flush();
      await Hive.box('users').flush();
      await Hive.box('cache').flush();
      print('✅ تم حفظ بيانات Hive بنجاح');
    } catch (e) {
      print('❌ خطأ في حفظ بيانات Hive: $e');
    }
  }

  Future<void> _onAppDetached() async {
    print('🔴 إغلاق التطبيق - تنظيف Hive');
    try {
      await Hive.close();
      print('✅ تم إغلاق Hive بنجاح');
    } catch (e) {
      print('❌ خطأ في إغلاق Hive: $e');
    }
  }

  void _onAppResumed() {
    print('✅ التطبيق عاد للعمل - تحديث البيانات');
    // يمكنك إضافة تحديث للبيانات من API هنا
  }

  void _onAppInactive() {
    print('⏸️ التطبيق غير نشط');
  }

  void _onAppHidden() {
    print('👁️ التطبيق مخفي');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}