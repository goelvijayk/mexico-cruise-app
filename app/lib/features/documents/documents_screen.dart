import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/providers/app_providers.dart';

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return StreamBuilder<List<Attachment>>(
      stream: (db.select(db.attachments)
            ..where((a) => a.deletedAt.isNull()))
          .watch()
          .map((rows) {
        rows.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        return rows;
      }),
      builder: (context, snapshot) {
        final rows = snapshot.data ?? [];
        final downloaded =
            rows.where((a) => a.downloadState == 'done').length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${rows.length} documents · $downloaded on this phone',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Expanded(
              child: rows.isEmpty
                  ? const Center(child: Text('No documents yet'))
                  : ListView.builder(
                      itemCount: rows.length,
                      itemBuilder: (context, i) {
                        final a = rows[i];
                        return ListTile(
                          leading: Icon(
                            a.downloadState == 'done'
                                ? Icons.check_circle
                                : Icons.cloud_download,
                          ),
                          title: Text(a.fileName),
                          subtitle: Text(
                            '${(a.sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB · ${a.downloadState}',
                          ),
                          onTap: () {
                            if (a.downloadState != 'done') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Not downloaded — Refresh on Wi‑Fi',
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
