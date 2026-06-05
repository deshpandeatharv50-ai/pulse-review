import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'widgets/app_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kylkksvxkkwdhatwuc.supabase.co',
    anonKey: 'sb_publishable_kv088wKh7vJsGhS0hYiCFQ_pVZSqZzT',
  );

  runApp(const PulseReviewApp());
}

class PulseReviewApp extends StatelessWidget {
  const PulseReviewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseReview',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AppNavigation(),
    );
  }
}
