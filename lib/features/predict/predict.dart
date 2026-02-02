import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/repository/flood_model/barangay_boundaries_model.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_drop_down_field.dart';
import 'package:rain_check/core/utils/data_loader.dart';
import 'package:rain_check/features/predict/domain/models/barangay_flood_risk.dart';
import 'package:rain_check/features/predict/widgets/flood_risk_map.dart';
import 'package:rain_check/features/predict/widgets/week_range_picker.dart';

@RoutePage()
class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  final DateTime _initialMonth = DateTime.now();
  DateTimeRange? _selectedWeek;

  BarangayBoundariesCollection? _boundaries;

  List<String> _barangayOptions = const [];
  String? _selectedBarangay;

  Map<String, BarangayFloodRisk> _riskMap = const {};

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() => _loading = true);

    final loader = DataLoader();
    final boundaries = await loader.loadBarangayBoundaries();

    final names =
        boundaries.features.map((f) => f.properties.brgyName).toSet().toList()
          ..sort();

    // ✅ TEMP: give each barangay a default Low risk so polygons have fill color.
    final riskMap = <String, BarangayFloodRisk>{
      for (final name in names) name: BarangayFloodRisk.defaultLow(name),
    };

    setState(() {
      _boundaries = boundaries;
      _barangayOptions = names;
      _riskMap = riskMap;
      _loading = false;
    });
  }

  void _computeForRange(DateTimeRange range) {
    // Later: compute real risk map based on selected week
    // setState(() => _riskMap = computedMap);
  }

  void _onSelectBarangay(String? name) {
    if (name == null) return;
    setState(() => _selectedBarangay = name);
  }

  @override
  Widget build(BuildContext context) {
    final boundaries = _boundaries;

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
                  Gap(12),
                  WeekRangePicker(
                    initialMonth: _initialMonth,
                    initialRange: _selectedWeek,
                    weekStartsOnMonday: true,
                    onWeekSelected: (range) {
                      setState(() => _selectedWeek = range);
                      _computeForRange(range);
                    },
                  ),
                  Gap(12),
                  AppDropdownField<String>(
                    title: 'Barangay',
                    options: _barangayOptions,
                    value: _selectedBarangay,
                    optionLabel: (b) => b,
                    onChanged: _onSelectBarangay,
                  ),
                  Gap(12),
                  AppElevatedButton(width: double.infinity, text: "Predict"),
                ],
              ),
            ),
            Gap(12),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : (boundaries == null)
                  ? const Center(child: Text('Failed to load boundaries'))
                  : FloodRiskMap(
                      boundaries: boundaries,
                      riskDataMap: _riskMap,
                      selectedBarangayName: _selectedBarangay, // ✅ add this
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
