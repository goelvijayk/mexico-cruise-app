import 'package:mexico_cruise/data/db/tables.dart';

enum MultiDaySegment { first, middle, last, single }

MultiDaySegment segmentForDay({
  required DateTime startLocal,
  required DateTime? endLocal,
  required DateTime day,
}) {
  final start = startDay(startLocal)!;
  final end = endDay(startLocal, endLocal);
  final d = DateTime(day.year, day.month, day.day);
  if (start.isAtSameMomentAs(end)) return MultiDaySegment.single;
  if (d.isAtSameMomentAs(start)) return MultiDaySegment.first;
  if (d.isAtSameMomentAs(end)) return MultiDaySegment.last;
  return MultiDaySegment.middle;
}

String stripLabelForEvent({
  required String title,
  required DateTime startLocal,
  required DateTime? endLocal,
  required DateTime day,
}) {
  final start = startDay(startLocal)!;
  final end = endDay(startLocal, endLocal);
  final totalNights = end.difference(start).inDays;
  if (totalNights <= 0) return title;
  final nightIndex = DateTime(day.year, day.month, day.day)
          .difference(start)
          .inDays +
      1;
  return '$title · night $nightIndex of $totalNights';
}

DateTime defaultTimelineDay({
  required DateTime tripStart,
  required DateTime tripEnd,
  required DateTime now,
}) {
  final padStart = tripStart.subtract(const Duration(days: 1));
  final padEnd = tripEnd.add(const Duration(days: 1));
  final today = DateTime(now.year, now.month, now.day);
  if (!today.isBefore(padStart) && !today.isAfter(padEnd)) {
    return today;
  }
  return DateTime(tripStart.year, tripStart.month, tripStart.day);
}

List<DateTime> dayTabs({
  required DateTime tripStart,
  required DateTime tripEnd,
}) {
  final start = tripStart.subtract(const Duration(days: 1));
  final end = tripEnd.add(const Duration(days: 1));
  final days = <DateTime>[];
  var cursor = DateTime(start.year, start.month, start.day);
  final last = DateTime(end.year, end.month, end.day);
  while (!cursor.isAfter(last)) {
    days.add(cursor);
    cursor = cursor.add(const Duration(days: 1));
  }
  return days;
}
