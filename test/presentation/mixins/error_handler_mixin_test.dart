import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todays_news/errors/exceptions/base/app_exception.dart';
import 'package:todays_news/presentation/mixins/error_handler_mixin.dart';


class FakeAppException extends AppException {
  FakeAppException({required super.message});
}

class FakeCubit extends Cubit<int> with ErrorHandlerMixin<int> {
  FakeCubit() : super(0);

  void triggerError({
    required AppException exception,
    required StackTrace stackTrace,
    required int Function(AppException) onError,
  }) {
    handleError(
        error: exception,
        onError: onError,
        stackTrace: stackTrace
    );
  }
}

void main() {
  late FakeCubit cubit;

  setUp(() {
    cubit = FakeCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  group('handleError', () {
    test('emits the state returned by onError', () async {
      final exception = FakeAppException(message: 'test error');

      cubit.triggerError(
        exception: exception,
        stackTrace: StackTrace.current,
        onError: (_) => 42,
      );

      expect(cubit.state, 42);
    });

    test('passes the AppException to onError', () async {
      final exception = FakeAppException(message: 'test error');
      AppException? capturedFailure;

      cubit.triggerError(
        exception: exception,
        stackTrace: StackTrace.current,
        onError: (failure) {
          capturedFailure = failure;
          return 1;
        },
      );

      expect(capturedFailure, isNotNull);
      expect(capturedFailure, isA<AppException>());
    });

    test('emits only once per call', () async {
      final states = <int>[];
      final subscription = cubit.stream.listen(states.add);

      cubit.triggerError(
        exception: FakeAppException(message: 'e'),
        stackTrace: StackTrace.current,
        onError: (_) => 7,
      );

      // انتظر stream
      await Future<void>.delayed(Duration.zero);

      expect(states, [7]);

      await subscription.cancel();
    });

    test('does not emit when onError throws', () async {
      final exception = FakeAppException(message: 'e');

      expect(
            () => cubit.triggerError(
          exception: exception,
          stackTrace: StackTrace.current,
          onError: (_) => throw Exception('onError failed'),
        ),
        throwsA(isA<Exception>()),
      );

      // الحالة ما زالت 0 (لم يتغير)
      expect(cubit.state, 0);
    });
  });
}