import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mexico_cruise/config/app_config.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/providers/app_providers.dart';
import 'package:mexico_cruise/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await AppConfig.load();
  SupabaseClient? client;
  if (config.hasBackend) {
    await Supabase.initialize(
      url: config.supabaseUrl!,
      publishableKey: config.supabaseAnonKey!,
    );
    client = Supabase.instance.client;
  }

  final db = await AppDatabase.openDefault();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        supabaseClientProvider.overrideWithValue(client),
        appConfigProvider.overrideWithValue(config),
      ],
      child: const MexicoCruiseApp(),
    ),
  );
}
