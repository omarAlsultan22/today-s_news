import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todays_news/presentation/mixins/debounce_mixin.dart';


class FakeDebounce with DebounceMixin {
  int callCount = 0;

  void trigger(Duration duration) {
    runDebounced(duration, () {
      callCount++;
    });
  }
}

void main() {
  group('runDebounced', () {
    test('executes action after the duration elapses', () {
      fakeAsync((async) {
        final debounce = FakeDebounce();

        debounce.trigger(const Duration(milliseconds: 300));
        expect(debounce.callCount, 0);  // لم يُنفذ بعد

        async.elapse(const Duration(milliseconds: 299));
        expect(debounce.callCount, 0);  // لم يُنفذ بعد

        async.elapse(const Duration(milliseconds: 1));
        expect(debounce.callCount, 1);  // نُفذ
      });
    });

    test('cancels previous timer when called again', () {
      fakeAsync((async) {
        final debounce = FakeDebounce();

        debounce.trigger(const Duration(milliseconds: 300));
        async.elapse(const Duration(milliseconds: 100));  // 100ms

        debounce.trigger(const Duration(milliseconds: 300));  // ← إعادة جدولة
        async.elapse(const Duration(milliseconds: 299));
        expect(debounce.callCount, 0);  // لم يُنفذ (تم إلغاء الأول)

        async.elapse(const Duration(milliseconds: 1));
        expect(debounce.callCount, 1);  // نُفذ مرة واحدة
      });
    });

    test('only executes the last action when called multiple times', () {
      fakeAsync((async) {
        final debounce = FakeDebounce();

        debounce.trigger(const Duration(milliseconds: 300));  // 1
        async.elapse(const Duration(milliseconds: 100));
        debounce.trigger(const Duration(milliseconds: 300));  // 2
        async.elapse(const Duration(milliseconds: 100));
        debounce.trigger(const Duration(milliseconds: 300));  // 3

        async.elapse(const Duration(milliseconds: 300));
        expect(debounce.callCount, 1);  // مرة واحدة فقط
      });
    });

    test('executes each action when duration fully elapses between calls',
            () {
          fakeAsync((async) {
            final debounce = FakeDebounce();

            debounce.trigger(const Duration(milliseconds: 100));
            async.elapse(const Duration(milliseconds: 100));
            expect(debounce.callCount, 1);  // الأول نُفذ

            debounce.trigger(const Duration(milliseconds: 100));
            async.elapse(const Duration(milliseconds: 100));
            expect(debounce.callCount, 2);  // الثاني نُفذ
          });
        });
  });

  group('disposeDebounce', () {
    test('cancels pending timer so action does not execute', () {
      fakeAsync((async) {
        final debounce = FakeDebounce();

        debounce.trigger(const Duration(milliseconds: 300));
        async.elapse(const Duration(milliseconds: 100));

        debounce.disposeDebounce();  // ← إلغاء
        async.elapse(const Duration(milliseconds: 500));
        expect(debounce.callCount, 0);  // لم يُنفذ
      });
    });

    test('is safe to call when no timer is pending', () {
      fakeAsync((async) {
        final debounce = FakeDebounce();

        // لا trigger — dispose مباشرة
        expect(() => debounce.disposeDebounce(), returnsNormally);
        async.elapse(const Duration(seconds: 1));
        expect(debounce.callCount, 0);
      });
    });
  });
}