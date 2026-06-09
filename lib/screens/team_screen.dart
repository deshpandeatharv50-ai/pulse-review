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
      body: SafeArea(
        child: Column(
          children: [
            // Professional Medical Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [teal, Color(0xFF0A5A5A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Healthcare Team',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${filtered.length} professionals on staff',
                          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.medical_services, color: Colors.white, size: 26),
                  ),
                ],
              ),
            ),
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
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
    final statusColor = emp['status'] == 'Available'
        ? Colors.green
        : emp['status'] == 'On-Shift'
            ? Colors.blue
            : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: statusColor, width: 5)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emp['name'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        emp['title'],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: teal),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        emp['status'],
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _chip(Icons.local_hospital, 'Specialty', emp['specialty'])),
                const SizedBox(width: 8),
                Expanded(child: _chip(Icons.badge, 'License', emp['licenseNumber'])),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _chip(Icons.people, 'Patients', '${emp['patientLoad']}')),
                const SizedBox(width: 8),
                Expanded(child: _chip(Icons.star, 'Score', '${emp['performanceScore']}/5.0')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${emp['yearsExperience']} yrs • ${emp['qualifications']}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.phone, size: 14),
                    label: const Text('Call', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: teal,
                      side: const BorderSide(color: teal),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.feedback, size: 14),
                    label: const Text('Feedback', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
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
