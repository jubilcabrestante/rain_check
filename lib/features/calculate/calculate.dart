// lib/features/calculate/presentation/calculate_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_drop_down_field.dart';
import 'package:rain_check/features/calculate/domain/cubit/calculate_cubit.dart';
import 'package:rain_check/features/calculate/widgets/flood_risk_logistic_regression_calibrated.dart';

@RoutePage()
class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  final _rainController = TextEditingController();

  @override
  void dispose() {
    _rainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalculateCubit, CalculateState>(
      listenWhen: (p, c) => p.errorMessage != c.errorMessage,
      listener: (context, state) {
        final msg = state.errorMessage;
        if (msg == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calculate Flood Risk'),
          backgroundColor: AppColors.background,
        ),
        body: BlocBuilder<CalculateCubit, CalculateState>(
          buildWhen: (p, c) =>
              p.loadingBarangays != c.loadingBarangays ||
              p.calculating != c.calculating ||
              p.result != c.result ||
              p.rainfallInMm != c.rainfallInMm,
          builder: (context, state) {
            if (state.loadingBarangays) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ✅ NEW rainfall input
                  TextFormField(
                    controller: _rainController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Rainfall (mm)',
                      hintText: 'e.g. 250',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      final mm = double.tryParse(v.trim());
                      context.read<CalculateCubit>().setRainfallMm(mm);
                    },
                  ),

                  const SizedBox(height: 16),

                  BlocSelector<CalculateCubit, CalculateState, _BarangayVm>(
                    selector: (s) =>
                        _BarangayVm(s.selectedBarangay, s.barangays),
                    builder: (context, vm) {
                      return AppDropdownField<String>(
                        title: 'Barangay',
                        value: vm.selected,
                        options: vm.options,
                        optionLabel: (e) => e,
                        onChanged: (v) {
                          if (v != null) {
                            context.read<CalculateCubit>().setBarangay(v);
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                  _CalculateButton(isLoading: state.calculating),

                  if (state.result != null) ...[
                    const SizedBox(height: 32),
                    FloodResultCard(result: state.result!),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CalculateButton extends StatelessWidget {
  final bool isLoading;
  const _CalculateButton({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final canCalculate = context.select<CalculateCubit, bool>((cubit) {
      final s = cubit.state;
      return (s.selectedBarangay != null && s.selectedBarangay!.isNotEmpty) &&
          (s.rainfallInMm != null);
    });

    return AppElevatedButton(
      text: 'Calculate Flood Risk',
      isLoading: isLoading,
      onPressed: canCalculate
          ? () => context.read<CalculateCubit>().calculate()
          : null,
    );
  }
}

class FloodResultCard extends StatelessWidget {
  final LogisticFloodResult result;
  const FloodResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final riskColor = _hexToColor(result.predictedRiskLevel.colorHex);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: riskColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _RiskBar(probability: result.floodProbability),
            const SizedBox(height: 16),
            Text(
              result.predictedRiskLevel.displayName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: riskColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(result.message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            _StatRow(label: 'Barangay', value: result.barangayName),
            _StatRow(
              label: 'Rainfall',
              value: '${result.rainfallInMm.toStringAsFixed(0)} mm',
            ),
            _StatRow(label: 'Probability', value: result.formattedProbability),
            _StatRow(label: 'Confidence', value: result.riskConfidence),
          ],
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class _RiskBar extends StatelessWidget {
  final double probability; // 0..1
  const _RiskBar({required this.probability});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final left = (probability * width).clamp(0.0, width - 4);

        return Column(
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.lowRiskGreen,
                    AppColors.moderateRiskYellow,
                    AppColors.highRiskRed,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: left,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LOW',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  'MODERATE',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  'HIGH',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _BarangayVm {
  final String? selected;
  final List<String> options;
  const _BarangayVm(this.selected, this.options);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _BarangayVm &&
          selected == other.selected &&
          _listEquals(options, other.options);

  @override
  int get hashCode => Object.hash(selected, options.length);
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
