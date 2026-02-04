import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_drop_down_field.dart';
import 'package:rain_check/core/utils/data_loader.dart';
import 'package:rain_check/features/predict/data/monte_carlo_flood_service.dart';
import 'package:rain_check/features/predict/domain/predict_cubit.dart';
import 'package:rain_check/features/predict/widgets/flood_risk_map.dart';
import 'package:rain_check/features/predict/widgets/week_range_picker.dart';

@RoutePage()
class PredictScreen extends StatelessWidget {
  const PredictScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PredictCubit(
        loader: DataLoader(),
        monteCarloService: MonteCarloFloodService(),
      )..loadData(),
      child: const _PredictView(),
    );
  }
}

class _PredictView extends StatelessWidget {
  const _PredictView();

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
                        onChanged: cubit.setBarangay,
                      ),

                      const Gap(12),

                      AppElevatedButton(
                        width: double.infinity,
                        text: state.predicting ? "Predicting..." : "Predict",
                        onPressed: state.predicting ? null : cubit.predict,
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
