import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rain_check/app/router/router.dart';
import 'package:rain_check/app/themes/themes.dart';
import 'package:rain_check/core/domain/cubit/auth_user_cubit.dart';
import 'package:rain_check/core/domain/i_auth_user_repository.dart';
import 'package:rain_check/core/repository/auth_user_repository.dart';
import 'package:rain_check/features/calculate/domain/cubit/calculate_cubit.dart';
import 'package:rain_check/features/calculate/flood_data_service.dart';
import 'package:rain_check/features/otp_verification/domain/cubit/verification_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key}); // ✅ Removed googleSignIn parameter

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _appRouter = AppRouter();

  late IAuthUserRepository authUserRepository;
  late AuthUserCubit _authUserCubit;
  late VerificationCubit _verificationCubit;
  late CalculateCubit _calculateCubit;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize all dependencies
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final googleSignIn = GoogleSignIn.instance; // ✅ Use the singleton instance
    final floodData = FloodDataService();
    // Initialize repository
    authUserRepository = AuthUserRepository(
      auth: firebaseAuth,
      googleSignIn: googleSignIn,
      firestore: firestore,
    );

    // Initialize cubits
    _authUserCubit = AuthUserCubit(authUserRepository);
    _verificationCubit = VerificationCubit(
      iAuthUserRepository: authUserRepository,
      authUserCubit: _authUserCubit,
    );
    _calculateCubit = CalculateCubit(service: floodData);
  }

  @override
  void dispose() {
    _authUserCubit.close();
    _verificationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = AppTheme.getInstance();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IAuthUserRepository>.value(
          value: authUserRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthUserCubit>.value(value: _authUserCubit),
          BlocProvider<VerificationCubit>.value(value: _verificationCubit),
          BlocProvider<CalculateCubit>.value(value: _calculateCubit),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Rain Check',
          theme: themeData.lightTheme,
          // TODO: Fix the dark theme
          // darkTheme: themeData.darkTheme,
          routerConfig: _appRouter.config(
            includePrefixMatches: true,
            navigatorObservers: () => <NavigatorObserver>[AutoRouteObserver()],
          ),
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              Breakpoint(start: 0, end: 480, name: BreakPoints.small.value),
              Breakpoint(start: 481, end: 600, name: BreakPoints.medium.value),
              Breakpoint(start: 601, end: 840, name: BreakPoints.large.value),
            ],
          ),
        ),
      ),
    );
  }
}

enum BreakPoints {
  small("small"),
  medium("medium"),
  large("large");

  final String value;
  const BreakPoints(this.value);
}
