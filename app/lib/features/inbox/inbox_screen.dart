import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/providers/app_providers.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return StreamBuilder<List<dynamic>>(
      stream: Stream.periodic(const Duration(seconds: 2), (_) => null)
          .asyncMap((_) async {
        final failed = await (db.select(db.ingestedEmails)
              ..where((e) => e.status.equals('failed')))
            .get();
        final revisions = await (db.select(db.revisionRequests)
              ..where((r) => r.status.isIn(['open', 'needs_human', 'failed'])))
            .get();
        final revised = await (db.select(db.events)
              ..where((e) =>
                  e.reviewState.equals('revised') & e.deletedAt.isNull()))
            .get();
        return [failed, revisions, revised];
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final failed = snapshot.data![0] as List<IngestedEmail>;
        final revisions = snapshot.data![1] as List<RevisionRequest>;
        final revised = snapshot.data![2] as List<Event>;
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Text('Emails needing attention (${failed.length})',
                style: Theme.of(context).textTheme.titleMedium),
            for (final e in failed)
              ListTile(
                title: Text(e.subject),
                subtitle: Text(e.failureReason ?? e.status),
              ),
            const Divider(),
            Text('Revisions (${revisions.length})',
                style: Theme.of(context).textTheme.titleMedium),
            for (final r in revisions)
              ListTile(
                title: Text(r.note),
                subtitle: Text(r.status),
              ),
            const Divider(),
            Text('Revised events (${revised.length})',
                style: Theme.of(context).textTheme.titleMedium),
            for (final ev in revised)
              ListTile(title: Text(ev.title), subtitle: const Text('Check changes')),
          ],
        );
      },
    );
  }
}
