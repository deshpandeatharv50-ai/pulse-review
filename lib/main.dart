import 'package:flutter/material.dart';

void main() {
  runApp(const PulseReviewApp());
}

/// ELEVATE brand tokens — blue uptrend + green check.
class ElevateColors {
  static const Color blue = Color(0xFF0066CC); // primary
  static const Color blueDark = Color(0xFF004C99);
  static const Color green = Color(0xFF00A651); // accent / success
  static const Color ink = Color(0xFF1A2233);
  static const Color mist = Color(0xFFF4F8FC); // page background

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blue, green],
  );
}

/// Small reusable ELEVATE logo mark (blue uptrend + green check badge).
class ElevateLogo extends StatelessWidget {
  final double size;
  const ElevateLogo({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: ElevateColors.brandGradient,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: ElevateColors.blue.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.trending_up_rounded,
          color: Colors.white, size: size * 0.6),
    );
  }
}

/// ELEVATE wordmark — "ELEV" blue, "ATE" green.
class ElevateWordmark extends StatelessWidget {
  final double fontSize;
  const ElevateWordmark({super.key, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
        ),
        children: const [
          TextSpan(text: 'ELEV', style: TextStyle(color: ElevateColors.blue)),
          TextSpan(text: 'ATE', style: TextStyle(color: ElevateColors.green)),
        ],
      ),
    );
  }
}

class PulseReviewApp extends StatelessWidget {
  const PulseReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ELEVATE',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ElevateColors.blue,
          primary: ElevateColors.blue,
          secondary: ElevateColors.green,
        ),
        scaffoldBackgroundColor: ElevateColors.mist,
        appBarTheme: const AppBarTheme(
          backgroundColor: ElevateColors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ElevateColors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const CompanyPickerScreen(),
    );
  }
}

/// A selectable demo organisation (Company A / B / C).
class Company {
  final String name;
  final String tagline;
  final Color accent;
  final IconData icon;
  const Company(this.name, this.tagline, this.accent, this.icon);

  static const List<Company> all = [
    Company('Company A', 'Tech Solutions', ElevateColors.blue,
        Icons.memory_rounded),
    Company('Company B', 'Retail & Commerce', ElevateColors.green,
        Icons.storefront_rounded),
    Company('Company C', 'Financial Services', Color(0xFF6A4CCB),
        Icons.account_balance_rounded),
  ];
}

