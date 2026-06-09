import 'package:flutter/material.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterDepartment = 'All';

  static const teal = Color(0xFF0E7C7B);

  final List<Map<String, dynamic>> _medicalTeam = const [
    {
      'id': 'EMP-001',
      'name': 'Dr. Sarah Mitchell',
      'title': 'Chief Medical Officer',
      'specialty': 'Internal Medicine',
      'department': 'Clinical',
      'status': 'Available',
      'patientLoad': 12,
      'qualifications': 'MD, Board Certified',
      'email': 'sarah.mitchell@hospital.com',
      'phone': '+1-555-0101',
      'licenseNumber': 'LIC-2024-001',
      'yearsExperience': 15,
      'performanceScore': 4.9,
    },
    {
      'id': 'EMP-002',
      'name': 'Dr. James Anderson',
      'title': 'Senior Cardiologist',
      'specialty': 'Cardiology',
      'department': 'Cardiac Care',
      'status': 'On-Shift',
      'patientLoad': 8,
      'qualifications': 'MD, Board Certified - Cardiology',
      'email': 'james.anderson@hospital.com',
      'phone': '+1-555-0102',
      'licenseNumber': 'LIC-2024-002',
      'yearsExperience': 18,
      'performanceScore': 4.8,
    },
    {
      'id': 'EMP-003',
      'name': 'RN. Emily Rodriguez',
      'title': 'Charge Nurse',
      'specialty': 'Surgical Nursing',
      'department': 'OR',
      'status': 'Available',
      'patientLoad': 6,
      'qualifications': 'RN, BSN, CNOR',
      'email': 'emily.rodriguez@hospital.com',
      'phone': '+1-555-0103',
      'licenseNumber': 'LIC-2024-003',
      'yearsExperience': 10,
      'performanceScore': 4.7,
    },
    {
      'id': 'EMP-004',
      'name': 'Dr. Michael Chen',
      'title': 'Pulmonologist',
      'specialty': 'Pulmonology',
      'department': 'Respiratory',
      'status': 'On-Call',
      'patientLoad': 5,
      'qualifications': 'MD, Board Certified - Pulmonology',
      'email': 'michael.chen@hospital.com',
      'phone': '+1-555-0104',
      'licenseNumber': 'LIC-2024-004',
      'yearsExperience': 12,
      'performanceScore': 4.6,
    },
    {
      'id': 'EMP-005',
      'name': 'RN. Jessica Thompson',
      'title': 'ICU Nurse',
      'specialty': 'Critical Care',
      'department': 'ICU',
      'status': 'Available',
      'patientLoad': 4,
      'qualifications': 'RN, CCRN, MSN',
      'email': 'jessica.thompson@hospital.com',
      'phone': '+1-555-0105',
      'licenseNumber': 'LIC-2024-005',
      'yearsExperience': 8,
      'performanceScore': 4.8,
    },
    {
      'id': 'EMP-006',
      'name': 'Dr. Robert Martinez',
      'title': 'Emergency Medicine',
      'specialty': 'Emergency Medicine',
      'department': 'ER',
      'status': 'On-Shift',
      'patientLoad': 15,
      'qualifications': 'MD, Board Certified - EM',
      'email': 'robert.martinez@hospital.com',
      'phone': '+1-555-0106',
      'licenseNumber': 'LIC-2024-006',
      'yearsExperience': 14,
      'performanceScore': 4.5,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departments = {
      'All',
      ..._medicalTeam.map((e) => e['department'] as String),
    }.toList();

    final searchTerm = _searchController.text.toLowerCase();
    final filtered = _medicalTeam.where((emp) {
      final matchesSearch = emp['name'].toString().toLowerCase().contains(searchTerm) ||
          emp['title'].toString().toLowerCase().contains(searchTerm) ||
          emp['specialty'].toString().toLowerCase().contains(searchTerm);
      final matchesDept = _filterDepartment == 'All' || emp['department'] == _filterDepartment;
      return matchesSearch && matchesDept;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Healthcare Team', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search + Filter
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, role, or specialty...',
                      prefixIcon: const Icon(Icons.search, color: teal),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: teal, width: 2),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: departments.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final dept = departments[i];
                        final selected = _filterDepartment == dept;
                        return FilterChip(
                          label: Text(dept),
                          selected: selected,
                          onSelected: (_) => setState(() => _filterDepartment = dept),
                          backgroundColor: Colors.white,
                          selectedColor: teal,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.grey[700],
                            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: selected ? teal : Colors.grey[300]!,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text('No team members found', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => _staffCard(filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _staffCard(Map<String, dynamic> emp) {
    final initials = emp['name']
        .toString()
        .split(' ')
        .map((name) => name[0])
        .join()
        .toUpperCase();

    final avatarColors = [Colors.blue, Colors.pink, Colors.purple, Colors.orange, Colors.green, Colors.red, Colors.amber, Colors.cyan];
    final colorIndex = emp['name'].toString().hashCode % avatarColors.length;
    final avatarColor = avatarColors[colorIndex];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 28,
                backgroundColor: avatarColor,
                child: Text(
                  initials,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Name
            Text(
              emp['name'],
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Designation
            Text(
              emp['title'],
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Department Tags
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                _tagChip(emp['department']),
                _tagChip(emp['specialty']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, color: Colors.grey[700]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _chip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: teal.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: teal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: teal),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
