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
    return PopScope(
      // System back from any non-Dashboard tab → switch to Dashboard
      // instead of exiting the app.
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selectedIndex != 0) {
          _onTabTapped(0);
        }
      },
      child: Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabTapped,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups_rounded),
            label: 'Team',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Feedback',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined),
            selectedIcon: Icon(Icons.flag_rounded),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline_rounded),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'Reviews',
          ),
        ],
      ),
      ),
    );
  }
}
