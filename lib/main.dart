import 'package:flutter/material.dart';

// ELEVATE Brand Colors
const Color elevateBlue = Color(0xFF0066CC);
const Color elevateGreen = Color(0xFF00A651);
const Color elevateLightBg = Color(0xFFF5F7FA);

void main() {
  runApp(const ElevateApp());
}

// Company Data Model
class CompanyProfile {
  final String id;
  final String name;
  final String tagline;
  final Color accentColor;
  final List<Employee> employees;
  final List<Feedback> feedbacks;
  final List<Goal> goals;
  final List<Review> reviews;
  final List<List<double>> heatmapData;
  final List<String> departments;
  final List<String> regions;

  CompanyProfile({
    required this.id,
    required this.name,
    required this.tagline,
    required this.accentColor,
    required this.employees,
    required this.feedbacks,
    required this.goals,
    required this.reviews,
    required this.heatmapData,
    required this.departments,
    required this.regions,
  });
}

class Employee {
  final String name;
  final String dept;
  final String region;
  Employee(this.name, this.dept, this.region);
}

class Feedback {
  final String name;
  final String type;
  final String comment;
  Feedback(this.name, this.type, this.comment);
}

class Goal {
  final String name;
  final double progress;
  Goal(this.name, this.progress);
}

class Review {
  final String name;
  final String cycle;
  final String rating;
  Review(this.name, this.cycle, this.rating);
}

// Generate company data
final CompanyProfile companyA = CompanyProfile(
  id: 'A',
  name: 'Company A',
  tagline: 'Tech Solutions',
  accentColor: elevateBlue,
  employees: [
    Employee('Alice Johnson', 'Engineering', 'North America'),
    Employee('Bob Smith', 'Sales', 'EMEA'),
    Employee('Carol Davis', 'Marketing', 'APAC'),
    Employee('David Wilson', 'Engineering', 'North America'),
    Employee('Emma Brown', 'HR', 'Global'),
    Employee('Frank Miller', 'Finance', 'North America'),
    Employee('Grace Lee', 'Product', 'APAC'),
    Employee('Henry Taylor', 'Customer Success', 'EMEA'),
    Employee('Ivy Chen', 'Engineering', 'APAC'),
    Employee('Jack Robinson', 'Sales', 'North America'),
  ],
  feedbacks: [
    Feedback('Alice Johnson', 'Positive', 'Excellent code quality'),
    Feedback('Bob Smith', 'Constructive', 'Improve follow-up'),
    Feedback('Carol Davis', 'Positive', 'Great campaign ideas'),
    Feedback('David Wilson', 'Positive', 'Strong technical skills'),
    Feedback('Emma Brown', 'Constructive', 'More proactive support'),
  ],
  goals: [
    Goal('Launch feature', 0.9),
    Goal('Team engagement', 0.7),
    Goal('Code quality', 0.85),
    Goal('Reduce bugs', 0.8),
  ],
  reviews: [
    Review('Alice Johnson', 'Annual', '4.7'),
    Review('Bob Smith', 'Quarterly', '4.2'),
    Review('Carol Davis', 'Annual', '4.5'),
    Review('David Wilson', 'Quarterly', '4.6'),
  ],
  heatmapData: [
    [4.5, 4.2, 3.8],
    [4.7, 4.1, 3.5],
    [3.9, 3.6, 2.0],
    [2.8, 3.2, 3.1],
  ],
  departments: ['Engineering', 'Sales', 'Marketing', 'HR'],
  regions: ['North America', 'EMEA', 'APAC'],
);

