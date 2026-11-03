import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:open_filex/open_filex.dart';

Future<void> openCachedDocument(BuildContext context, Attachment attachment) async {
  if (attachment.downloadState != 'done' ||
      attachment.localPath == null ||
      attachment.localPath!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Not downloaded — Refresh on Wi‑Fi')),
    );
    return;
  }
  final file = File(attachment.localPath!);
  if (!file.existsSync()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File missing — Refresh again')),
    );
    return;
  }
  final result = await OpenFilex.open(file.path, type: attachment.mimeType);
  if (result.type != ResultType.done && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open: ${result.message}')),
    );
  }
}
