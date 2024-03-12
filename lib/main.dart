import 'dart:async';
import 'dart:developer';

import 'package:background_services/splash/splash_screen.dart';


import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'location/background_location_services.dart';
import 'login/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeService();
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );

  service.startService();
}
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  log("Service Started");

  Timer.periodic(const Duration(seconds: 15), (timer) async {
  postLocation();

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "App in background...",
        content: "Update ${DateTime.now()}",
      );
    }
    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
      },
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(), // Provide the LoginBloc here
      child: MaterialApp(
        home: SplashScreen(), // Show SplashScreen initially
      ),
    );
  }
}
