import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:rain_check/app/widgets/logout_dialog.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/domain/cubit/auth_user_cubit.dart';
import 'package:rain_check/core/utils/name_formatter.dart';
import 'package:rain_check/app/widgets/weather_header.dart';

@RoutePage()
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen>
    with WidgetsBindingObserver {
  static const List<_NavItem> _navList = [
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    log("MainAppScreen initialized");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    log("MainAppScreen disposed");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      log("App resumed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthUserCubit, AuthUserState>(
      builder: (context, state) {
        final fullName = state.currentUser?.fullName ?? '';
        final profileImage = state.currentUser?.profilePictureUrl;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              width: double.infinity,
              child: Row(
                children: [
                  Column(
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
                        NameFormatter.formatFullName(fullName),
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => LogoutDialog.show(context),
                    child: CircleAvatar(
                      radius: 20,
                      child: profileImage != null
                          ? ClipOval(child: Image.network(profileImage))
                          : const Icon(
                              Icons.account_circle,
                              color: AppColors.primary,
                              size: 30,
                            ),
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
                const WeatherHeader(),
                const Gap(20),
                Text("Quick Actions", style: theme.textTheme.titleMedium),
                const Gap(8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    itemCount: _navList.length,
                    itemBuilder: (context, index) {
                      final item = _navList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _NavCard(item: item),
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

class _NavCard extends StatelessWidget {
  final _NavItem item;
  const _NavCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
          child: Icon(item.icon, color: AppColors.primary),
        ),
        title: Text(item.title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => context.router.push(item.route),
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
