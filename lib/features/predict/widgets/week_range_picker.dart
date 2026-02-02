import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class WeekRangePicker extends StatefulWidget {
  final DateTime initialMonth;
  final DateTimeRange? initialRange;
  final bool weekStartsOnMonday;
  final ValueChanged<DateTimeRange> onWeekSelected;
  final String placeholderText;

  const WeekRangePicker({
    super.key,
    required this.initialMonth,
    required this.onWeekSelected,
    this.initialRange,
    this.weekStartsOnMonday = true,
    this.placeholderText = 'Select week',
  });

  @override
  State<WeekRangePicker> createState() => _WeekRangePickerState();
}

class _WeekRangePickerState extends State<WeekRangePicker> {
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange;
  }

  @override
  void didUpdateWidget(covariant WeekRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ If parent passes a different initialRange, update local state
    if (oldWidget.initialRange != widget.initialRange) {
      setState(() => _selectedRange = widget.initialRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final label = _selectedRange == null
        ? widget.placeholderText
        : '${_formatPretty(_selectedRange!.start)} - ${_formatPretty(_selectedRange!.end)}';

    return OutlinedButton(
      onPressed: _openCalendarDialog,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium,
            ),
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  Future<void> _openCalendarDialog() async {
    List<DateTime?> selected = _selectedRange == null
        ? <DateTime?>[]
        : <DateTime?>[
            _stripTime(_selectedRange!.start),
            _stripTime(_selectedRange!.end),
          ];

    final result = await showDialog<DateTimeRange>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final textTheme = Theme.of(context).textTheme;

            final screenW = MediaQuery.of(ctx).size.width;
            final screenH = MediaQuery.of(ctx).size.height;

            // ✅ responsive dialog size (NO LayoutBuilder)
            final dialogW = (screenW - 32).clamp(320.0, 460.0);
            final dialogH = (screenH * 0.32).clamp(320.0, 460.0);

            final config = CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.range,
              firstDayOfWeek: widget.weekStartsOnMonday ? 1 : 7,

              // ✅ header height (avoid vertical overflow)
              controlsHeight: 56,
              modePickersGap: 6,

              // ✅ prevent horizontal scroll -> fit 7 days
              dayMaxWidth: 38, // try 36 if still tight on small screens
              weekdayLabelTextStyle: const TextStyle(fontSize: 11),
              dayTextStyle: const TextStyle(fontSize: 12),
              selectedDayTextStyle: const TextStyle(fontSize: 12),
              selectedDayHighlightColor: Theme.of(ctx).colorScheme.primary,
              selectedRangeHighlightColor: Theme.of(
                ctx,
              ).colorScheme.primary.withValues(alpha: 0.20),

              daySplashColor: Colors.transparent,
              disableMonthPicker: false,
              currentDate: DateTime.now(),
            );

            return AlertDialog(
              title: Text('Select Week', style: textTheme.headlineSmall),
              contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),

              // ✅ IMPORTANT: fixed-size content so AlertDialog doesn't need intrinsics
              content: SizedBox(
                width: dialogW,
                height: dialogH,
                child: CalendarDatePicker2(
                  config: config,
                  value: selected,
                  onValueChanged: (dates) {
                    final tapped = _getLastNonNullDate(dates);
                    if (tapped == null) return;

                    final week = _getFullWeekRange(
                      date: tapped,
                      weekStartsOnMonday: widget.weekStartsOnMonday,
                    );

                    setDialogState(() => selected = [week.start, week.end]);
                  },
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed:
                      selected.length < 2 || selected.any((d) => d == null)
                      ? null
                      : () {
                          Navigator.of(ctx).pop(
                            DateTimeRange(
                              start: selected[0]!,
                              end: selected[1]!,
                            ),
                          );
                        },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;

    setState(() => _selectedRange = result);
    widget.onWeekSelected(result);
  }

  DateTime? _getLastNonNullDate(List<DateTime?> dates) {
    for (var i = dates.length - 1; i >= 0; i--) {
      final d = dates[i];
      if (d != null) return _stripTime(d);
    }
    return null;
  }

  DateTime _stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTimeRange _getFullWeekRange({
    required DateTime date,
    required bool weekStartsOnMonday,
  }) {
    final d = _stripTime(date);

    final weekStartDay = weekStartsOnMonday ? DateTime.monday : DateTime.sunday;
    final diffToStart = (d.weekday - weekStartDay + 7) % 7;

    final start = d.subtract(Duration(days: diffToStart));
    final end = start.add(const Duration(days: 6));

    return DateTimeRange(start: start, end: end);
  }

  String _formatPretty(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final m = months[d.month - 1];
    return '$m ${d.day}, ${d.year}';
  }
}
