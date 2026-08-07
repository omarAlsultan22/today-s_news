import 'app/my_app.dart';
import 'config/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'errors/mappers/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todays_news/constants/app_colors.dart';
import 'package:todays_news/config/initialization_controller.dart';
import 'package:todays_news/presentation/widgets/build_snack_bar.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  final initializationController = InitializationController();

  try {
    await initializationController.init();
    runApp(const MyApp());
  }
  catch (e, stackTrace) {
    final errorHandler = ErrorHandler(
      error: e,
      stackTrace: stackTrace,
    );
    final exception = errorHandler.handleException();
    runApp(
        MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) =>
                  Scaffold(
                    body: exception.buildErrorWidget(
                      onRetry: () async {
                        try {
                          await initializationController.retryInit();
                          runApp(const MyApp());
                        } catch (e) {
                          BuildSnackBar.show(
                              message: 'Initialization failed',
                              context: context,
                              backgroundColor: AppColors.red
                          );
                        }
                      },
                    ),
                  ),
            )
        )
    );
  }
}

