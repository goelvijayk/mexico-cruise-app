import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/providers/app_providers.dart';
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
          value: _tzMode,
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
