class DateRangeFilter {
  final DateTime start;
  final DateTime end;

  const DateRangeFilter({required this.start, required this.end});

  factory DateRangeFilter.lastMonths(int months) {
    final now = DateTime.now();
    return DateRangeFilter(
      start: DateTime(now.year, now.month - months + 1, 1),
      end: now,
    );
  }

  factory DateRangeFilter.currentMonth() {
    final now = DateTime.now();
    return DateRangeFilter(
      start: DateTime(now.year, now.month, 1),
      end: now,
    );
  }
}
