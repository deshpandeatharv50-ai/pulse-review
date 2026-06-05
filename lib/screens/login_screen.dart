import 'package:flutter/material.dart';
import '../widgets/app_navigation.dart';

/// MediFlow healthcare login — simple local auth for the demo.
/// No Supabase dependency: works fully offline, can't fail mid-demo.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  String? _error;

  // Short, healthcare-themed demo credentials (username -> {password, name}).
  static const Map<String, Map<String, String>> _users = {
    'admin': {'password': '1234', 'name': 'Hospital Admin'},
    'drmehta': {'password': '1234', 'name': 'Dr. Mehta'},
    'nurse': {'password': '1234', 'name': 'Head Nurse'},
  };

  void _login() {
    final u = _userController.text.trim().toLowerCase();
    final p = _passController.text.trim();
    final match = _users[u];
    if (match != null && match['password'] == p) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppNavigation()),
      );
    } else {
      setState(() => _error = 'Invalid username or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF0E7C7B);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo badge
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: teal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.local_hospital_rounded,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  const Text('MediFlow',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: teal)),
                  const SizedBox(height: 4),
                  Text('Healthcare Performance Management',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _userController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passController,
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
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
