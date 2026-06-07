import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/healthcare_organization.dart';
import '../screens/organization_picker_screen.dart';
import '../screens/dashboard_home.dart';
import '../screens/team_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/reviews_advanced_classic.dart';

class AppNavigation extends StatefulWidget {
  final HealthcareOrganization organization;
  final HealthcarePersona persona;

  const AppNavigation({
    Key? key,
    required this.organization,
    required this.persona,
  }) : super(key: key);

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardHome(),
      const TeamScreen(),
      const FeedbackScreen(),
      const GoalsScreen(),
      const ReviewsAdvancedClassic(),
    ];
  }

  void _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {
      // No active Supabase session — ignore.
    }
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OrganizationPickerScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final org = widget.organization;
    final persona = widget.persona;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: org.accentColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('MediFlow',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text(
              '${org.name} · ${persona.name}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Reviews',
          ),
        ],
      ),
    );
  }
}
