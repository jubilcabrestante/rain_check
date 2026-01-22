import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rain_check/app/router/router.dart';
import 'package:rain_check/app/themes/themes.dart';
import 'package:rain_check/core/domain/cubit/auth_cubit.dart';
import 'package:rain_check/core/domain/i_user_repository.dart';
import 'package:rain_check/core/repository/auth_user_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MainApp extends StatefulWidget {
  final GoogleSignIn googleSignIn;
  const MainApp({super.key, required this.googleSignIn});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _appRouter = AppRouter();

  late IAuthUserRepository authUserRepository;
  late AuthCubit _authCubit;
  late FirebaseAuth _firebaseAuth;
  late GoogleSignIn _googleSignIn;
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();

    // Initialize Firebase and Firestore references
    _firebaseAuth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;

    // Use the GoogleSignIn instance passed from main()
    _googleSignIn = widget.googleSignIn;

    // Initialize repository and cubit
    authUserRepository = AuthUserRepository(
      auth: _firebaseAuth,
      googleSignIn: _googleSignIn,
      firestore: _firestore,
    );

    _authCubit = AuthCubit(authUserRepository);
  }

  // TODO: Implement app initialization logic
  @override
  Widget build(BuildContext context) {
    var themeData = AppTheme.getInstance();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IAuthUserRepository>.value(
          value: authUserRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [BlocProvider<AuthCubit>.value(value: _authCubit)],
        child: MaterialApp.router(
          theme: themeData.lightTheme,
          routerConfig: _appRouter.config(
            includePrefixMatches: true,
            navigatorObservers: () => <NavigatorObserver>[AutoRouteObserver()],
          ),
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              //480 dp, 600 dp, 840 dp, 960 dp, 1280 dp, 1440 dp, and 1600 dp.
              // Extra Small (xs) - 0px to 599px (for small phones)
              Breakpoint(start: 0, end: 480, name: BreakPoints.small.value),

              // Small (sm) - 600px to 899px (for larger phones or small tablets)
              Breakpoint(start: 481, end: 600, name: BreakPoints.medium.value),

              // Medium (md) - 900px to 1199px (larger phones or very small tablets)
              Breakpoint(start: 601, end: 840, name: BreakPoints.large.value),

              // Optionally, you can add larger breakpoints but if you only need phones, you can leave them out.
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

  // The value that will be associated with each enum member
  final String value;

  // Constructor to assign the value
  const BreakPoints(this.value);
}