/// Entry screen — pick which organisation to demo.
class CompanyPickerScreen extends StatelessWidget {
  const CompanyPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColors.mist,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Center(child: ElevateLogo(size: 64)),
              const SizedBox(height: 16),
              const Center(child: ElevateWordmark(fontSize: 34)),
              const SizedBox(height: 8),
              Text(
                'Select an organisation',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: Company.all.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final c = Company.all[i];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          AppState().currentCompany = c.name;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(company: c),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: c.accent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(c.icon, color: c.accent, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(c.name,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 2),
                                    Text(c.tagline,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded,
                                  color: c.accent),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// GLOBAL APP STATE
class AppState {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  /// Currently selected organisation — set by the Company picker.
  String currentCompany = 'Company A';

  // ---- Company-aware getters (return the current org's data) ----
  List<Map<String, dynamic>> get feedbackList =>
      _feedbackByCompany[currentCompany]!;
  List<Map<String, dynamic>> get goalsList =>
      _goalsByCompany[currentCompany]!;
  List<Map<String, dynamic>> get reviewsList =>
      _reviewsByCompany[currentCompany]!;
  List<Map<String, dynamic>> get employees =>
      _employeesByCompany[currentCompany]!;
  List<String> get employeeNames =>
      employees.map((e) => e['name'] as String).toList();

  // ---- TEAM / EMPLOYEE DIRECTORIES (per company) ----
  final Map<String, List<Map<String, dynamic>>> _employeesByCompany = {
    'Company A': [
      {'id': 'EMP-A01', 'name': 'Rajesh Kumar', 'title': 'Senior Engineer', 'department': 'Engineering', 'reportingTo': 'James Bellano', 'score': 4.5, 'email': 'rajesh.kumar@companya.com'},
      {'id': 'EMP-A02', 'name': 'Michael Johnson', 'title': 'Sales Manager', 'department': 'Sales', 'reportingTo': 'James Bellano', 'score': 4.0, 'email': 'michael.johnson@companya.com'},
      {'id': 'EMP-A03', 'name': 'Priya Sharma', 'title': 'Marketing Director', 'department': 'Marketing', 'reportingTo': 'James Bellano', 'score': 4.8, 'email': 'priya.sharma@companya.com'},
      {'id': 'EMP-A04', 'name': 'David Wilson', 'title': 'Staff Engineer', 'department': 'Engineering', 'reportingTo': 'Rajesh Kumar', 'score': 4.3, 'email': 'david.wilson@companya.com'},
      {'id': 'EMP-A05', 'name': 'Ananya Patel', 'title': 'HR Manager', 'department': 'HR', 'reportingTo': 'James Bellano', 'score': 4.1, 'email': 'ananya.patel@companya.com'},
      {'id': 'EMP-A06', 'name': 'Robert Davis', 'title': 'Finance Lead', 'department': 'Finance', 'reportingTo': 'James Bellano', 'score': 4.6, 'email': 'robert.davis@companya.com'},
      {'id': 'EMP-A07', 'name': 'Vikram Desai', 'title': 'Product Manager', 'department': 'Product', 'reportingTo': 'James Bellano', 'score': 4.7, 'email': 'vikram.desai@companya.com'},
      {'id': 'EMP-A08', 'name': 'Sarah Anderson', 'title': 'Customer Success Manager', 'department': 'Customer Success', 'reportingTo': 'James Bellano', 'score': 4.2, 'email': 'sarah.anderson@companya.com'},
    ],
    'Company B': [
      {'id': 'EMP-B01', 'name': 'Sarah Mitchell', 'title': 'Store Operations Lead', 'department': 'Store Ops', 'reportingTo': 'James Bellano', 'score': 4.4, 'email': 'sarah.mitchell@companyb.com'},
      {'id': 'EMP-B02', 'name': 'Tom Nakamura', 'title': 'Merchandising Manager', 'department': 'Merchandising', 'reportingTo': 'James Bellano', 'score': 4.1, 'email': 'tom.nakamura@companyb.com'},
      {'id': 'EMP-B03', 'name': 'Uma Patel', 'title': 'Supply Chain Lead', 'department': 'Supply Chain', 'reportingTo': 'James Bellano', 'score': 4.6, 'email': 'uma.patel@companyb.com'},
      {'id': 'EMP-B04', 'name': 'Victor Lee', 'title': 'E-commerce Manager', 'department': 'E-commerce', 'reportingTo': 'James Bellano', 'score': 4.3, 'email': 'victor.lee@companyb.com'},
      {'id': 'EMP-B05', 'name': 'Wendy Zhang', 'title': 'Customer Care Head', 'department': 'Customer Care', 'reportingTo': 'James Bellano', 'score': 4.5, 'email': 'wendy.zhang@companyb.com'},
      {'id': 'EMP-B06', 'name': 'Xavier Lopez', 'title': 'Visual Merchandiser', 'department': 'Merchandising', 'reportingTo': 'Tom Nakamura', 'score': 3.9, 'email': 'xavier.lopez@companyb.com'},
    ],
    'Company C': [
      {'id': 'EMP-C01', 'name': 'Charles Brown', 'title': 'Risk Analyst Lead', 'department': 'Risk', 'reportingTo': 'James Bellano', 'score': 4.7, 'email': 'charles.brown@companyc.com'},
      {'id': 'EMP-C02', 'name': 'Diana Prince', 'title': 'Compliance Officer', 'department': 'Compliance', 'reportingTo': 'James Bellano', 'score': 4.8, 'email': 'diana.prince@companyc.com'},
      {'id': 'EMP-C03', 'name': 'Eric Stone', 'title': 'Senior Trader', 'department': 'Trading', 'reportingTo': 'James Bellano', 'score': 4.2, 'email': 'eric.stone@companyc.com'},
      {'id': 'EMP-C04', 'name': 'Fiona Scott', 'title': 'Operations Manager', 'department': 'Operations', 'reportingTo': 'James Bellano', 'score': 4.4, 'email': 'fiona.scott@companyc.com'},
      {'id': 'EMP-C05', 'name': 'George Martin', 'title': 'Portfolio Manager', 'department': 'Trading', 'reportingTo': 'Eric Stone', 'score': 4.5, 'email': 'george.martin@companyc.com'},
      {'id': 'EMP-C06', 'name': 'Helen Price', 'title': 'Audit Specialist', 'department': 'Compliance', 'reportingTo': 'Diana Prince', 'score': 4.0, 'email': 'helen.price@companyc.com'},
    ],
  };

  // ---- FEEDBACK (per company) ----
  final Map<String, List<Map<String, dynamic>>> _feedbackByCompany = {
    'Company A': [
      {'id': 1, 'from': 'Rajesh Kumar', 'to': 'James Bellano', 'type': 'Positive', 'comment': 'Delivered critical feature ahead of schedule', 'date': DateTime.now().subtract(const Duration(days: 2)), 'importance': 'Critical', 'weight': 50, 'impact': 'Major deliverable'},
      {'id': 2, 'from': 'Michael Johnson', 'to': 'James Bellano', 'type': 'Constructive', 'comment': 'Could improve email communication', 'date': DateTime.now().subtract(const Duration(days: 1)), 'importance': 'Minor', 'weight': 10, 'impact': 'Process improvement'},
    ],
    'Company B': [
      {'id': 1, 'from': 'Sarah Mitchell', 'to': 'James Bellano', 'type': 'Positive', 'comment': 'Hit 120% of festive-season store targets', 'date': DateTime.now().subtract(const Duration(days: 3)), 'importance': 'Critical', 'weight': 50, 'impact': 'Revenue growth'},
      {'id': 2, 'from': 'Uma Patel', 'to': 'James Bellano', 'type': 'Constructive', 'comment': 'Reduce supplier lead-time variance', 'date': DateTime.now().subtract(const Duration(days: 2)), 'importance': 'Major', 'weight': 25, 'impact': 'Inventory health'},
    ],
    'Company C': [
      {'id': 1, 'from': 'Diana Prince', 'to': 'James Bellano', 'type': 'Positive', 'comment': 'Cleared regulatory audit with zero findings', 'date': DateTime.now().subtract(const Duration(days: 4)), 'importance': 'Critical', 'weight': 50, 'impact': 'Compliance'},
      {'id': 2, 'from': 'Eric Stone', 'to': 'James Bellano', 'type': 'Constructive', 'comment': 'Tighten end-of-day reconciliation window', 'date': DateTime.now().subtract(const Duration(days: 1)), 'importance': 'Major', 'weight': 25, 'impact': 'Operational risk'},
    ],
  };

  // ---- GOALS (per company) ----
  final Map<String, List<Map<String, dynamic>>> _goalsByCompany = {
    'Company A': [
      {'id': 1, 'title': 'Improve code quality', 'progress': 0.8, 'status': 'in_progress', 'notes': 'Implementing better testing practices', 'priority': 'High', 'targetDate': DateTime.now().add(const Duration(days: 30)), 'quarter': 'Q1 2026', 'category': 'Engineering', 'createdBy': 'James Bellano', 'createdAt': DateTime.now().subtract(const Duration(days: 10)), 'history': [
        {'action': 'Created', 'by': 'James Bellano', 'at': DateTime.now().subtract(const Duration(days: 10)), 'details': 'Goal created'},
        {'action': 'Progress updated to 80%', 'by': 'James Bellano', 'at': DateTime.now().subtract(const Duration(days: 1)), 'details': 'Nearly complete'},
      ]},
      {'id': 2, 'title': 'Increase team engagement', 'progress': 0.6, 'status': 'in_progress', 'notes': 'Planning team building activities', 'priority': 'Medium', 'targetDate': DateTime.now().add(const Duration(days: 45)), 'quarter': 'Q1 2026', 'category': 'HR', 'createdBy': 'James Bellano', 'createdAt': DateTime.now().subtract(const Duration(days: 15)), 'history': [
        {'action': 'Created', 'by': 'James Bellano', 'at': DateTime.now().subtract(const Duration(days: 15)), 'details': 'Goal created'},
      ]},
      {'id': 3, 'title': 'Launch new feature', 'progress': 0.9, 'status': 'in_progress', 'notes': 'Final testing phase', 'priority': 'High', 'targetDate': DateTime.now().add(const Duration(days: 14)), 'quarter': 'Q1 2026', 'category': 'Product', 'createdBy': 'James Bellano', 'createdAt': DateTime.now().subtract(const Duration(days: 20)), 'history': [
        {'action': 'Created', 'by': 'James Bellano', 'at': DateTime.now().subtract(const Duration(days: 20)), 'details': 'Goal created'},
      ]},
    ],
    'Company B': [
      {'id': 1, 'title': 'Cut stockouts by 30%', 'progress': 0.7, 'status': 'in_progress', 'notes': 'New replenishment model rollout', 'priority': 'High', 'targetDate': DateTime.now().add(const Duration(days: 30)), 'quarter': 'Q1 2026', 'category': 'Supply Chain', 'createdBy': 'James Bellano', 'createdAt': DateTime.now().subtract(const Duration(days: 12)), 'history': [
        {'action': 'Created', 'by': 'James Bellano', 'at': DateTime.now().subtract(const Duration(days: 12)), 'details': 'Goal created'},
      ]},
      {'id': 2, 'title': 'Grow online sales share to 40%', 'progress': 0.55, 'status': 'in_progress', 'notes': 'Mobile checkout revamp', 'priority': 'High', 'targetDate': DateTime.now().add(const Duration(days: 50)), 'quarter': 'Q1 2026', 'category': 'E-commerce', 'createdBy': 'James Bellano', 'createdAt': DateTime.now().subtract(const Duration(days: 18)), 'history': [
        {'action': 'Created', 'by': 'James Bellano', 'at': DateTime.now().subtract(const Duration(days: 18)), 'details': 'Goal created'},
      ]},
    ],
    'Company C': [
      {'id': 1, 'title': 'Automate compliance reporting', 'progress': 0.85, 'status': 'in_progress', 'notes': 'Replacing manual monthly returns', 'priority': 'High', 'targetDate': DateTime.now().add(const Duration(days: 20)), 'quarter': 'Q1 2026', 'category': 'Compliance', 'createdBy': 'James Bellano', 'createdAt': DateTime.now().subtract(const Duration(days: 22)), 'history': [
        {'action': 'Created', 'by': 'James Bellano', 'at': DateTime.now().subtract(const Duration(days: 22)), 'details': 'Goal created'},
      ]},
      {'id': 2, 'title': 'Reduce trade settlement risk', 'progress': 0.5, 'status': 'in_progress', 'notes': 'Same-day reconciliation pilot', 'priority': 'Medium', 'targetDate': DateTime.now().add(const Duration(days: 40)), 'quarter': 'Q1 2026', 'category': 'Risk', 'createdBy': 'James Bellano', 'createdAt': DateTime.now().subtract(const Duration(days: 16)), 'history': [
        {'action': 'Created', 'by': 'James Bellano', 'at': DateTime.now().subtract(const Duration(days: 16)), 'details': 'Goal created'},
      ]},
    ],
  };

  // ---- REVIEWS (per company) ----
  final Map<String, List<Map<String, dynamic>>> _reviewsByCompany = {
    'Company A': [
      {'id': 1, 'employee': 'Rajesh Kumar', 'cycle': 'Annual', 'rating': 4.5, 'comment': 'Exceeds expectations - Key contributor to team success', 'date': DateTime.now().subtract(const Duration(days: 10)), 'weight': 100, 'importance': 'Annual Review', 'keyMetrics': ['Leadership', 'Technical Skills', 'Delivery']},
      {'id': 2, 'employee': 'Michael Johnson', 'cycle': 'Quarterly', 'rating': 4.0, 'comment': 'Meets expectations - Consistent performer', 'date': DateTime.now().subtract(const Duration(days: 5)), 'weight': 60, 'importance': 'Quarterly Check-in', 'keyMetrics': ['Consistency', 'Collaboration']},
    ],
    'Company B': [
      {'id': 1, 'employee': 'Sarah Mitchell', 'cycle': 'Annual', 'rating': 4.4, 'comment': 'Outstanding store leadership through peak season', 'date': DateTime.now().subtract(const Duration(days: 8)), 'weight': 100, 'importance': 'Annual Review', 'keyMetrics': ['Leadership', 'Sales', 'Operations']},
      {'id': 2, 'employee': 'Victor Lee', 'cycle': 'Quarterly', 'rating': 4.1, 'comment': 'Strong online conversion improvements', 'date': DateTime.now().subtract(const Duration(days: 4)), 'weight': 60, 'importance': 'Quarterly Check-in', 'keyMetrics': ['Growth', 'Execution']},
    ],
    'Company C': [
      {'id': 1, 'employee': 'Diana Prince', 'cycle': 'Annual', 'rating': 4.8, 'comment': 'Exemplary compliance record - zero audit findings', 'date': DateTime.now().subtract(const Duration(days: 9)), 'weight': 100, 'importance': 'Annual Review', 'keyMetrics': ['Compliance', 'Diligence', 'Integrity']},
      {'id': 2, 'employee': 'Eric Stone', 'cycle': 'Quarterly', 'rating': 4.2, 'comment': 'Solid trading performance within risk limits', 'date': DateTime.now().subtract(const Duration(days: 6)), 'weight': 60, 'importance': 'Quarterly Check-in', 'keyMetrics': ['Risk Mgmt', 'Returns']},
    ],
  };

  void addFeedback(String from, String to, String type, String comment) {
    feedbackList.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'from': from,
      'to': to,
      'type': type,
      'comment': comment,
      'date': DateTime.now(),
    });
  }

  void updateGoal(int id, double progress) {
    final goal = goalsList.firstWhere((g) => g['id'] == id);
    goal['progress'] = progress;
  }

  void addGoal(String title, String notes) {
    goalsList.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': title,
      'progress': 0.0,
      'status': 'in_progress',
      'notes': notes,
    });
  }

  void addReview(String employee, String cycle, double rating, String comment) {
    reviewsList.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'employee': employee,
      'cycle': cycle,
      'rating': rating,
      'comment': comment,
      'date': DateTime.now(),
      'weight': cycle == 'Annual' ? 100 : cycle == 'Quarterly' ? 60 : 30,
      'importance': cycle,
      'keyMetrics': ['Performance', 'Collaboration'],
      'status': 'Pending',
    });
  }
}

// LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  final Company? company;
  const LoginScreen({Key? key, this.company}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final email = _emailController.text;
      final password = _passwordController.text;

      if (email == 'james.bellano@acmecorp.com' && password == 'demo123') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainScreen(
              userName: 'James Bellano',
              userRole: 'Director',
              companyName: widget.company?.name,
            ),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColors.mist,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ElevateLogo(size: 64),
                  const SizedBox(height: 16),
                  const ElevateWordmark(fontSize: 34),
                  const SizedBox(height: 8),
                  Text(
                    'Real-time Performance Management',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  if (widget.company != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: widget.company!.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(widget.company!.icon,
                              size: 16, color: widget.company!.accent),
                          const SizedBox(width: 6),
                          Text(widget.company!.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: widget.company!.accent)),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'james.bellano@acmecorp.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'demo123',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Login'),
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
}

// MAIN SCREEN
class MainScreen extends StatefulWidget {
  final String userName;
  final String userRole;
  final String? companyName;

  const MainScreen({
    Key? key,
    required this.userName,
    required this.userRole,
    this.companyName,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final appState = AppState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            const ElevateLogo(size: 30),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('ELEVATE',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        fontSize: 16)),
                Text(
                    widget.companyName != null
                        ? '${widget.companyName} · ${widget.userName}'
                        : '${widget.userName} · ${widget.userRole}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 11)),
              ],
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Switch organisation',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const CompanyPickerScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: _buildScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_on),
            label: 'Heatmap',
          ),
        ],
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return DashboardScreen(appState: appState);
      case 1:
        return const TeamScreen();
      case 2:
        return FeedbackScreen(appState: appState);
      case 3:
        return GoalsScreen(appState: appState);
      case 4:
        return ReviewsScreen(appState: appState);
      case 5:
        return const HeatmapScreen();
      default:
        return DashboardScreen(appState: appState);
    }
  }
}

