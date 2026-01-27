import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_drop_down_field.dart';
import 'package:rain_check/core/utils/flood_data_extensions.dart';
import 'package:rain_check/features/calculate/domain/cubit/calculate_cubit.dart';
import 'package:rain_check/features/calculate/flood_data_service.dart';

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
      builder: (context, state) {
        final calculateCubit = context.read<CalculateCubit>();

        if (state.loadingBarangays) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Calculate Flood Risk')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Rainfall Intensity Dropdown
                AppDropdownField<RainfallIntensity>(
                  title: 'Rainfall Intensity',
                  value: state.selectedIntensity,
                  options: RainfallIntensity.values.toList(),
                  optionLabel: (intensity) => _getRainfallLabel(intensity),
                  onChanged: (intensity) =>
                      calculateCubit.setRainfall(intensity!),
                ),

                const SizedBox(height: 16),

                // Barangay Dropdown
                AppDropdownField<String>(
                  title: "Barangay",
                  value: state.selectedBarangay,
                  options: state.barangays,
                  optionLabel: (barangay) => barangay,
                  onChanged: (barangay) =>
                      calculateCubit.setBarangay(barangay!),
                ),

                const SizedBox(height: 32),

                // Calculate Button
                AppElevatedButton(
                  text: 'Calculate Flood Risk',
                  isLoading: state.calculating,
                  onPressed:
                      state.selectedBarangay == null ||
                          state.selectedIntensity == null
                      ? null
                      : calculateCubit.calculate,
                ),

                // Result Card
                if (state.result != null) ...[
                  const SizedBox(height: 32),
                  _ResultCard(result: state.result!, state: state),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _getRainfallLabel(RainfallIntensity intensity) {
    switch (intensity) {
      case RainfallIntensity.low:
        return 'Low (170-200 mm)';
      case RainfallIntensity.moderate:
        return 'Moderate (200-300 mm)';
      case RainfallIntensity.high:
        return 'High (300-400 mm)';
    }
  }
}

class _ResultCard extends StatelessWidget {
  final FloodCalculationResult result;
  final CalculateState state;

  const _ResultCard({required this.result, required this.state});

  @override
  Widget build(BuildContext context) {
    // Determine color based on risk level
    Color getRiskColor() {
      if (!result.hasFloodRisk) return Colors.green;

      switch (result.overallRiskLevel) {
        case FloodRiskLevel.high:
          return Colors.red;
        case FloodRiskLevel.moderate:
          return Colors.orange;
        case FloodRiskLevel.low:
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    final riskColor = getRiskColor();

    return Card(
      elevation: 4,
      color: riskColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Icon(
                  result.hasFloodRisk ? Icons.warning : Icons.check_circle,
                  color: riskColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.hasFloodRisk
                            ? 'FLOOD RISK DETECTED'
                            : 'LOW FLOOD RISK',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: riskColor,
                        ),
                      ),
                      Text(
                        result.riskLevelDisplay,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Message
            Text(
              result.message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 16),

            // Details
            _buildDetailRow('Barangay', result.barangayName),
            _buildDetailRow(
              'Rainfall',
              '${result.rainfallInMm.toStringAsFixed(0)} mm',
            ),
            _buildDetailRow('Intensity', result.rainfallIntensityDisplay),
            _buildDetailRow('Affected Area', result.formattedAffectedArea),

            // Risk Zones (if available)
            if (result.highRiskZones != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Risk Zones:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildZoneRow('High Risk', result.highRiskZones!, Colors.red),
              _buildZoneRow(
                'Moderate Risk',
                result.moderateRiskZones!,
                Colors.orange,
              ),
              _buildZoneRow('Low Risk', result.lowRiskZones!, Colors.green),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildZoneRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            '$count',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
