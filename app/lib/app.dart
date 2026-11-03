import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/features/event_detail/event_detail_screen.dart';
import 'package:mexico_cruise/features/event_form/event_form_screen.dart';
import 'package:mexico_cruise/features/inbox/inbox_screen.dart';
import 'package:mexico_cruise/features/onboarding/onboarding_screen.dart';
import 'package:mexico_cruise/features/settings/settings_screen.dart';
import 'package:mexico_cruise/features/documents/documents_screen.dart';
import 'package:mexico_cruise/features/timeline/timeline_screen.dart';
import 'package:mexico_cruise/providers/app_providers.dart';

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
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Refreshing', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  if (state.isLoading) const LinearProgressIndicator(),
                  if (state.hasError)
                    Text(state.error.toString(), style: const TextStyle(color: Colors.red)),
                  if (state.hasValue && state.value != null)
                    Text(state.value!.message),
                ],
              ),
            );
          },
        );
      },
    );
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
