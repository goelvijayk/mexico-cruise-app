import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/data/db/tables.dart';
import 'package:mexico_cruise/features/documents/document_viewer.dart';
import 'package:mexico_cruise/features/event_form/event_form_screen.dart';
import 'package:mexico_cruise/features/revision/revision_sheet.dart';
import 'package:mexico_cruise/providers/app_providers.dart';
class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return StreamBuilder<Event?>(
      stream: (db.select(db.events)..where((e) => e.id.equals(eventId)))
          .watchSingleOrNull(),
      builder: (context, snapshot) {
        final event = snapshot.data;
        if (event == null) {
          return const Scaffold(body: Center(child: Text('Event not found')));
        }
        final details = decodeMap(event.detailsJson);
        return Scaffold(
          appBar: AppBar(
            title: Text(event.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => EventFormScreen(existing: event),
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('${event.type} · ${event.status}'),
              if (event.bookingRef != null) Text('Booking: ${event.bookingRef}'),
              if (event.notes != null) Text(event.notes!),
              const Divider(),
              Text('Documents', style: Theme.of(context).textTheme.titleMedium),
              StreamBuilder<List<Attachment>>(
                stream: (db.select(db.attachments)
                      ..where(
                        (a) =>
                            a.eventId.equals(event.id) & a.deletedAt.isNull(),
                      ))
                    .watch(),
                builder: (context, snap) {
                  final docs = snap.data ?? [];
                  if (docs.isEmpty) {
                    return const ListTile(title: Text('No documents linked'));
                  }
                  return Column(
                    children: [
                      for (final doc in docs)
                        ListTile(
                          leading: Icon(
                            doc.downloadState == 'done'
                                ? Icons.picture_as_pdf
                                : Icons.cloud_download,
                          ),
                          title: Text(doc.fileName),
                          subtitle: Text(
                            '${(doc.sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB · ${doc.downloadState}',
                          ),
                          trailing: doc.downloadState == 'done'
                              ? TextButton(
                                  onPressed: () =>
                                      openCachedDocument(context, doc),
                                  child: const Text('View document'),
                                )
                              : null,
                          onTap: () => openCachedDocument(context, doc),
                        ),
                    ],
                  );
                },
              ),
              const Divider(),
              for (final entry in details.entries)
                ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value.toString()),
                ),
              const SizedBox(height: 12),
              if (event.reviewState != 'none')
                FilledButton.tonal(
                  onPressed: () async {
                    final nick = await db.syncValue('device_nickname') ?? 'Traveler';
                    await ref.read(eventRepositoryProvider).saveEventFields(
                          eventId: event.id,
                          changedFields: {'review_state': 'none'},
                          updatedBy: nick,
                          updatedAt: DateTime.now().toUtc(),
                          tripId: event.tripId,
                        );
                  },
                  child: const Text('Looks good'),
                ),
              OutlinedButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => RevisionSheet(event: event),
                ),
                child: const Text("Something's wrong"),
              ),
              TextButton(
                onPressed: () async {
                  final nick = await db.syncValue('device_nickname') ?? 'Traveler';
                  await ref.read(eventRepositoryProvider).softDelete(
                        eventId: event.id,
                        updatedBy: nick,
                      );
                  if (context.mounted) Navigator.pop(context);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Event deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () async {
                          await ref.read(eventRepositoryProvider).saveEventFields(
                                eventId: event.id,
                                changedFields: {'deleted_at': null},
                                updatedBy: nick,
                                updatedAt: DateTime.now().toUtc(),
                                tripId: event.tripId,
                              );
                          await (db.update(db.events)
                                ..where((e) => e.id.equals(event.id)))
                              .write(
                            const EventsCompanion(
                              deletedAt: Value(null),
                              dirty: Value(true),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }
}
