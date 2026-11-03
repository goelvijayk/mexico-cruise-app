import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/data/bundle/bundle_service.dart';
import 'package:mexico_cruise/features/event_detail/event_detail_screen.dart';
import 'package:mexico_cruise/features/event_form/event_form_screen.dart';
import 'package:mexico_cruise/features/inbox/inbox_screen.dart';
import 'package:mexico_cruise/features/onboarding/onboarding_screen.dart';
import 'package:mexico_cruise/features/settings/settings_screen.dart';
import 'package:mexico_cruise/features/documents/documents_screen.dart';
import 'package:mexico_cruise/features/timeline/timeline_screen.dart';
import 'package:mexico_cruise/data/sync/refresh_progress.dart';
import 'package:mexico_cruise/providers/app_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final dirty = ref.watch(dirtyOutboxProvider).valueOrNull ?? 0;
    final summary = ref.watch(refreshSummaryProvider).valueOrNull;
    final refreshState = ref.watch(refreshControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mexico Cruise'),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                tooltip: 'Refresh',
                onPressed: refreshState.isLoading
                    ? null
                    : () => _showRefreshSheet(context),
                icon: const Icon(Icons.sync),
              ),
              if (dirty > 0)
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(radius: 4, backgroundColor: Colors.orange),
                ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(18),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              summary ?? 'Pull to sync when online',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          TimelineScreen(),
          DocumentsScreen(),
          InboxScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Timeline'),
          NavigationDestination(icon: Icon(Icons.folder), label: 'Documents'),
          NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const EventFormScreen(),
                ),
              ),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> _showRefreshSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(refreshControllerProvider);
            ref.listen(refreshControllerProvider, (prev, next) {
              if (next.hasError || (next.hasValue && !next.isLoading)) {
                Future.delayed(const Duration(seconds: 1), () {
                  if (ctx.mounted) Navigator.pop(ctx);
                });
              }
            });
            if (!state.isLoading && state.valueOrNull == null) {
              Future.microtask(() => ref.read(refreshControllerProvider.notifier).refresh());
            }
            final progress = ref.watch(refreshProgressProvider);
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Refreshing', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  if (state.isLoading) const LinearProgressIndicator(),
                  if (progress != null) ...[
                    const SizedBox(height: 8),
                    Text(_phaseLabel(progress)),
                    if (progress.downloadTotal != null &&
                        progress.downloadTotal! > 0)
                      Text(
                        'Documents ${progress.downloadIndex}/${progress.downloadTotal}'
                        '${progress.bytesDownloaded != null ? ' · ${(progress.bytesDownloaded! / (1024 * 1024)).toStringAsFixed(0)} MB' : ''}',
                      ),
                  ],
                  if (state.hasError)
                    Text(state.error.toString(), style: const TextStyle(color: Colors.red)),
                  if (state.hasValue && state.value != null)
                    Text(state.value!.message),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : () => _shareNearbyPhone(context, ref),
                    icon: const Icon(Icons.share),
                    label: const Text('Share to nearby phone'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Future<void> _shareNearbyPhone(BuildContext context, WidgetRef ref) async {
  try {
    final db = ref.read(databaseProvider);
    final base = await getApplicationDocumentsDirectory();
    final svc = BundleService(
      db: db,
      docsDirectory: Directory(p.join(base.path, 'docs')),
      exportDirectory: Directory(p.join(base.path, 'exports')),
    );
    final result = await svc.exportBundle(includeDocuments: true);
    await Share.shareXFiles(
      [XFile(result.file.path, mimeType: 'application/zip')],
      text: 'Mexico Cruise ${result.file.uri.pathSegments.last}',
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Share failed: $e')),
      );
    }
  }
}

String _phaseLabel(RefreshProgress p) {
  switch (p.phase) {
    case 'signing_in':
      return 'Signing in…';
    case 'pushing':
      return p.detail ?? 'Sending your changes…';
    case 'pulling':
      return p.detail ?? 'Getting updates…';
    case 'downloading':
      return p.detail ?? 'Downloading documents…';
    default:
      return p.detail ?? p.phase;
  }
}

class MexicoCruiseApp extends ConsumerWidget {
  const MexicoCruiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boot = ref.watch(bootstrapProvider);
    final onboard = ref.watch(onboardingCompleteProvider);

    return MaterialApp(
      title: 'Mexico Cruise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routes: {
        '/event': (context) {
          final id = ModalRoute.of(context)!.settings.arguments as String;
          return EventDetailScreen(eventId: id);
        },
      },
      home: boot.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
        data: (_) => onboard.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
          data: (done) => done ? const AppShell() : const OnboardingScreen(),
        ),
      ),
    );
  }
}
