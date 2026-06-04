import 'package:flutter/material.dart';

void main() {
  runApp(const PulseReviewApp());
}

class PulseReviewApp extends StatelessWidget {
  const PulseReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseReview Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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

    final email = _emailController.text;
    final password = _passwordController.text;

    // Simple hardcoded auth
    if (email == 'james.bellano@acmecorp.com' && password == 'demo123') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(
            userName: 'James Bellano',
            userRole: 'Director',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
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
                  Text(
                    'PulseReview',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Real-time Performance Management',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
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

class MainScreen extends StatefulWidget {
  final String userName;
  final String userRole;

  const MainScreen({
    Key? key,
    required this.userName,
    required this.userRole,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName} - ${widget.userRole}'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
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
        return const DashboardScreen();
      case 1:
        return const TeamScreen();
      case 2:
        return const FeedbackScreen();
      case 3:
        return const GoalsScreen();
      case 4:
        return const ReviewsScreen();
      case 5:
        return const HeatmapScreen();
      default:
        return const DashboardScreen();
    }
  }
}

// Dashboard Screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Overview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildMetricCard('Team Members', '12', Colors.blue),
          const SizedBox(height: 8),
          _buildMetricCard('Positive Feedback', '89', Colors.green),
          const SizedBox(height: 8),
          _buildMetricCard('Constructive Feedback', '23', Colors.orange),
          const SizedBox(height: 8),
          _buildMetricCard('Avg Rating', '4.2', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
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

// Team Screen
class TeamScreen extends StatelessWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employees = [
      'Alice Johnson - Engineering',
      'Bob Smith - Sales',
      'Carol Davis - Marketing',
      'David Wilson - Engineering',
      'Emma Brown - HR',
      'Frank Miller - Finance',
      'Grace Lee - Product',
      'Henry Taylor - Customer Success',
      'Ivy Chen - Engineering',
      'Jack Robinson - Sales',
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('${index + 1}'),
            ),
            title: Text(employees[index]),
            trailing: const Icon(Icons.arrow_forward),
          ),
        );
      },
    );
  }
}

// Feedback Screen
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedbacks = [
      ('Alice Johnson', 'Positive', 'Great work on the project'),
      ('Bob Smith', 'Constructive', 'Could improve communication'),
      ('Carol Davis', 'Positive', 'Excellent presentation skills'),
      ('David Wilson', 'Positive', 'Strong technical expertise'),
      ('Emma Brown', 'Constructive', 'Needs to be more proactive'),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: feedbacks.length,
      itemBuilder: (context, index) {
        final (name, type, comment) = feedbacks[index];
        final color = type == 'Positive' ? Colors.green : Colors.orange;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(type, style: TextStyle(color: color, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(comment),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Goals Screen
class GoalsScreen extends StatelessWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final goals = [
      ('Improve code quality', 0.8),
      ('Increase team engagement', 0.6),
      ('Launch new feature', 0.9),
      ('Reduce bugs', 0.7),
      ('Improve documentation', 0.5),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final (goal, progress) = goals[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(goal, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${(progress * 100).toInt()}%'),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Reviews Screen
class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reviews = [
      ('Alice Johnson', 'Annual', '4.5'),
      ('Bob Smith', 'Quarterly', '4.0'),
      ('Carol Davis', 'Annual', '4.8'),
      ('David Wilson', 'Quarterly', '4.3'),
      ('Emma Brown', 'Annual', '4.1'),
      ('Frank Miller', 'Quarterly', '4.6'),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final (name, cycle, rating) = reviews[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(name),
            subtitle: Text('$cycle Review'),
            trailing: Container(
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                rating,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Heatmap Screen
class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Heatmap',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Department Performance by Geography',
                      style: Theme.of(context).textTheme.labelLarge),
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
                  child: Text(region, style: const TextStyle(fontSize: 12)),
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
                child: Text(departments[deptIndex], style: const TextStyle(fontSize: 11)),
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