// DASHBOARD SCREEN
class DashboardScreen extends StatelessWidget {
  final AppState appState;

  const DashboardScreen({Key? key, required this.appState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate weighted average rating
    final reviews = appState.reviewsList;
    double weightedScore = 0.0;
    int totalWeight = 0;

    for (var review in reviews) {
      final rating = review['rating'] as num;
      final weight = review['weight'] as int? ?? 50;
      weightedScore += (rating * weight);
      totalWeight += weight;
    }

    final avgWeightedScore = totalWeight > 0 ? (weightedScore / totalWeight).toStringAsFixed(2) : 'N/A';

    // Calculate weighted feedback impact
    final feedbackList = appState.feedbackList;
    int criticalCount = feedbackList.where((f) => f['importance'] == 'Critical').length;
    int majorCount = feedbackList.where((f) => f['importance'] == 'Major').length;
    int minorCount = feedbackList.where((f) => f['importance'] == 'Minor').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          // Weighted score
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue[400]!, Colors.blue[600]!]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weighted Performance Score', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(avgWeightedScore, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Based on:', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        Text('${appState.reviewsList.length} reviews', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        Text('Weighted by importance', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Feedback Impact
          _buildMetricCard(context, 'Critical Feedback', '$criticalCount', Colors.red),
          const SizedBox(height: 8),
          _buildMetricCard(context, 'Major Feedback', '$majorCount', Colors.orange),
          const SizedBox(height: 8),
          _buildMetricCard(context, 'Minor Feedback', '$minorCount', Colors.green),
          const SizedBox(height: 16),

          // Standard metrics
          _buildMetricCard(context, 'Goals', '${appState.goalsList.length}', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TEAM SCREEN
class TeamScreen extends StatefulWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  late TextEditingController _searchController;
  String _filterDepartment = 'All';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employees = AppState().employees;

    // Get unique departments
    final departments = {'All', ...employees.map((e) => e['department']).cast<String>()}.toList();

    // Filter employees
    final searchTerm = _searchController.text.toLowerCase();
    final filteredEmployees = employees.where((emp) {
      final matchesSearch = emp['name'].toString().toLowerCase().contains(searchTerm) ||
          emp['id'].toString().toLowerCase().contains(searchTerm) ||
          emp['title'].toString().toLowerCase().contains(searchTerm);
      final matchesDepartment = _filterDepartment == 'All' || emp['department'] == _filterDepartment;
      return matchesSearch && matchesDepartment;
    }).toList();

    return Column(
      children: [
        // Header with count
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            border: Border(bottom: BorderSide(color: Colors.blue[200]!)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Team Members', style: Theme.of(context).textTheme.titleLarge),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${filteredEmployees.length}/${employees.length}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Search box
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name, ID, or title...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 12),
              // Department filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: departments.map((dept) {
                    final isSelected = _filterDepartment == dept;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(dept),
                        onSelected: (selected) {
                          setState(() {
                            _filterDepartment = dept;
                          });
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Colors.blue,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        // Employee list
        Expanded(
          child: filteredEmployees.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('No employees found', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final emp = filteredEmployees[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            emp['id'].toString().split('-')[1],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          emp['name'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              emp['title'].toString(),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  '${emp['department']} • Reports to: ${emp['reportingTo']}',
                                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${emp['score']}⭐',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        onTap: () {
                          _showEmployeeDetails(context, emp);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showEmployeeDetails(BuildContext context, Map<String, dynamic> emp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emp['name'].toString(), style: Theme.of(context).textTheme.titleLarge),
                    Text(emp['id'].toString(), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${emp['score']}⭐', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Job Title', emp['title'].toString()),
                  _buildDetailRow('Department', emp['department'].toString()),
                  _buildDetailRow('Reports To', emp['reportingTo'].toString()),
                  _buildDetailRow('Email', emp['email'].toString()),
                  _buildDetailRow('Performance Score', '${emp['score']}/5.0'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.feedback),
                  label: const Text('Add Feedback'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.assessment),
                  label: const Text('View Reviews'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// FEEDBACK SCREEN
class FeedbackScreen extends StatefulWidget {
  final AppState appState;

  const FeedbackScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _filterType = 'All';
  String _filterStatus = 'All';
  String _filterCompetency = 'All';

  List<String> get employees => AppState().employeeNames;

  final List<String> competencies = [
    'All', 'Leadership', 'Technical Skills', 'Communication', 'Collaboration',
    'Problem Solving', 'Delivery', 'Initiative'
  ];

  @override
  Widget build(BuildContext context) {
    final allFeedback = widget.appState.feedbackList;

    final filteredFeedback = allFeedback.where((f) {
      final typeMatch = _filterType == 'All' || f['type'] == _filterType;
      final statusMatch = _filterStatus == 'All' || f['status'] == _filterStatus;
      final competencyMatch = _filterCompetency == 'All' || (f['competency'] ?? 'Communication') == _filterCompetency;
      return typeMatch && statusMatch && competencyMatch;
    }).toList();

    return Column(
      children: [
        // Header with stats
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            border: Border(bottom: BorderSide(color: Colors.blue[200]!)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Feedback System', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text('${filteredFeedback.length}/${allFeedback.length} entries',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  FloatingActionButton(
                    onPressed: () => _showAddFeedbackDialog(context),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Quick stats - Type breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatChip('Positive', allFeedback.where((f) => f['type'] == 'Positive').length.toString(), Colors.green),
                  _buildStatChip('Constructive', allFeedback.where((f) => f['type'] == 'Constructive').length.toString(), Colors.amber),
                  _buildStatChip('Total', allFeedback.length.toString(), Colors.blue),
                ],
              ),
            ],
          ),
        ),
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All Types'),
                selected: _filterType == 'All',
                onSelected: (v) => setState(() => _filterType = 'All'),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Positive'),
                selected: _filterType == 'Positive',
                backgroundColor: Colors.green.withOpacity(0.2),
                selectedColor: Colors.green,
                onSelected: (v) => setState(() => _filterType = 'Positive'),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Constructive'),
                selected: _filterType == 'Constructive',
                backgroundColor: Colors.amber.withOpacity(0.2),
                selectedColor: Colors.amber,
                onSelected: (v) => setState(() => _filterType = 'Constructive'),
              ),
            ],
          ),
        ),
        // Feedback list
        Expanded(
          child: filteredFeedback.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.feedback_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('No feedback found', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredFeedback.length,
                  itemBuilder: (context, index) {
                    final feedback = filteredFeedback[index];
                    final color = feedback['type'] == 'Positive' ? Colors.green : Colors.amber;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${feedback['from']} → ${feedback['to']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feedback['comment'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                              child: Text(feedback['type'], style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildFeedbackRow('Competency', feedback['competency'] ?? 'Communication'),
                                      _buildFeedbackRow('Importance', feedback['importance'] ?? 'Major'),
                                      _buildFeedbackRow('Weight', '${feedback['weight']}%'),
                                      _buildFeedbackRow('Status', feedback['status'] ?? 'Pending'),
                                      _buildFeedbackRow('Date', '${feedback['date'].year}-${feedback['date'].month}-${feedback['date'].day}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text('Feedback Details:', style: Theme.of(context).textTheme.labelLarge),
                                const SizedBox(height: 8),
                                Text(feedback['comment'], style: const TextStyle(fontSize: 13)),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () => _acknowledgeFeedback(feedback),
                                      icon: const Icon(Icons.done, size: 16),
                                      label: const Text('Acknowledge'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text('Edit'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => _deleteFeedback(feedback),
                                      icon: const Icon(Icons.delete, size: 16),
                                      label: const Text('Delete'),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatChip(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(count, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildFeedbackRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _acknowledgeFeedback(Map<String, dynamic> feedback) {
    feedback['status'] = 'Acknowledged';
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Feedback acknowledged')));
  }

  void _deleteFeedback(Map<String, dynamic> feedback) {
    widget.appState.feedbackList.remove(feedback);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🗑️ Feedback deleted')));
  }

  void _showAddFeedbackDialog(BuildContext context) {
    String selectedRecipient = '';
    String feedbackType = 'Positive';
    String importance = 'Major';
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Give Feedback'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipient dropdown (keeps this since 10 options)
                DropdownButtonFormField<String>(
                  hint: const Text('Select recipient'),
                  value: selectedRecipient.isEmpty ? null : selectedRecipient,
                  items: employees.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedRecipient = value ?? '';
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Recipient',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),

                // Feedback Type - Toggle buttons (only 2 options)
                Text('Type', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(icon: const Icon(Icons.thumb_up), label: const Text('Positive'), value: 'Positive'),
                    ButtonSegment(icon: const Icon(Icons.edit_note), label: const Text('Constructive'), value: 'Constructive'),
                  ],
                  selected: {feedbackType},
                  onSelectionChanged: (Set<String> newSelection) {
                    setDialogState(() {
                      feedbackType = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 18),

                // Importance - Toggle buttons (3 options)
                Text('Impact Level', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(icon: const Icon(Icons.info_outline), label: const Text('Minor'), value: 'Minor'),
                    ButtonSegment(icon: const Icon(Icons.star_half), label: const Text('Major'), value: 'Major'),
                    ButtonSegment(icon: const Icon(Icons.star), label: const Text('Critical'), value: 'Critical'),
                  ],
                  selected: {importance},
                  onSelectionChanged: (Set<String> newSelection) {
                    setDialogState(() {
                      importance = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 18),

                // Comment field
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: 'Your feedback',
                    hintText: 'Be specific and actionable...',
                    prefixIcon: const Icon(Icons.message_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLines: 4,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedRecipient.isNotEmpty && commentController.text.isNotEmpty) {
                  final weight = importance == 'Critical' ? 50 : importance == 'Major' ? 30 : 10;

                  widget.appState.feedbackList.add({
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'from': 'James Bellano',
                    'to': selectedRecipient,
                    'type': feedbackType,
                    'comment': commentController.text,
                    'date': DateTime.now(),
                    'importance': importance,
                    'weight': weight,
                    'competency': 'Performance',
                    'status': 'Pending',
                  });
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Feedback submitted!')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// GOALS SCREEN
class GoalsScreen extends StatefulWidget {
  final AppState appState;

  const GoalsScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.appState.goalsList.length,
      itemBuilder: (context, index) {
        final goal = widget.appState.goalsList[index];
        final progress = (goal['progress'] as num).toDouble();
        final priority = goal['priority'] ?? 'Medium';
        final priorityColor = priority == 'High' ? Colors.red : priority == 'Medium' ? Colors.orange : Colors.green;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(goal['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Priority and Category badges
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(fontSize: 10, color: priorityColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        goal['category'] ?? 'General',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 0.8 ? Colors.green : progress >= 0.5 ? Colors.orange : Colors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showGoalDetailDialog(context, goal),
                      icon: const Icon(Icons.info, size: 16),
                      label: const Text('Details'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        backgroundColor: Colors.blue[400],
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showEditGoalDialog(context, goal),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _markGoalComplete(goal),
                      icon: Icon(goal['status'] == 'completed' ? Icons.undo : Icons.check, size: 16),
                      label: Text(goal['status'] == 'completed' ? 'Undo' : 'Done'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        backgroundColor: goal['status'] == 'completed' ? Colors.amber[600] : Colors.green[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _deleteGoal(goal),
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGoalDetailDialog(BuildContext context, Map<String, dynamic> goal) {
    final targetDate = goal['targetDate'] as DateTime;
    final createdAt = goal['createdAt'] as DateTime;
    final history = goal['history'] as List<dynamic>? ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(goal['title'], style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),

              // Key details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Priority: ${goal['priority'] ?? 'Medium'}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text('Category: ${goal['category'] ?? 'General'}', style: const TextStyle(fontSize: 13)),
                    Text('Quarter: ${goal['quarter'] ?? 'Q1 2026'}', style: const TextStyle(fontSize: 13)),
                    Text('Status: ${(goal['status'] ?? 'in_progress').toUpperCase()}', style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dates
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Target Date: ${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text('Created by ${goal['createdBy']} on ${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              Text('Notes:', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(goal['notes'] ?? 'No notes', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 16),

              // Change history
              Text('Change History', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: history.isEmpty
                    ? const Text('No changes yet', style: TextStyle(fontSize: 11, color: Colors.grey))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (history as List).map<Widget>((item) {
                          final Map<String, dynamic> h = item as Map<String, dynamic>;
                          final DateTime actionTime = h['at'] as DateTime;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${h['action']} by ${h['by']}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${actionTime.year}-${actionTime.month.toString().padLeft(2, '0')}-${actionTime.day.toString().padLeft(2, '0')} ${actionTime.hour.toString().padLeft(2, '0')}:${actionTime.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                                if (h['details'] != null)
                                  Text(h['details'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context, Map<String, dynamic> goal) {
    final titleController = TextEditingController(text: goal['title']);
    final notesController = TextEditingController(text: goal['notes']);
    final progressController = TextEditingController(text: '${(goal['progress'] * 100).toInt()}');
    String selectedPriority = goal['priority'] ?? 'Medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: progressController,
                  decoration: const InputDecoration(labelText: 'Progress (0-100)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  items: const [
                    DropdownMenuItem(value: 'Low', child: Text('Low')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'High', child: Text('High')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedPriority = value ?? 'Medium';
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final oldProgress = goal['progress'];
                final newProgress = (int.tryParse(progressController.text) ?? 0) / 100.0;

                // Update fields
                goal['title'] = titleController.text;
                goal['notes'] = notesController.text;
                goal['progress'] = newProgress;
                goal['priority'] = selectedPriority;

                // Log change to history
                List history = goal['history'] ?? [];
                history.add({
                  'action': 'Progress updated to ${(newProgress * 100).toInt()}%',
                  'by': 'James Bellano',
                  'at': DateTime.now(),
                  'details': 'Updated via Edit',
                });
                goal['history'] = history;

                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Updated & logged!')));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _markGoalComplete(Map<String, dynamic> goal) {
    final isCompleting = goal['status'] != 'completed';
    goal['status'] = isCompleting ? 'completed' : 'in_progress';

    if (isCompleting) {
      goal['progress'] = 1.0;
    }

    // Log change to history
    List history = goal['history'] ?? [];
    history.add({
      'action': isCompleting ? 'Marked as Completed' : 'Resumed',
      'by': 'James Bellano',
      'at': DateTime.now(),
      'details': isCompleting ? 'Goal completed' : 'Goal resumed',
    });
    goal['history'] = history;

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isCompleting ? '✅ Completed & logged!' : '⏳ Resumed & logged!')),
    );
  }

  void _deleteGoal(Map<String, dynamic> goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal?'),
        content: Text('Delete "${goal['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.appState.goalsList.removeWhere((g) => g['id'] == goal['id']);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🗑️ Deleted')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// REVIEWS SCREEN
class ReviewsScreen extends StatefulWidget {
  final AppState appState;

  const ReviewsScreen({Key? key, required this.appState}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String _filterCycle = 'All';

  @override
  Widget build(BuildContext context) {
    final allReviews = widget.appState.reviewsList;
    final filteredReviews = _filterCycle == 'All'
        ? allReviews
        : allReviews.where((r) => r['cycle'] == _filterCycle).toList();

    double avgRating = allReviews.isEmpty
        ? 0
        : allReviews.fold(0.0, (sum, r) => sum + (r['rating'] as num)) / allReviews.length;

    return Column(
      children: [
        // Simplified Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Performance Reviews', style: Theme.of(context).textTheme.titleLarge),
                  Text('${allReviews.length} total • Avg: ${avgRating.toStringAsFixed(1)}⭐',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              FloatingActionButton(
                onPressed: () => _showAddReviewDialog(context),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              FilterChip(
                selected: _filterCycle == 'All',
                label: const Text('All'),
                onSelected: (v) => setState(() => _filterCycle = 'All'),
              ),
              const SizedBox(width: 6),
              FilterChip(
                selected: _filterCycle == 'Annual',
                label: const Text('Annual'),
                onSelected: (v) => setState(() => _filterCycle = 'Annual'),
              ),
              const SizedBox(width: 6),
              FilterChip(
                selected: _filterCycle == 'Quarterly',
                label: const Text('Quarterly'),
                onSelected: (v) => setState(() => _filterCycle = 'Quarterly'),
              ),
              const SizedBox(width: 6),
              FilterChip(
                selected: _filterCycle == 'Monthly',
                label: const Text('Monthly'),
                onSelected: (v) => setState(() => _filterCycle = 'Monthly'),
              ),
            ],
          ),
        ),
        // Reviews List
        Expanded(
          child: filteredReviews.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assessment_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('No reviews found', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: filteredReviews.length,
                  itemBuilder: (context, index) {
                    final review = filteredReviews[index];
                    final rating = review['rating'] as num;
                    final cycle = review['cycle'] as String;
                    final cycleColor = cycle == 'Annual' ? Colors.purple : cycle == 'Quarterly' ? Colors.blue : Colors.green;

                    return GestureDetector(
                      onTap: () => _showReviewDetails(context, review),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
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
                                        Text(review['employee'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        SizedBox(height: 2, child: Text(cycle, style: TextStyle(fontSize: 11, color: Colors.grey[600]))),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(color: cycleColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                                    child: Text('$rating⭐', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: cycleColor)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(color: Colors.purple.withOpacity(0.15), borderRadius: BorderRadius.circular(3)),
                                      child: Text('⚖️ ${review['weight']}%', style: const TextStyle(fontSize: 10, color: Colors.purple)),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(3)),
                                      child: Text('📊 ${(review['keyMetrics'] as List?)?.length ?? 0}', style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }


  void _showReviewDetails(BuildContext context, Map<String, dynamic> review) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review['employee'], style: Theme.of(context).textTheme.titleLarge),
                      Text(review['cycle'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: Text('${review['rating']}⭐', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Review Details', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildDetailRow('Weight', '${review['weight']}%'),
                    _buildDetailRow('Metrics', (review['keyMetrics'] as List?)?.join(', ') ?? 'N/A'),
                    _buildDetailRow('Date', '${review['date'].year}-${review['date'].month}-${review['date'].day}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(review['comment'], style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Acknowledge'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    final employees = AppState().employeeNames;

    String selectedEmployee = '';
    String reviewCycle = 'Quarterly';
    double rating = 4.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create Review'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Employee Dropdown with all names visible
                DropdownButtonFormField<String>(
                  value: selectedEmployee.isEmpty ? null : selectedEmployee,
                  hint: const Text('🔽 Select Employee Name'),
                  items: employees.map((emp) {
                    return DropdownMenuItem<String>(
                      value: emp,
                      child: Text(emp),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedEmployee = value ?? '';
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Employee',
                    prefixIcon: const Icon(Icons.person),
                    border: const OutlineInputBorder(),
                    helperText: 'Tap to see all 10 employees',
                  ),
                ),
                const SizedBox(height: 12),
                // Show selected employee
                if (selectedEmployee.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      border: Border.all(color: Colors.green[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700], size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Selected: $selectedEmployee',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                // Cycle Type
                DropdownButtonFormField<String>(
                  value: reviewCycle,
                  items: const [
                    DropdownMenuItem(value: 'Annual', child: Text('Annual')),
                    DropdownMenuItem(value: 'Quarterly', child: Text('Quarterly')),
                    DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      reviewCycle = value ?? 'Quarterly';
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Review Cycle'),
                ),
                const SizedBox(height: 12),
                // Rating
                Text('⭐ Rating: ${rating.toStringAsFixed(1)} / 5.0',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: rating,
                  onChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                  min: 1.0,
                  max: 5.0,
                  divisions: 40,
                ),
                const SizedBox(height: 12),
                // Comments
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: 'Comments',
                    hintText: 'Add your feedback here...',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.comment),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedEmployee.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⚠️ Please select an employee')),
                  );
                  return;
                }
                if (commentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⚠️ Please add comments')),
                  );
                  return;
                }

                widget.appState.addReview(
                  selectedEmployee,
                  reviewCycle,
                  rating,
                  commentController.text,
                );
                Navigator.pop(context);
                this.setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Review for $selectedEmployee created!')),
                );
              },
              child: const Text('Create Review'),
            ),
          ],
        ),
      ),
    );
  }
}

// HEATMAP SCREEN
class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Heatmap', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Department Performance by Geography', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 16),
                  _buildHeatmapGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapGrid() {
    const data = [
      [4.5, 4.2, 3.8],
      [4.7, 4.1, 3.5],
      [3.9, 3.6, 2.0],
      [2.8, 3.2, 3.1],
    ];

    const departments = ['Engineering', 'Customer Success', 'Finance', 'Marketing'];
    const regions = ['North America', 'EMEA', 'LATAM'];

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 100),
            ...regions.map(
              (region) => Expanded(
                child: Center(
                  child: Text(region, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
        ...List.generate(
          data.length,
          (deptIndex) => Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(departments[deptIndex], style: const TextStyle(fontSize: 10)),
              ),
              ...List.generate(
                data[deptIndex].length,
                (regIndex) => Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _getHeatmapColor(data[deptIndex][regIndex]),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${data[deptIndex][regIndex]}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getHeatmapColor(double value) {
    if (value >= 4.5) return const Color(0xFF0d5d00);
    if (value >= 4.0) return const Color(0xFF4dad00);
    if (value >= 3.5) return const Color(0xFFb3d900);
    if (value >= 3.0) return const Color(0xFFffcc00);
    if (value >= 2.5) return const Color(0xFFff9900);
    return const Color(0xFFff3300);
  }
}
