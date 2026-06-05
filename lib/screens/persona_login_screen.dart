import 'package:flutter/material.dart';
import '../models/healthcare_organization.dart';
import '../widgets/app_navigation.dart';

/// Employee ID + password login (per organization).
class PersonaLoginScreen extends StatefulWidget {
  final HealthcareOrganization organization;

  const PersonaLoginScreen({
    Key? key,
    required this.organization,
  }) : super(key: key);

  @override
  State<PersonaLoginScreen> createState() => _PersonaLoginScreenState();
}

class _PersonaLoginScreenState extends State<PersonaLoginScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  void _login() {
    final id = _idController.text.trim();
    final pwd = _passwordController.text.trim();
    if (id.isEmpty || pwd.isEmpty) {
      setState(() => _error = 'Enter Employee ID and password');
      return;
    }
    HealthcarePersona? match;
    for (final p in widget.organization.personas) {
      if (p.employeeId == id) {
        match = p;
        break;
      }
    }
    if (match == null || match.password != pwd) {
      setState(() => _error = 'Invalid Employee ID or password');
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AppNavigation(
          organization: widget.organization,
          persona: match!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final org = widget.organization;
    return Scaffold(
      appBar: AppBar(
        title: Text(org.name),
        backgroundColor: org.accentColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Org banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: org.accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: org.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(org.icon, color: org.accentColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(org.type,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(org.description,
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Employee ID
            TextField(
              controller: _idController,
              autocorrect: false,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'Employee ID',
                counterText: '',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            // Password
            TextField(
              controller: _passwordController,
              obscureText: true,
              onSubmitted: (_) => _login(),
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(_error!,
                  style: const TextStyle(color: Colors.red, fontSize: 13)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: org.accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _login,
                child: const Text('Login',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
