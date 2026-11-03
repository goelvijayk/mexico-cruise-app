import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/config/app_config.dart';
import 'package:mexico_cruise/providers/app_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _password = TextEditingController();
  final _nickname = TextEditingController();
  int _step = 0;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _step == 0 ? _welcome() : _step == 1 ? _passwordStep(config) : _nicknameStep(),
      ),
    );
  }

  Widget _welcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Shared family itinerary for the Mexico cruise. '
          'Works offline; tap Refresh when you have Wi‑Fi.',
        ),
        const Spacer(),
        FilledButton(
          onPressed: () => setState(() => _step = 1),
          child: const Text('Continue'),
        ),
      ],
    );
  }

  Widget _passwordStep(AppConfig? config) {
    final offlineOnly = config == null || !config.hasBackend;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(offlineOnly
            ? 'No backend configured — continuing in local demo mode.'
            : 'Enter the group password'),
        if (!offlineOnly) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Group password'),
          ),
        ],
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        const Spacer(),
        FilledButton(
          onPressed: () async {
            if (offlineOnly) {
              setState(() => _step = 2);
              return;
            }
            try {
              final client = Supabase.instance.client;
              await client.auth.signInWithPassword(
                email: config.supabaseEmail,
                password: _password.text,
              );
              setState(() {
                _error = null;
                _step = 2;
              });
            } catch (_) {
              setState(() => _error = "That's not the group password");
            }
          },
          child: const Text('Sign in'),
        ),
      ],
    );
  }

  Widget _nicknameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Device nickname (shown on "Edited by" lines)'),
        TextField(
          controller: _nickname,
          decoration: const InputDecoration(hintText: "Mom's Pixel"),
        ),
        const Spacer(),
        FilledButton(
          onPressed: () async {
            final db = ref.read(databaseProvider);
            await db.setSyncValue(
              'device_nickname',
              _nickname.text.trim().isEmpty ? 'Traveler' : _nickname.text.trim(),
            );
            await db.setSyncValue('onboarding_complete', 'true');
            await ref.read(refreshControllerProvider.notifier).refresh();
            ref.invalidate(onboardingCompleteProvider);
          },
          child: const Text('Start trip'),
        ),
      ],
    );
  }
}
