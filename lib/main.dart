import 'package:flutter/material.dart';
import 'screens/organization_picker_screen.dart';
import 'screens/employee_feedback_log_screen.dart';
import 'supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Supabase so data screens (dashboard, team, etc.) work.
  // Wrapped so a backend hiccup never blocks the app from opening.
  try {
    await SupabaseConfig.init();
  } catch (e) {
    debugPrint('Supabase init failed (continuing): $e');
  }
  // Fire-and-forget hydration of cloud feedback into the local override map
  // so cross-device data is visible without each user opening every log.
  EmployeeFeedbackLogScreen.hydrateAllFromSupabase();
  runApp(const Elev8App());
}

class Elev8App extends StatelessWidget {
  const Elev8App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Material 3 vibrant theme — seeded from ELEV8 teal but Flutter generates
    // the full tonal palette (primary / secondary / tertiary containers etc.)
    // so the whole app gets that Google Material You feel.
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0E7C7B),
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'ELEV8',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: scheme.surface,
        fontFamily: 'Roboto',
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: scheme.surfaceContainerLow,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide.none,
        ),
      ),
      home: const OrganizationPickerScreen(),
    );
  }
}
