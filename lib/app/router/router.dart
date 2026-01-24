import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();
  @override
  List<AutoRoute> get routes => [
    // HomeScreen is generated as HomeRoute because
    // of the replaceInRouteName property
    AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
    AutoRoute(page: ForgotPasswordRoute.page, path: '/forgot-password'),
    AutoRoute(page: SignupRoute.page, path: '/sign-up'),
    AutoRoute(page: InputNumberRoute.page, path: '/input-number'),
    AutoRoute(page: InputPinRoute.page, path: '/input-pin'),
    AutoRoute(page: InputUserRoute.page, path: '/input-user'),
    AutoRoute(
      page: MainAppRoute.page,
      path: '/main',
      children: [
        //Dashboard
        AutoRoute(page: CalculateRoute.page, path: "calculate"),

        AutoRoute(page: PredictRoute.page, path: "predict"),

        AutoRoute(page: GuideRoute.page, path: "guide"),
      ],
    ),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
