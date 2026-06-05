import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'widgets/app_navigation.dart';

void main() {
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
