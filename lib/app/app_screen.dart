import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/domain/cubit/auth_user_cubit.dart';
import 'package:rain_check/core/utils/name_formatter.dart';

@RoutePage()
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  final String location = "";

  final List<_NavItem> navList = const [
    _NavItem(
      title: "Calculate",
      route: CalculateRoute(),
      icon: Icons.calculate,
    ),
    _NavItem(
      title: "Predict",
      route: PredictRoute(),
      icon: Icons.batch_prediction,
    ),
    _NavItem(
      title: "How to Use RainCheck",
      route: GuideRoute(),
      icon: Icons.water_drop,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocConsumer<AuthUserCubit, AuthUserState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var fullName = state.currentUser?.fullName;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "RAIN CHECK",
                          style: theme.textTheme.bodySmall?.copyWith(
                            letterSpacing: 1.2,
                            color: AppColors.textGrey,
                          ),
                        ),
                        Text(
                          NameFormatter.formatFullName(fullName.toString()),
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  const CircleAvatar(
                    radius: 20,
                    child: Icon(
                      Icons.account_circle,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WeatherHeader(location: location),
                const Gap(20),
                Text("Quick Actions", style: theme.textTheme.titleMedium),
                const Gap(8),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    itemCount: navList.length,
                    itemBuilder: (context, index) {
                      final item = navList[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.textWhite,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.lighttGrey,
                              child: Icon(
                                item.icon as IconData?,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text(item.title),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () => context.router.push(item.route),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Weather header widget
class _WeatherHeader extends StatefulWidget {
  final String location;
  const _WeatherHeader({required this.location});

  @override
  State<_WeatherHeader> createState() => _WeatherHeaderState();
}

class _WeatherHeaderState extends State<_WeatherHeader> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Row
          Row(
            children: [
              const Icon(Icons.pin_drop, size: 28, color: AppColors.textWhite),
              const Gap(8),
              Text(
                "Puerto Princesa City",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
          const Gap(8),
          Text("Today's Forecast", style: theme.textTheme.titleLarge),
          const Gap(16),

          // Rain info
          Row(
            children: [
              const Icon(Icons.water_drop, size: 40, color: AppColors.primary),
              const Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("40%", style: theme.textTheme.titleMedium),
                  const Text("Light showers expected"),
                  const Text("Accumulation: 5mm"),
                ],
              ),
            ],
          ),
          const Gap(16),

          // Temperature Now
          Row(
            children: const [
              Icon(Icons.thermostat, size: 40, color: AppColors.textWhite),
              Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Now",
                    style: TextStyle(fontSize: 16, color: AppColors.textWhite),
                  ),
                  Text(
                    "18°C",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Type-safe nav item
class _NavItem {
  final String title;
  final PageRouteInfo route;
  final IconData icon;

  const _NavItem({
    required this.title,
    required this.route,
    required this.icon,
  });
}
