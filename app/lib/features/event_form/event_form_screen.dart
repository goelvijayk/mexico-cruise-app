import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/providers/app_providers.dart';
import 'package:uuid/uuid.dart';

const _eventTypes = [
  'flight',
  'hotel',
  'cruise_embark',
  'cruise_disembark',
  'port_call',
  'sea_day',
  'excursion',
  'transfer',
  'dining',
  'meetup',
  'other',
];

class EventFormScreen extends ConsumerStatefulWidget {
  const EventFormScreen({super.key, this.existing});

  final Event? existing;

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late TextEditingController _title;
  late TextEditingController _provider;
  late TextEditingController _bookingRef;
  late TextEditingController _notes;
  late TextEditingController _locationName;
  late DateTime _start;
  late DateTime? _end;
  late String _startTz;
  bool _allDay = false;
  String _status = 'confirmed';

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _type = e?.type ?? 'other';
    _title = TextEditingController(text: e?.title ?? '');
    _provider = TextEditingController(text: e?.provider ?? '');
    _bookingRef = TextEditingController(text: e?.bookingRef ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _locationName = TextEditingController(
      text: e?.locationJson == null
          ? ''
          : (jsonDecode(e!.locationJson!) as Map)['name']?.toString() ?? '',
    );
    _start = e?.startLocal ?? DateTime(2026, 12, 5, 9);
    _end = e?.endLocal;
    _startTz = e?.startTz ?? 'America/Los_Angeles';
    _allDay = e?.allDay ?? false;
    _status = e?.status ?? 'confirmed';
  }

  @override
  void dispose() {
    _title.dispose();
    _provider.dispose();
    _bookingRef.dispose();
    _notes.dispose();
    _locationName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit event' : 'Add event')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: _type,
              items: [
                for (final t in _eventTypes)
                  DropdownMenuItem(value: t, child: Text(t)),
              ],
              onChanged: (v) => setState(() => _type = v ?? 'other'),
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextFormField(
              key: const Key('event_title'),
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title required' : null,
            ),
            DropdownButtonFormField<String>(
              value: _status,
              items: const [
                DropdownMenuItem(value: 'confirmed', child: Text('confirmed')),
                DropdownMenuItem(value: 'tentative', child: Text('tentative')),
                DropdownMenuItem(value: 'cancelled', child: Text('cancelled')),
              ],
              onChanged: (v) => setState(() => _status = v ?? 'confirmed'),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            SwitchListTile(
              title: const Text('All day'),
              value: _allDay,
              onChanged: (v) => setState(() => _allDay = v),
            ),
            ListTile(
              title: const Text('Start'),
              subtitle: Text('$_start · $_startTz'),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2026, 1, 1),
                  lastDate: DateTime(2027, 1, 1),
                  initialDate: _start,
                );
                if (date == null || !context.mounted) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_start),
                );
                if (time == null) return;
                setState(() {
                  _start = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                });
              },
            ),
            TextFormField(
              initialValue: _startTz,
              decoration: const InputDecoration(labelText: 'Start time zone'),
              onChanged: (v) => _startTz = v,
            ),
            TextFormField(
              controller: _locationName,
              decoration: const InputDecoration(labelText: 'Location name'),
            ),
            TextFormField(
              controller: _provider,
              decoration: const InputDecoration(labelText: 'Provider'),
            ),
            TextFormField(
              controller: _bookingRef,
              decoration: const InputDecoration(labelText: 'Booking ref'),
            ),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('save_event'),
              onPressed: _save,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_end != null && _end!.isBefore(_start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End must be after start')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final repo = ref.read(eventRepositoryProvider);
    final nick = await db.syncValue('device_nickname') ?? 'Traveler';
    final trip = await db.select(db.tripTable).getSingleOrNull();
    final tripId = trip?.id ?? widget.existing?.tripId ?? 'mex-2026-12';
    final now = DateTime.now().toUtc();
    final eventId = widget.existing?.id ?? const Uuid().v4();

    final location =
        _locationName.text.trim().isEmpty
            ? null
            : {'name': _locationName.text.trim()};

    final changed = <String, Object?>{
      'type': _type,
      'status': _status,
      'title': _title.text.trim(),
      'start_local': _start.toIso8601String(),
      'start_tz': _startTz,
      'all_day': _allDay,
      'provider': _provider.text.trim().isEmpty ? null : _provider.text.trim(),
      'booking_ref':
          _bookingRef.text.trim().isEmpty ? null : _bookingRef.text.trim(),
      'notes': _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      'location': location,
    };

    await repo.saveEventFields(
      eventId: eventId,
      changedFields: changed,
      updatedBy: nick,
      updatedAt: now,
      tripId: tripId,
      bootstrap: widget.existing == null
          ? {
              'type': _type,
              'title': _title.text.trim(),
              'start_local': _start.toIso8601String(),
              'start_tz': _startTz,
              'source': {'kind': 'manual'},
            }
          : null,
    );

    if (mounted) Navigator.pop(context);
  }
}
