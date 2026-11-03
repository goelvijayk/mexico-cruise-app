import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mexico_cruise/data/db/app_database.dart';

Future<void> seedLocalSampleData(AppDatabase db) async {
  final existing = await db.select(db.tripTable).get();
  if (existing.isNotEmpty) return;

  const tripId = 'mex-2026-12';
  final now = DateTime.now().toUtc();

  await db.into(db.tripTable).insert(
        TripTableCompanion.insert(
          id: tripId,
          name: 'Mexico Cruise Dec 2026',
          startDate: DateTime(2026, 12, 5),
          endDate: DateTime(2026, 12, 19),
          shipTimeZone: 'America/Los_Angeles',
          homeTimeZone: 'America/Chicago',
          updatedAt: now,
        ),
      );

  await db.into(db.events).insert(
        EventsCompanion.insert(
          id: 'b1000000-0000-4000-8000-000000000001',
          tripId: tripId,
          type: 'flight',
          title: 'UA 1234 SFO → LAX',
          startLocal: DateTime(2026, 12, 5, 9, 15),
          startTz: 'America/Los_Angeles',
          endLocal: Value(DateTime(2026, 12, 5, 10, 45)),
          endTz: const Value('America/Los_Angeles'),
          provider: const Value('United'),
          bookingRef: const Value('ABC123'),
          locationJson: const Value('{"name":"SFO"}'),
          detailsJson: const Value('{"flight_number":"1234"}'),
          sourceJson: jsonEncode({'kind': 'manual'}),
          createdAt: now,
          createdBy: 'sample',
          updatedAt: now,
          updatedBy: 'sample',
        ),
      );

  await db.into(db.events).insert(
        EventsCompanion.insert(
          id: 'b1000000-0000-4000-8000-000000000002',
          tripId: tripId,
          type: 'hotel',
          title: 'Pre-cruise hotel',
          startLocal: DateTime(2026, 12, 5, 15),
          startTz: 'America/Los_Angeles',
          endLocal: Value(DateTime(2026, 12, 7, 11)),
          endTz: const Value('America/Los_Angeles'),
          bookingRef: const Value('HTL-99'),
          sourceJson: jsonEncode({'kind': 'manual'}),
          createdAt: now,
          createdBy: 'sample',
          updatedAt: now,
          updatedBy: 'sample',
        ),
      );

  await db.setSyncValue('device_nickname', 'Demo Pixel');
  await db.setSyncValue('display_tz_mode', 'event_local');
}
