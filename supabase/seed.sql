insert into trip (id, name, start_date, end_date, ship_time_zone, home_time_zone, default_currency, updated_at)
values (
  'mex-2026-12',
  'Mexico Cruise Dec 2026',
  '2026-12-05',
  '2026-12-19',
  'America/Los_Angeles',
  'America/Chicago',
  'USD',
  now()
)
on conflict (id) do nothing;

insert into events (
  id, trip_id, type, status, title, start_local, start_tz, end_local, end_tz, all_day,
  location, provider, booking_ref, details, travelers, notes, source,
  review_state, edited_fields, field_meta, created_at, created_by, updated_at, updated_by
) values
(
  'a1000000-0000-4000-8000-000000000001',
  'mex-2026-12',
  'flight',
  'confirmed',
  'UA 1234 SFO → LAX',
  '2026-12-05 09:15:00',
  'America/Los_Angeles',
  '2026-12-05 10:45:00',
  'America/Los_Angeles',
  false,
  '{"name":"San Francisco International","city":"San Francisco"}'::jsonb,
  'United',
  'ABC123',
  '{"flight_number":"1234","from_iata":"SFO","to_iata":"LAX"}'::jsonb,
  array['Alex','Jordan'],
  'Arrive 2 hours early.',
  '{"kind":"manual"}'::jsonb,
  'none',
  '{}',
  '{}',
  now(), 'seed', now(), 'seed'
),
(
  'a1000000-0000-4000-8000-000000000002',
  'mex-2026-12',
  'hotel',
  'confirmed',
  'Embarkation hotel — Night 1',
  '2026-12-05 15:00:00',
  'America/Los_Angeles',
  '2026-12-07 11:00:00',
  'America/Los_Angeles',
  false,
  '{"name":"Harbor View Inn","city":"San Diego"}'::jsonb,
  'Harbor View',
  'HTL-9988',
  '{"room_type":"King","night":1}'::jsonb,
  array['Family'],
  null,
  '{"kind":"manual"}'::jsonb,
  'none',
  '{}',
  '{}',
  now(), 'seed', now(), 'seed'
),
(
  'a1000000-0000-4000-8000-000000000003',
  'mex-2026-12',
  'cruise_embark',
  'confirmed',
  'Embark Carnival Radiance',
  '2026-12-07 13:00:00',
  'America/Los_Angeles',
  null,
  null,
  false,
  '{"name":"B Street Cruise Terminal","pier":"2"}'::jsonb,
  'Carnival',
  'CRN-554433',
  '{"ship":"Radiance","line":"Carnival","cabin_number":"8234"}'::jsonb,
  array['Family'],
  null,
  '{"kind":"manual"}'::jsonb,
  'none',
  '{}',
  '{}',
  now(), 'seed', now(), 'seed'
)
on conflict (id) do nothing;
