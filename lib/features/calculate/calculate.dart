import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_drop_down_field.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';
import 'package:rain_check/features/calculate/domain/cubit/calculate_cubit.dart';
import 'package:rain_check/features/calculate/flood_data_service.dart';
import 'package:rain_check/features/calculate/flood_risk_logistic_regression_calibrated.dart';

@RoutePage()
class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => CalculateScreenState();
}

class CalculateScreenState extends State<CalculateScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalculateCubit, CalculateState>(
      // Only listen to error messages to avoid unnecessary rebuilds
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      // Optimize rebuilds by checking what actually changed
      buildWhen: (previous, current) =>
          previous.loadingBarangays != current.loadingBarangays ||
          previous.selectedIntensity != current.selectedIntensity ||
          previous.selectedBarangay != current.selectedBarangay ||
          previous.calculating != current.calculating ||
          previous.result != current.result ||
          previous.barangays != current.barangays,
      builder: (context, state) {
        if (state.loadingBarangays) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return _CalculateScreenContent(state: state);
      },
    );
  }
}

/// Separate widget to prevent unnecessary rebuilds of the entire scaffold
class _CalculateScreenContent extends StatelessWidget {
  final CalculateState state;

  const _CalculateScreenContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate Flood Risk'),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Use builder to only rebuild dropdown when state changes
            _RainfallIntensityField(selectedIntensity: state.selectedIntensity),

            const SizedBox(height: 16),

            _BarangayField(
              selectedBarangay: state.selectedBarangay,
              barangays: state.barangays,
            ),

            const SizedBox(height: 32),

            _CalculateButton(
              calculating: state.calculating,
              canCalculate:
                  state.selectedBarangay != null &&
                  state.selectedIntensity != null,
            ),

            if (state.result != null) ...[
              const SizedBox(height: 32),
              _MLResultCard(result: state.result!),
            ],
          ],
        ),
      ),
    );
  }
}

/// Optimized rainfall intensity field that only rebuilds when its value changes
class _RainfallIntensityField extends StatelessWidget {
  final RainfallIntensity? selectedIntensity;

  const _RainfallIntensityField({required this.selectedIntensity});

  @override
  Widget build(BuildContext context) {
    return AppDropdownField<RainfallIntensity>(
      title: 'Rainfall Intensity',
      value: selectedIntensity,
      options: RainfallIntensity.values.toList(),
      optionLabel: (intensity) => intensity.display,
      onChanged: (intensity) {
        if (intensity != null) {
          context.read<CalculateCubit>().setRainfall(intensity);
        }
      },
    );
  }
}

/// Optimized barangay field that only rebuilds when its value changes
class _BarangayField extends StatelessWidget {
  final String? selectedBarangay;
  final List<String> barangays;

  const _BarangayField({
    required this.selectedBarangay,
    required this.barangays,
  });

  @override
  Widget build(BuildContext context) {
    return AppDropdownField<String>(
      title: "Barangay",
      value: selectedBarangay,
      options: barangays,
      optionLabel: (barangay) => barangay,
      onChanged: (barangay) {
        if (barangay != null) {
          context.read<CalculateCubit>().setBarangay(barangay);
        }
      },
    );
  }
}

/// Optimized calculate button that only rebuilds when necessary
class _CalculateButton extends StatelessWidget {
  final bool calculating;
  final bool canCalculate;

  const _CalculateButton({
    required this.calculating,
    required this.canCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return AppElevatedButton(
      text: 'Calculate Flood Risk',
      isLoading: calculating,
      onPressed: canCalculate
          ? () => context.read<CalculateCubit>().calculate()
          : null,
    );
  }
}

/// Optimized result card with const constructors where possible
class _MLResultCard extends StatelessWidget {
  final LogisticFloodResult result;

  const _MLResultCard({required this.result});

  // Cache color calculation to avoid recalculating on every build
  Color _getRiskColor() {
    switch (result.predictedRiskLevel) {
      case FloodRiskLevel.high:
        return AppColors.highRiskRed;
      case FloodRiskLevel.moderate:
        return AppColors.moderateRiskYellow;
      case FloodRiskLevel.low:
      default:
        return AppColors.lowRiskGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = _getRiskColor();
    final probability = result.floodProbability;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: riskColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Optimize layout calculation
        children: [
          _ResultCardHeader(riskColor: riskColor),
          _ResultCardBody(
            result: result,
            riskColor: riskColor,
            probability: probability,
          ),
        ],
      ),
    );
  }
}

/// Separate header widget to avoid rebuilding body unnecessarily
class _ResultCardHeader extends StatelessWidget {
  final Color riskColor;

  const _ResultCardHeader({required this.riskColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Optimize layout
        children: [
          Icon(Icons.warning, color: AppColors.error, size: 20),
          SizedBox(width: 8),
          Text(
            'CURRENT FLOOD RISK',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.warning, color: AppColors.error, size: 20),
        ],
      ),
    );
  }
}

/// Separate body widget for better organization and optimization
class _ResultCardBody extends StatelessWidget {
  final LogisticFloodResult result;
  final Color riskColor;
  final double probability;

  const _ResultCardBody({
    required this.result,
    required this.riskColor,
    required this.probability,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RiskBar(probability: probability),
          const SizedBox(height: 24),
          _RiskStatusText(
            hasFloodRisk: result.hasFloodRisk,
            riskColor: riskColor,
          ),
          const SizedBox(height: 16),
          Text(
            result.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 24),
          _StatisticsSection(result: result),
        ],
      ),
    );
  }
}

/// Optimized risk bar widget
class _RiskBar extends StatelessWidget {
  final double probability;

  const _RiskBar({required this.probability});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate indicator position based on actual width
              final barWidth = constraints.maxWidth;
              final indicatorPosition = (probability * barWidth).clamp(
                0.0,
                barWidth - 4,
              );

              return RepaintBoundary(
                // Prevent repainting of parent widgets
                child: Stack(
                  children: [
                    // Background gradient bar - const gradient for performance
                    Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.lowRiskGreen,
                            AppColors.moderateRiskYellow,
                            AppColors.highRiskRed,
                          ],
                        ),
                      ),
                    ),
                    // Indicator
                    Positioned(
                      left: indicatorPosition,
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
              );
            },
          ),
          const SizedBox(height: 8),
          // Labels - const for better performance
          const _RiskLabels(),
        ],
      ),
    );
  }
}

/// Const widget for risk labels - never needs to rebuild
class _RiskLabels extends StatelessWidget {
  const _RiskLabels();

  @override
  Widget build(BuildContext context) {
    return const Row(
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
    );
  }
}

/// Optimized risk status text widget
class _RiskStatusText extends StatelessWidget {
  final bool hasFloodRisk;
  final Color riskColor;

  const _RiskStatusText({required this.hasFloodRisk, required this.riskColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      hasFloodRisk ? 'OH NO!' : 'ALL CLEAR!',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: riskColor,
        letterSpacing: 2,
      ),
    );
  }
}

/// Statistics section with optimized stat rows
class _StatisticsSection extends StatelessWidget {
  final LogisticFloodResult result;

  const _StatisticsSection({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatRow(label: 'Barangay', value: result.barangayName),
        _StatRow(
          label: 'Rainfall',
          value: '${result.rainfallInMm.toStringAsFixed(0)} mm',
        ),
        _StatRow(label: 'Probability', value: result.formattedProbability),
        _StatRow(label: 'Risk Level', value: result.riskLevelDisplay),
        _StatRow(label: 'Confidence', value: result.riskConfidence),
      ],
    );
  }
}

/// Optimized stat row widget
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
