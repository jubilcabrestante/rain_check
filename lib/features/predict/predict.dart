import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rain_check/app/themes/colors.dart';

@RoutePage()
class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
