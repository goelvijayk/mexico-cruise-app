import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.supabaseEmail,
  });

  final String? supabaseUrl;
  final String? supabaseAnonKey;
  final String supabaseEmail;

  bool get hasBackend =>
      supabaseUrl != null &&
      supabaseUrl!.isNotEmpty &&
      supabaseAnonKey != null &&
      supabaseAnonKey!.isNotEmpty;

  static Future<AppConfig> load() async {
    const defineUrl =
        String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    const defineKey =
        String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
    const defineEmail =
        String.fromEnvironment('SUPABASE_EMAIL', defaultValue: 'trip@example.com');

    if (!kIsWeb) {
      try {
        await dotenv.load(fileName: '.env');
      } catch (_) {
        // Local-only mode without .env is OK.
      }
    }

    final url = defineUrl.isNotEmpty
        ? defineUrl
        : dotenv.maybeGet('SUPABASE_URL');
    final key = defineKey.isNotEmpty
        ? defineKey
        : dotenv.maybeGet('SUPABASE_ANON_KEY');
    final email = defineEmail.isNotEmpty
        ? defineEmail
        : (dotenv.maybeGet('SUPABASE_EMAIL') ?? 'trip@example.com');

    return AppConfig(
      supabaseUrl: url,
      supabaseAnonKey: key,
      supabaseEmail: email,
    );
  }
}