final CompanyProfile companyB = CompanyProfile(
  id: 'B',
  name: 'Company B',
  tagline: 'Retail & Commerce',
  accentColor: elevateGreen,
  employees: [
    Employee('Sarah Mitchell', 'Operations', 'North America'),
    Employee('Tom Nakamura', 'Sales', 'APAC'),
    Employee('Uma Patel', 'Marketing', 'EMEA'),
    Employee('Victor Lee', 'Finance', 'Global'),
    Employee('Wendy Zhang', 'HR', 'North America'),
    Employee('Xavier Lopez', 'Customer Service', 'LATAM'),
    Employee('Yuki Tanaka', 'Operations', 'APAC'),
    Employee('Zoe Anderson', 'Product', 'EMEA'),
    Employee('Adam Green', 'Sales', 'LATAM'),
    Employee('Beth white', 'Marketing', 'North America'),
  ],
  feedbacks: [
    Feedback('Sarah Mitchell', 'Positive', 'Outstanding leadership'),
    Feedback('Tom Nakamura', 'Constructive', 'Improve reporting'),
    Feedback('Uma Patel', 'Positive', 'Innovative ideas'),
    Feedback('Victor Lee', 'Positive', 'Meticulous analysis'),
    Feedback('Wendy Zhang', 'Constructive', 'More visibility needed'),
  ],
  goals: [
    Goal('Market expansion', 0.75),
    Goal('Customer retention', 0.88),
    Goal('Efficiency gains', 0.82),
    Goal('Team growth', 0.65),
  ],
  reviews: [
    Review('Sarah Mitchell', 'Annual', '4.6'),
    Review('Tom Nakamura', 'Quarterly', '4.3'),
    Review('Uma Patel', 'Annual', '4.8'),
    Review('Victor Lee', 'Quarterly', '4.4'),
  ],
  heatmapData: [
    [4.2, 3.9, 4.1],
    [4.5, 4.3, 3.8],
    [3.7, 3.4, 3.2],
    [3.1, 3.5, 2.9],
  ],
  departments: ['Operations', 'Sales', 'Marketing', 'Finance'],
  regions: ['North America', 'EMEA', 'LATAM'],
);

final CompanyProfile companyC = CompanyProfile(
  id: 'C',
  name: 'Company C',
  tagline: 'Financial Services',
  accentColor: const Color(0xFF1f3a5f),
  employees: [
    Employee('Charles Brown', 'Risk', 'North America'),
    Employee('Diana Prince', 'Compliance', 'EMEA'),
    Employee('Eric Stone', 'Trading', 'APAC'),
    Employee('Fiona Scott', 'Client Relations', 'North America'),
    Employee('George Martin', 'Technology', 'Global'),
    Employee('Helen Price', 'Operations', 'LATAM'),
    Employee('Iris Lane', 'Analytics', 'APAC'),
    Employee('James Bond', 'Trading', 'EMEA'),
    Employee('Karen Bell', 'Compliance', 'North America'),
    Employee('Leo Fox', 'Client Relations', 'LATAM'),
  ],
  feedbacks: [
    Feedback('Charles Brown', 'Positive', 'Exceptional risk judgment'),
    Feedback('Diana Prince', 'Constructive', 'Document more thoroughly'),
    Feedback('Eric Stone', 'Positive', 'Strong market insight'),
    Feedback('Fiona Scott', 'Positive', 'Client satisfaction high'),
    Feedback('George Martin', 'Constructive', 'Improve documentation'),
  ],
  goals: [
    Goal('Compliance rate', 0.95),
    Goal('Client satisfaction', 0.89),
    Goal('Risk mitigation', 0.92),
    Goal('System uptime', 0.98),
  ],
  reviews: [
    Review('Charles Brown', 'Annual', '4.8'),
    Review('Diana Prince', 'Quarterly', '4.5'),
    Review('Eric Stone', 'Annual', '4.7'),
    Review('Fiona Scott', 'Quarterly', '4.9'),
  ],
  heatmapData: [
    [4.8, 4.5, 4.2],
    [4.7, 4.6, 4.4],
    [4.4, 4.3, 4.1],
    [4.2, 4.1, 3.9],
  ],
  departments: ['Risk', 'Compliance', 'Trading', 'Operations'],
  regions: ['North America', 'EMEA', 'APAC'],
);

class ElevateApp extends StatefulWidget {
  const ElevateApp({super.key});

  @override
  State<ElevateApp> createState() => _ElevateAppState();
}

class _ElevateAppState extends State<ElevateApp> {
  CompanyProfile? selectedCompany;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elevate',
      theme: ThemeData(
        primaryColor: elevateBlue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: elevateBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: selectedCompany == null
          ? CompanyPickerScreen(
              onCompanySelected: (company) {
                setState(() => selectedCompany = company);
              },
            )
          : MainScreen(company: selectedCompany!),
    );
  }
}

// Company Picker Screen
class CompanyPickerScreen extends StatelessWidget {
  final Function(CompanyProfile) onCompanySelected;

