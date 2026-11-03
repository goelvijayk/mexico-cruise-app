import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/data/bundle/bundle_codec.dart';
import 'package:mexico_cruise/data/bundle/bundle_service.dart';
import 'package:mexico_cruise/providers/app_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _nickname = TextEditingController();
  String _tzMode = 'event_local';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    _nickname.text = await db.syncValue('device_nickname') ?? '';
    _tzMode = await db.syncValue('display_tz_mode') ?? 'event_local';
    if (mounted) setState(() {});
  }

  Future<BundleService> _bundleService() async {
    final db = ref.read(databaseProvider);
    final base = await getApplicationDocumentsDirectory();
    return BundleService(
      db: db,
      docsDirectory: Directory(p.join(base.path, 'docs')),
      exportDirectory: Directory(p.join(base.path, 'exports')),
    );
  }

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        TextField(
          controller: _nickname,
          decoration: const InputDecoration(labelText: 'Device nickname'),
          onSubmitted: (v) async {
            await ref.read(databaseProvider).setSyncValue('device_nickname', v);
          },
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _tzMode,
          decoration: const InputDecoration(labelText: 'Display times in'),
          items: const [
            DropdownMenuItem(
              value: 'event_local',
              child: Text("Event's local time"),
            ),
            DropdownMenuItem(value: 'ship', child: Text('Ship time')),
            DropdownMenuItem(value: 'home', child: Text('Home time')),
            DropdownMenuItem(value: 'device', child: Text('Device time')),
          ],
          onChanged: (v) async {
            if (v == null) return;
            setState(() => _tzMode = v);
            await ref.read(databaseProvider).setSyncValue('display_tz_mode', v);
            ref.read(displayTzModeProvider.notifier).state = v;
          },
        ),
        ListTile(
          title: const Text('Backend'),
          subtitle: Text(
            config.hasBackend
                ? 'Supabase configured'
                : 'Local-only demo (no .env)',
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text('Share to nearby phone'),
          subtitle: const Text('Export .cruisebundle with events and cached PDFs'),
          trailing: const Icon(Icons.share),
          onTap: _shareBundle,
        ),
        ListTile(
          title: const Text('Import bundle'),
          subtitle: const Text('Merge a .cruisebundle received offline'),
          trailing: const Icon(Icons.download),
          onTap: _importBundle,
        ),
        const Divider(),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          onPressed: _leaveTrip,
          child: const Text('Leave trip (sign out + wipe)'),
        ),
      ],
    );
  }

  Future<void> _shareBundle() async {
    try {
      final svc = await _bundleService();
      final result = await svc.exportBundle(includeDocuments: true);
      await Share.shareXFiles(
        [XFile(result.file.path, mimeType: 'application/zip')],
        text:
            'Mexico Cruise bundle (${result.manifest.counts['events']} events)',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Share failed: $e')),
      );
    }
  }

  Future<void> _importBundle() async {
    final pick = await FilePicker.platform.pickFiles(
      allowedExtensions: ['cruisebundle'],
      type: FileType.custom,
    );
    if (pick == null || pick.files.single.path == null) return;
    final file = File(pick.files.single.path!);
    final svc = await _bundleService();
    final bytes = await file.readAsBytes();
    final files = decodeBundleArchive(bytes);
    final manifest = BundleManifest.fromJson(
      jsonDecode(utf8.decode(files['manifest.json']!)) as Map<String, dynamic>,
    );
    if (!mounted) return;
    final merge = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import bundle?'),
        content: Text(
          '${manifest.counts['events']} events · '
          '${manifest.counts['docs']} documents · '
          '${manifest.counts['attachments']} attachment rows',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Merge'),
          ),
        ],
      ),
    );
    if (merge != true) return;
    final result = await svc.importBundleFile(file);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.summary)),
    );
  }

  Future<void> _leaveTrip() async {
    final db = ref.read(databaseProvider);
    await db.delete(db.syncOutbox).go();
    await db.delete(db.events).go();
    await db.delete(db.attachments).go();
    await db.delete(db.ingestedEmails).go();
    await db.delete(db.revisionRequests).go();
    await db.delete(db.tripTable).go();
    await db.setSyncValue('onboarding_complete', 'false');
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {}
    ref.invalidate(onboardingCompleteProvider);
  }
}
