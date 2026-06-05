import 'package:flutter/material.dart';
import 'screens/organization_picker_screen.dart';
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
  runApp(const MediFlowApp());
}

class MediFlowApp extends StatelessWidget {
  const MediFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediFlow × ELEVATE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E7C7B), // medical teal
          primary: const Color(0xFF0E7C7B),
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F8F8),
      ),
      home: const OrganizationPickerScreen(),
    );
  }
}
