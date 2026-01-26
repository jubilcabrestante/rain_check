import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rain_check/app/themes/colors.dart';
// import 'package:rain_check/core/shared/app_drop_down_field.dart';

@RoutePage()
class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // AppDropdownField(
            //   title: "Type location here",
            //   // options: Amount,
            //   // value: value,
            //   // onChanged: onChanged,
            //   // optionLabel: optionLabel,
            // ),
            // TODO: Implement search location here
          ],
        ),
      ),
      body: Center(child: Placeholder()),
    );
  }
}
