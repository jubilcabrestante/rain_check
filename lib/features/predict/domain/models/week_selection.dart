class DateRange {
  final DateTime start;
  final DateTime end; // inclusive
  const DateRange(this.start, this.end);
}

DateRange weekRangeInMonth({
  required int year,
  required int month,
  required int weekOfMonth, // 1..6
}) {
  final firstDay = DateTime(year, month, 1);
  final lastDay = DateTime(year, month + 1, 0);

  // Monday=1 .. Sunday=7
  final firstWeekday = firstDay.weekday;
  final daysToFirstMonday = (firstWeekday == DateTime.monday)
      ? 0
      : (DateTime.monday + 7 - firstWeekday) % 7;

  final firstMonday = firstDay.add(Duration(days: daysToFirstMonday));
  final start = firstMonday.add(Duration(days: (weekOfMonth - 1) * 7));
  final end = start.add(const Duration(days: 6));

  // Clamp to within month
  final clampedStart = start.isBefore(firstDay) ? firstDay : start;
  final clampedEnd = end.isAfter(lastDay) ? lastDay : end;

  return DateRange(clampedStart, clampedEnd);
}
