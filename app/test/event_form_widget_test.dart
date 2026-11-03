import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mexico_cruise/config/app_config.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/data/local/seed_local.dart';
import 'package:mexico_cruise/features/event_form/event_form_screen.dart';
import 'package:mexico_cruise/providers/app_providers.dart';

void main() {
  testWidgets('edit form validates title', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final db = AppDatabase.inMemory();
    await seedLocalSampleData(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          appConfigProvider.overrideWithValue(
            AppConfig(
              supabaseUrl: null,
              supabaseAnonKey: null,
              supabaseEmail: 'trip@example.com',
            ),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: EventFormScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final saveButton = find.byKey(const Key('save_event'));
    await tester.tap(saveButton);
    await tester.pump();
    expect(find.text('Title required'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('event_title')), 'Test dinner');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Title required'), findsNothing);
    await db.close();
  });
}
