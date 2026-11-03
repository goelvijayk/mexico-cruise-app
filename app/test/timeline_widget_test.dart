import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mexico_cruise/config/app_config.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/data/local/seed_local.dart';
import 'package:mexico_cruise/features/timeline/timeline_screen.dart';
import 'package:mexico_cruise/providers/app_providers.dart';

void main() {
  testWidgets('timeline shows seeded flight card', (tester) async {
    final db = AppDatabase.inMemory();
    await seedLocalSampleData(db);
    await db.setSyncValue('onboarding_complete', 'true');

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
          home: Scaffold(body: TimelineScreen()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('UA 1234'), findsOneWidget);
    await db.close();
  });
}
