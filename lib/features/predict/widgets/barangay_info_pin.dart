// lib/features/map/widgets/barangay_info_pin.dart

import 'package:flutter/material.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/enum/flood_risk_level.dart';
import 'package:rain_check/features/predict/domain/models/barangay_flood_risk.dart';

class BarangayInfoPin extends StatelessWidget {
  final BarangayFloodRisk riskData;
  final VoidCallback? onClose;

  const BarangayInfoPin({super.key, required this.riskData, this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = _hexToColor(riskData.riskLevel.colorHex);

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: AppColors.textWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      riskData.barangayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (onClose != null)
                    InkWell(
                      onTap: onClose,
                      child: const Icon(
                        Icons.close,
                        color: AppColors.textWhite,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    icon: Icons.warning_rounded,
                    label: 'Risk Level',
                    value: riskData.riskLevel.displayName,
                    valueColor: headerColor,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.water_drop,
                    label: 'Flood Probability',
                    value: '${riskData.floodProbability.toStringAsFixed(1)}%',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.cloudy_snowing,
                    label: 'Rainfall Intensity',
                    value:
                        '${riskData.rainfallIntensity.toStringAsFixed(1)} mm',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.thermostat,
                    label: 'Category',
                    value: _getRainAmountText(riskData.rainfallCategory),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                size: const Size(20, 10),
                painter: _PinPointerPainter(color: headerColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRainAmountText(RainAmount amount) {
    switch (amount) {
      case RainAmount.low:
        return 'Light Rain';
      case RainAmount.moderate:
        return 'Moderate Rain';
      case RainAmount.high:
        return 'Heavy Rain';
    }
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textGrey,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textBlack,
          ),
        ),
      ],
    );
  }
}

class _PinPointerPainter extends CustomPainter {
  final Color color;
  _PinPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2 - 10, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width / 2 + 10, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
