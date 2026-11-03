import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/features/event_form/event_form_screen.dart';
import 'package:mexico_cruise/providers/app_providers.dart';
import 'package:uuid/uuid.dart';

class RevisionSheet extends ConsumerStatefulWidget {
  const RevisionSheet({super.key, required this.event});

  final Event event;

  @override
  ConsumerState<RevisionSheet> createState() => _RevisionSheetState();
}

class _RevisionSheetState extends ConsumerState<RevisionSheet> {
  final _note = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Something's wrong",
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          FutureBuilder<bool>(
            future: db.hasOpenRevisionForEvent(widget.event.id),
            builder: (context, snap) {
              if (snap.data == true) {
                return const Text(
                  'An open revision request already exists for this event.',
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _note,
                    decoration: const InputDecoration(
                      labelText: "What's wrong?",
                    ),
                    maxLines: 3,
                  ),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _fromEmail ? _askParser : null,
                    child: const Text('Ask the email parser to re-check'),
                  ),
                  OutlinedButton(
                    onPressed: _fixMyself,
                    child: const Text("I'll fix it myself"),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  bool get _fromEmail {
    final src = jsonDecode(widget.event.sourceJson) as Map<String, dynamic>;
    return src['kind'] == 'email';
  }

  Future<void> _askParser() async {
    if (_note.text.trim().isEmpty) {
      setState(() => _error = 'Please describe the issue');
      return;
    }
    if (await ref.read(databaseProvider).hasOpenRevisionForEvent(widget.event.id)) {
      setState(() => _error = 'Open request already exists');
      return;
    }
    final db = ref.read(databaseProvider);
    final nick = await db.syncValue('device_nickname') ?? 'Traveler';
    final now = DateTime.now().toUtc();
    final id = const Uuid().v4();
    await db.into(db.revisionRequests).insert(
          RevisionRequestsCompanion.insert(
            id: id,
            eventId: widget.event.id,
            note: _note.text.trim(),
            requestedBy: nick,
            requestedAt: now,
            updatedAt: now,
            dirty: const Value(true),
          ),
        );
    await ref.read(eventRepositoryProvider).saveEventFields(
          eventId: widget.event.id,
          changedFields: {'review_state': 'flagged'},
          updatedBy: nick,
          updatedAt: now,
          tripId: widget.event.tripId,
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _fixMyself() async {
    final note = _note.text.trim();
    if (note.isNotEmpty) {
      final nick = await ref.read(databaseProvider).syncValue('device_nickname') ??
          'Traveler';
      final prefix = 'Fix: $note';
      final existingNotes = widget.event.notes;
      final merged = existingNotes == null ? prefix : '$prefix\n$existingNotes';
      await ref.read(eventRepositoryProvider).saveEventFields(
            eventId: widget.event.id,
            changedFields: {'notes': merged},
            updatedBy: nick,
            updatedAt: DateTime.now().toUtc(),
            tripId: widget.event.tripId,
          );
    }
    if (!mounted) return;
    Navigator.pop(context);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EventFormScreen(existing: widget.event),
      ),
    );
  }
}
