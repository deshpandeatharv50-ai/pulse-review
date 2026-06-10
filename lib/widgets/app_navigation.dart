import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/healthcare_organization.dart';
import '../screens/organization_picker_screen.dart';
import '../screens/dashboard_enterprise.dart';
import '../screens/team_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/reviews_list.dart';

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
  final PageController _pageController = PageController();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardEnterprise(),
      const TeamScreen(),
      const FeedbackScreen(),
      const GoalsScreen(),
      const ReviewsList(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Tap on the bottom bar — animate the pager to that tab.
  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0E7C7B),
        unselectedItemColor: Colors.grey,
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
