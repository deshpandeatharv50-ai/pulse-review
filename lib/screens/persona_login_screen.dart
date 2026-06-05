import 'package:flutter/material.dart';
import '../models/healthcare_organization.dart';
import '../widgets/app_navigation.dart';

/// Select a persona and password to login.
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
  HealthcarePersona? _selectedPersona;
  final _passwordController = TextEditingController();
  String? _error;

  void _login() {
    if (_selectedPersona == null) {
      setState(() => _error = 'Please select a persona');
      return;
    }
    if (_passwordController.text.trim() != '1234') {
      setState(() => _error = 'Invalid password');
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AppNavigation(
          organization: widget.organization,
          persona: _selectedPersona!,
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                    child:
                        Icon(org.icon, color: org.accentColor, size: 24),
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
            const SizedBox(height: 24),
            Text('Select Staff Member',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            SegmentedButton<HealthcarePersona>(
              multiSelectionEnabled: false,
              emptySelectionAllowed: true,
              onSelectionChanged: (v) =>
                  setState(() => _selectedPersona = v.isEmpty ? null : v.first),
              selected: _selectedPersona == null ? {} : {_selectedPersona!},
              segments: org.personas
                  .map((p) => ButtonSegment(
                        value: p,
                        label: Text(p.name,
                            style: const TextStyle(fontSize: 12)),
                      ))
                  .toList(),
            ),
            if (_selectedPersona != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: org.accentColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_selectedPersona!.displayName} · ${_selectedPersona!.dept}',
                  style: TextStyle(
                      fontSize: 12,
                      color: org.accentColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              onSubmitted: (_) => _login(),
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '1234',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!,
                  style: const TextStyle(color: Colors.red, fontSize: 13)),
            ],
            const SizedBox(height: 20),
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Password: 1234 (all personas)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
