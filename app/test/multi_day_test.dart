import 'package:flutter_test/flutter_test.dart';
import 'package:mexico_cruise/data/db/tables.dart';
import 'package:mexico_cruise/domain/timeline/multi_day.dart';

void main() {
  test('multi-day event spans each day', () {
    final start = DateTime(2026, 12, 5, 15);
    final end = DateTime(2026, 12, 7, 11);
    expect(
      eventSpansDay(startLocal: start, endLocal: end, day: DateTime(2026, 12, 6)),
      isTrue,
    );
    expect(
      eventSpansDay(startLocal: start, endLocal: end, day: DateTime(2026, 12, 4)),
      isFalse,
    );
  });

  test('segment labels middle nights', () {
    final start = DateTime(2026, 12, 5, 15);
    final end = DateTime(2026, 12, 7, 11);
    expect(
      segmentForDay(
        startLocal: start,
        endLocal: end,
        day: DateTime(2026, 12, 6),
      ),
      MultiDaySegment.middle,
    );
    expect(
      stripLabelForEvent(
        title: 'Hotel',
        startLocal: start,
        endLocal: end,
        day: DateTime(2026, 12, 6),
      ),
      contains('night'),
    );
  });

  test('default tab is today when in trip range', () {
    final day = defaultTimelineDay(
      tripStart: DateTime(2026, 12, 5),
      tripEnd: DateTime(2026, 12, 19),
      now: DateTime(2026, 12, 10),
    );
    expect(day, DateTime(2026, 12, 10));
  });
}
