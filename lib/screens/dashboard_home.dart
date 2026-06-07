import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'dashboard_option2.dart';
import 'dashboard_option3.dart';
import 'dashboard_option4.dart';
import 'dashboard_option5.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int _selectedOption = 1;

  final List<({int id, String label, String subtitle, Widget screen})> _dashboards = [
    (id: 1, label: 'Rankings', subtitle: 'Top performers', screen: const DashboardScreen()),
    (id: 2, label: 'Health Metrics', subtitle: 'Team health gauge', screen: const DashboardOption2()),
    (id: 3, label: 'Alerts & Risks', subtitle: 'What needs attention', screen: const DashboardOption3()),
    (id: 4, label: 'Departments', subtitle: 'By specialty', screen: const DashboardOption4()),
    (id: 5, label: 'Sentiment', subtitle: 'Team culture', screen: const DashboardOption5()),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _dashboards.firstWhere((d) => d.id == _selectedOption);

    return Stack(
      children: [
        selected.screen,
        // Dashboard variant selector (top-right corner)
        Positioned(
          top: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 4, right: 8),
              child: PopupMenuButton<int>(
                initialValue: _selectedOption,
                onSelected: (value) => setState(() => _selectedOption = value),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selected.label,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.unfold_more, size: 16),
                    ],
                  ),
                ),
                itemBuilder: (BuildContext context) => _dashboards
                    .map((dash) => PopupMenuItem<int>(
                          value: dash.id,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dash.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              Text(dash.subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
