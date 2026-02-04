import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_drop_down_field.dart';
import 'package:rain_check/features/predict/domain/predict_cubit.dart';
import 'package:rain_check/features/predict/widgets/flood_risk_map.dart';
import 'package:rain_check/features/predict/widgets/week_range_picker.dart';

@RoutePage()
class PredictScreen extends StatelessWidget {
  const PredictScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PredictCubit, PredictState>(
      listenWhen: (prev, next) => prev.errorMessage != next.errorMessage,
      listener: (context, state) {
        final msg = state.errorMessage;
        if (msg == null || msg.isEmpty) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));

        context.read<PredictCubit>().clearError();
      },
      builder: (context, state) {
        final cubit = context.read<PredictCubit>();
        final boundaries = state.boundaries;

        final canPredict =
            !state.loading &&
            !state.predicting &&
            state.selectedRange != null &&
            state.selectedBarangay.trim().isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Predict'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const Gap(12),

                      WeekRangePicker(
                        initialMonth: DateTime.now(),
                        initialRange: state.selectedRange,
                        weekStartsOnMonday: true,
                        onWeekSelected: cubit.setDateRange,
                      ),

                      const Gap(12),

                      AppDropdownField<String>(
                        title: 'Barangay',
                        options: state.barangayOptions,
                        value: state.selectedBarangay.isEmpty
                            ? null
                            : state.selectedBarangay,
                        optionLabel: (b) => b,
                        onChanged: (b) => cubit.setBarangay(b, showPin: true),
                      ),

                      const Gap(12),

                      // ✅ This will now show spinner properly because:
                      // 1) predicting=true triggers rebuild
                      // 2) Monte Carlo runs off the UI isolate
                      AppElevatedButton(
                        width: double.infinity,
                        text: 'Predict',
                        isLoading: state.predicting,
                        onPressed: canPredict ? cubit.predict : null,
                      ),
                    ],
                  ),
                ),

                const Gap(12),

                Expanded(
                  child: state.loading
                      ? const Center(child: CircularProgressIndicator())
                      : (boundaries == null)
                      ? const Center(child: Text('Failed to load boundaries'))
                      : FloodRiskMap(
                          boundaries: boundaries,
                          riskDataMap: state.riskMap,
                          selectedBarangayName: state.selectedBarangay.isEmpty
                              ? null
                              : state.selectedBarangay,
                          showInfoPin: state.showInfoPin,
                          onClosePin: () => cubit.setInfoPinVisible(false),

                          // ✅ Tap polygon -> update Cubit -> dropdown updates
                          onBarangaySelected: (name) {
                            if (name == null) {
                              cubit.setInfoPinVisible(false);
                              cubit.setBarangay('', showPin: false);
                              return;
                            }
                            cubit.setBarangay(name, showPin: true);
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