  const CompanyPickerScreen({
    Key? key,
    required this.onCompanySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: elevateLightBg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ELEVATE Logo/Text
              Container(
                margin: const EdgeInsets.only(bottom: 48),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [elevateBlue, elevateGreen],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.trending_up,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'ELEVATE',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: elevateBlue,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Real-time Performance Management',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Select Organization',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: elevateBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              _buildCompanyCard(context, companyA),
              const SizedBox(height: 16),
              _buildCompanyCard(context, companyB),
              const SizedBox(height: 16),
              _buildCompanyCard(context, companyC),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, CompanyProfile company) {
    return GestureDetector(
      onTap: () => onCompanySelected(company),
      child: Card(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: company.accentColor, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    company.tagline,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: company.accentColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main Screen (Tabs)
class MainScreen extends StatefulWidget {
  final CompanyProfile company;

  const MainScreen({Key? key, required this.company}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.company.name, style: const TextStyle(fontSize: 18)),
            Text(
              widget.company.tagline,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.business),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ElevateApp(),
              ),
            ),
            tooltip: 'Switch Organization',
          ),
        ],
      ),
      body: _buildScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: widget.company.accentColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Team'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
          BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Reviews'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: 'Heatmap'),
        ],
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return DashboardScreen(company: widget.company);
      case 1:
        return TeamScreen(company: widget.company);
      case 2:
        return FeedbackScreen(company: widget.company);
      case 3:
        return GoalsScreen(company: widget.company);
      case 4:
        return ReviewsScreen(company: widget.company);
      case 5:
        return HeatmapScreen(company: widget.company);
      default:
        return DashboardScreen(company: widget.company);
    }
  }
}

// Dashboard Screen
class DashboardScreen extends StatelessWidget {
  final CompanyProfile company;
  const DashboardScreen({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Overview',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildMetricCard('Team Members', '${company.employees.length}',
              company.accentColor),
          const SizedBox(height: 8),
          _buildMetricCard('Positive', '${company.feedbacks.where((f) => f.type == 'Positive').length}',
              Colors.green),
          const SizedBox(height: 8),
          _buildMetricCard('Constructive', '${company.feedbacks.where((f) => f.type == 'Constructive').length}',
              Colors.orange),
          const SizedBox(height: 8),
          _buildMetricCard('Goals', '${company.goals.length}',
              Colors.purple),
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
  final CompanyProfile company;
  const TeamScreen({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: company.employees.length,
      itemBuilder: (context, index) {
        final emp = company.employees[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: company.accentColor,
              child: Text('${index + 1}'),
            ),
            title: Text(emp.name),
            subtitle: Text('${emp.dept} • ${emp.region}'),
            trailing: const Icon(Icons.arrow_forward),
          ),
        );
      },
    );
  }
}

// Feedback Screen
class FeedbackScreen extends StatelessWidget {
  final CompanyProfile company;
  const FeedbackScreen({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: company.feedbacks.length,
      itemBuilder: (context, index) {
        final fb = company.feedbacks[index];
        final color = fb.type == 'Positive' ? Colors.green : Colors.orange;
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
                    Text(fb.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(fb.type,
                          style:
                              TextStyle(color: color, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(fb.comment),
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
  final CompanyProfile company;
  const GoalsScreen({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: company.goals.length,
      itemBuilder: (context, index) {
        final goal = company.goals[index];
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
                    Text(goal.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${(goal.progress * 100).toInt()}%'),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: goal.progress,
                    minHeight: 8,
                    color: company.accentColor,
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
  final CompanyProfile company;
  const ReviewsScreen({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: company.reviews.length,
      itemBuilder: (context, index) {
        final review = company.reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(review.name),
            subtitle: Text('${review.cycle} Review'),
            trailing: Container(
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: company.accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                review.rating,
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
  final CompanyProfile company;
  const HeatmapScreen({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Heatmap',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('${company.departments.join(" • ")} by Region',
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
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 100),
            ...company.regions.map(
              (region) => Expanded(
                child: Center(
                  child: Text(region, style: const TextStyle(fontSize: 11)),
                ),
              ),
            ),
          ],
        ),
        ...List.generate(
          company.heatmapData.length,
          (deptIndex) => Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(company.departments[deptIndex],
                    style: const TextStyle(fontSize: 10)),
              ),
              ...List.generate(
                company.heatmapData[deptIndex].length,
                (regIndex) => Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _getHeatmapColor(
                            company.heatmapData[deptIndex][regIndex]),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${company.heatmapData[deptIndex][regIndex]}',
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
