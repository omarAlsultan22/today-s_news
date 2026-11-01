import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:todays_news/providers/connectivity_provider.dart';


void main() {
  late ConnectivityProvider provider;

  setUp(() {
    // نسخة بلا timers — لا platform، لا تسرب
    provider = ConnectivityProvider.forTesting();
  });

  tearDown(() {
    ConnectivityProvider.resetForTesting();
  });

  group('hasConnection', () {
    test('returns false for empty list', () {
      expect(provider.hasConnection([]), false);
    });

    test('returns false for none', () {
      expect(provider.hasConnection([ConnectivityResult.none]), false);
    });

    test('returns true for wifi', () {
      expect(provider.hasConnection([ConnectivityResult.wifi]), true);
    });

    test('returns true for mobile', () {
      expect(provider.hasConnection([ConnectivityResult.mobile]), true);
    });

    test('returns true for ethernet', () {
      expect(provider.hasConnection([ConnectivityResult.ethernet]), true);
    });

    test('returns true for vpn', () {
      expect(provider.hasConnection([ConnectivityResult.vpn]), true);
    });

    test('returns true for other', () {
      expect(provider.hasConnection([ConnectivityResult.other]), true);
    });

    test('returns true when list contains a mix of none and wifi', () {
      expect(
        provider.hasConnection(
            [ConnectivityResult.none, ConnectivityResult.wifi]),
        true,
      );
    });
  });

  group('getConnectionType', () {
    test('returns None for empty list', () {
      expect(provider.getConnectionType([]), 'None');
    });

    test('returns None for [none]', () {
      expect(provider.getConnectionType([ConnectivityResult.none]), 'None');
    });

    test('returns WiFi for wifi', () {
      expect(provider.getConnectionType([ConnectivityResult.wifi]), 'WiFi');
    });

    test('returns Mobile Data for mobile', () {
      expect(
          provider.getConnectionType([ConnectivityResult.mobile]),
          'Mobile Data');
    });

    test('returns Ethernet for ethernet', () {
      expect(
          provider.getConnectionType([ConnectivityResult.ethernet]),
          'Ethernet');
    });

    test('returns VPN for vpn', () {
      expect(provider.getConnectionType([ConnectivityResult.vpn]), 'VPN');
    });

    test('returns Other for other', () {
      expect(provider.getConnectionType([ConnectivityResult.other]), 'Other');
    });

    test('prioritizes WiFi over Mobile when both present', () {
      expect(
        provider.getConnectionType(
            [ConnectivityResult.mobile, ConnectivityResult.wifi]),
        'WiFi',
      );
    });

    test('prioritizes Ethernet over VPN when both present', () {
      expect(
        provider.getConnectionType(
            [ConnectivityResult.vpn, ConnectivityResult.ethernet]),
        'Ethernet',
      );
    });
  });
}