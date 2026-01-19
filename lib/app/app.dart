import 'package:flutter/material.dart';
import 'package:rain_check/app/router/router.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final appRouter = AppRouter();
  // TODO: Implement app initialization logic
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Rain Check',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter.config(),
    );
  }
}
