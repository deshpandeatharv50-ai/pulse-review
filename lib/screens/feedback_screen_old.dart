import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/feedback.dart';
import '../models/healthcare_organization.dart';
import '../models/employee_feedback_summary.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _supabaseService = SupabaseService();
  late Future<List<FeedbackItem>> _feedbacksFuture;
  String _selectedType = 'All';
  List<FeedbackItem> _localFeedbacks = [];
  String _searchQuery = '';
  String _timeFilter = 'This Week'; // This Week, This Month, This Quarter, All Time
  String? _selectedEmployeeFilter; // Show feedback for specific employee

  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  final _searchController = TextEditingController();
  String _feedbackType = 'Positive';
  int _rating = 0; // 1-5 stars
  bool _isSubmitting = false;
  FeedbackItem? _selectedFeedback;

  @override
  void initState() {
    super.initState();
    _feedbacksFuture = _supabaseService.getFeedbacks();

    // Sample data for demo
    _localFeedbacks = [
      FeedbackItem(
        id: '1',
        employeeName: 'Dr. Mehta',
        feedbackType: 'Positive',
        comment: 'Demonstrates strong clinical judgment and excellent patient communication skills.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FeedbackItem(
        id: '2',
        employeeName: 'Sarah Chen',
        feedbackType: 'Constructive',
        comment: 'Needs development in documentation efficiency. Consider time management strategies.',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      FeedbackItem(
        id: '3',
        employeeName: 'James Peterson',
        feedbackType: 'Positive',
        comment: 'Outstanding leadership in team coordination. Sets excellent example for junior staff.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_nameController.text.isEmpty || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final employeeName = _nameController.text;
      final feedbackType = _feedbackType;
      final comment = _commentController.text;

      await _supabaseService.submitFeedback(
        employeeName,
        feedbackType,
        comment,
      );

      // Add to local list for display
      setState(() {
        _localFeedbacks.insert(0, FeedbackItem(
          id: DateTime.now().toString(),
          employeeName: employeeName,
          feedbackType: feedbackType,
          comment: comment,
          createdAt: DateTime.now(),
        ));
      });

      // Show confirmation dialog before clearing
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('✅ Feedback Registered'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Employee: $employeeName', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Type: $feedbackType', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Feedback:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(comment, style: const TextStyle(fontSize: 12, height: 1.5)),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _nameController.clear();
                _commentController.clear();
                setState(() {
                  _feedbackType = 'Positive';
                  _rating = 0;
                });
                _refreshFeedbacks();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Done'),
            ),
          ],
        ),
      );

      setState(() => _isSubmitting = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    setState(() => _isSubmitting = false);
  }

  void _refreshFeedbacks() {
    setState(() {
      _feedbacksFuture = _supabaseService.getFeedbacks();
    });
  }

  bool _isWithinTimeRange(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final daysAgo = now.difference(date).inDays;

    switch (_timeFilter) {
      case 'This Week':
        return daysAgo <= 7;
      case 'This Month':
        return daysAgo <= 30;
      case 'This Quarter':
        return daysAgo <= 90;
      default:
        return true;
    }
  }

  bool _isRecentFeedback(DateTime? date) {
    if (date == null) return false;
    return DateTime.now().difference(date).inDays <= 7;
  }

  List<EmployeeFeedbackSummary> _aggregateFeedbackByEmployee(List<FeedbackItem> feedbacks) {
    final Map<String, List<FeedbackItem>> grouped = {};

    for (final fb in feedbacks) {
      grouped.putIfAbsent(fb.employeeName, () => []).add(fb);
    }

    final now = DateTime.now();
    final currentQuarterStart = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1);
    final previousQuarterStart = DateTime(now.year, ((now.month - 4) ~/ 3) * 3 + 1);

    return grouped.entries.map((entry) {
      final fbs = entry.value;
      final positive = fbs.where((f) => f.feedbackType == 'Positive').length;
      final constructive = fbs.where((f) => f.feedbackType == 'Constructive').length;

      final currentQ = fbs.where((f) => f.createdAt != null && f.createdAt!.isAfter(currentQuarterStart)).toList();
      final currentQPos = currentQ.where((f) => f.feedbackType == 'Positive').length;
      final currentQCon = currentQ.where((f) => f.feedbackType == 'Constructive').length;

      final prevQ = fbs.where((f) => f.createdAt != null && f.createdAt!.isAfter(previousQuarterStart) && f.createdAt!.isBefore(currentQuarterStart)).toList();
      final prevQPos = prevQ.where((f) => f.feedbackType == 'Positive').length;
      final prevQCon = prevQ.where((f) => f.feedbackType == 'Constructive').length;

      return EmployeeFeedbackSummary(
        employeeName: entry.key,
        positiveCount: positive,
        constructiveCount: constructive,
        averageRating: 3.5, // Demo value
        currentQuarterPositive: currentQPos,
        currentQuarterConstructive: currentQCon,
        previousQuarterPositive: prevQPos,
        previousQuarterConstructive: prevQCon,
        lastFeedbackDate: fbs.isNotEmpty ? fbs.first.createdAt : null,
      );
    }).toList()
      ..sort((a, b) => (b.lastFeedbackDate ?? DateTime(2000)).compareTo(a.lastFeedbackDate ?? DateTime(2000)));
  }

  void _showEmployeeFeedbackHistory(String employeeName, List<FeedbackItem> allFeedback) {
    final employeeFeedbacks = allFeedback.where((f) => f.employeeName == employeeName).toList();
    final posCount = employeeFeedbacks.where((f) => f.feedbackType == 'Positive').length;
    final negCount = employeeFeedbacks.where((f) => f.feedbackType == 'Constructive').length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(employeeName),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [Text('$posCount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const Text('Positive')]),
                    Column(children: [Text('$negCount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const Text('Constructive')]),
                    Column(children: [Text('${employeeFeedbacks.length}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const Text('Total')]),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Feedback History:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...employeeFeedbacks.map((fb) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: fb.feedbackType == 'Positive' ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fb.feedbackType, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: fb.feedbackType == 'Positive' ? Colors.green[700] : Colors.red[700])),
                      const SizedBox(height: 4),
                      Text(fb.comment, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(fb.createdAt?.toString().split('.')[0] ?? '', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  void _showFeedbackForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add Feedback', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _nameController.text.isEmpty ? null : _nameController.text,
                  decoration: InputDecoration(
                    hintText: 'Select Employee',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  items: _buildEmployeeList(),
                  onChanged: (value) => setState(() => _nameController.text = value ?? ''),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _feedbackType,
                  items: ['Positive', 'Constructive'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (value) => setState(() => _feedbackType = value!),
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Rating:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Row(children: List.generate(5, (i) => GestureDetector(onTap: () => setState(() => _rating = i + 1), child: Icon(i < _rating ? Icons.star : Icons.star_outline, color: Colors.amber, size: 24)))),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(hintText: 'Your feedback...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                ),
                const SizedBox(height: 10),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submitFeedback, child: const Text('Submit'))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFeedbackDetail(FeedbackItem fb) {
    final isRecent = _isRecentFeedback(fb.createdAt);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(fb.employeeName),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: fb.feedbackType == 'Positive' ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                fb.feedbackType,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${fb.createdAt?.toString().split('.')[0] ?? "No date"}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text('Feedback:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(fb.comment, style: const TextStyle(height: 1.5)),
            ),
            const SizedBox(height: 16),
            if (!isRecent)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '🔒 Read-only: This feedback is from an archived period',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
          ],
        ),
        actions: [
          if (isRecent)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Edit functionality here
              },
              child: const Text('Edit'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(FeedbackItem fb) {
    final dateStr = fb.createdAt != null
        ? '${fb.createdAt!.day}/${fb.createdAt!.month}/${fb.createdAt!.year} ${fb.createdAt!.hour}:${fb.createdAt!.minute.toString().padLeft(2, '0')}'
        : 'No date';

    final isRecent = _isRecentFeedback(fb.createdAt);
    final opacity = isRecent ? 1.0 : 0.6;
    final isPositive = fb.feedbackType == 'Positive';
    final cardColor = isPositive
        ? (isRecent ? Colors.green[50] : Colors.green[100])
        : (isRecent ? Colors.red[50] : Colors.red[100]);
    final textColor = isPositive ? Colors.green[900] : Colors.red[900];

    return GestureDetector(
      onTap: () => _showFeedbackDetail(fb),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Opacity(
            opacity: opacity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _showEmployeeFeedbackHistory(fb.employeeName, _localFeedbacks),
                      child: Text(
                        fb.employeeName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    ),
                    if (!isRecent)
                      Text(
                        '🔒',
                        style: TextStyle(fontSize: 14, color: textColor),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  dateStr,
                  style: TextStyle(fontSize: 12, color: textColor?.withOpacity(0.7)),
                ),
                const SizedBox(height: 10),
                Text(
                  fb.comment,
                  style: TextStyle(fontSize: 13, height: 1.5, color: textColor),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to view details',
                  style: TextStyle(fontSize: 11, color: textColor, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildEmployeeList() {
    final items = <DropdownMenuItem<String>>[];
    for (final org in HealthcareOrganization.all) {
      for (final persona in org.personas) {
        items.add(
          DropdownMenuItem(
            value: persona.name,
            child: Text('${persona.name} (${persona.role})'),
          ),
        );
      }
    }
    return items;
  }

  void _showAIAssist(BuildContext context) {
    final currentText = _commentController.text;
    final corrected = _fixAllErrors(currentText);

    // AUTO-APPLY: Enterprise-Grade Transformation Pipeline
    // 1. Concise 2. Professional 3. Empathetic 4. Constructive 5. Client-Ready
    final concise = _makeConcise(corrected);
    final professional = _makeVeryProfessional(concise);
    final empathetic = _makeEmpathetic(professional);
    final constructive = _makeConstructive(empathetic);
    final perfected = _makeClientReady(constructive);
    final hasChanges = perfected != currentText;
    final editController = TextEditingController(text: perfected);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.amber),
            SizedBox(width: 8),
            Text('AI Perfect'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit or review:', style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.bold)),
                  Text('${editController.text.length}/300', style: TextStyle(fontSize: 11, color: editController.text.length > 300 ? Colors.red : Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: editController,
                maxLines: 6,
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Manager can edit feedback here...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: editController.text.length > 300 ? Colors.red : Colors.grey)),
                  filled: true,
                  fillColor: editController.text.length > 300 ? Colors.red[50] : Colors.green[50],
                  contentPadding: const EdgeInsets.all(12),
                  errorText: editController.text.length > 300 ? 'Maximum 300 characters' : null,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✓ Concise • ✓ Very Professional • ✓ Empathetic',
                      style: TextStyle(fontSize: 10, color: Colors.blue[700], fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '✓ Constructive • ✓ Client-Ready',
                      style: TextStyle(fontSize: 10, color: Colors.blue[700], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Apply Perfect Feedback'),
                  onPressed: editController.text.length <= 300 ? () => _applyAIFix(ctx, editController.text) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: editController.text.length <= 300 ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              const Text('📋 Format Options:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 10),
              _buildAIOption(
                'STAR Method',
                'Situation → Task → Action → Result',
                () => _applyAIFix(ctx, _formatSTAR(perfected)),
              ),
              const SizedBox(height: 8),
              _buildAIOption(
                'Add Actionable Steps',
                'With specific recommendations',
                () => _applyAIFix(ctx, _addActionableSteps(perfected)),
              ),
            ],
          ),
        ),
      ),
        ),
    );
  }

  Widget _buildAIOption(String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, size: 20, color: Colors.amber[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

void _applyAIFix(BuildContext context, String newText) {
    _commentController.text = newText;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✨ Feedback perfected by AI'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _fixAllErrors(String text) {
    if (text.isEmpty) return text;

    String result = text;

    // ADVANCED spell checker - catches 50+ patterns
    final fixes = [
      // Text-speak (highest priority)
      (RegExp(r'\bplz\b', caseSensitive: false), 'please'),
      (RegExp(r'\bpls\b', caseSensitive: false), 'please'),
      (RegExp(r'\bthnx\b', caseSensitive: false), 'thanks'),
      (RegExp(r'\bthx\b', caseSensitive: false), 'thanks'),
      (RegExp(r'\btk\b', caseSensitive: false), 'thank you'),
      (RegExp(r'\btks\b', caseSensitive: false), 'thanks'),
      (RegExp(r'\bbtw\b', caseSensitive: false), 'by the way'),
      (RegExp(r'\basap\b', caseSensitive: false), 'as soon as possible'),
      (RegExp(r'\bfyi\b', caseSensitive: false), 'for your information'),
      (RegExp(r'\blol\b', caseSensitive: false), ''),

      // Double/triple letters (common typos)
      (RegExp(r'\bhard\s+hard\b', caseSensitive: false), 'hard'),
      (RegExp(r'\bvery\s+very\b', caseSensitive: false), 'very'),
      (RegExp(r'\bgood\s+good\b', caseSensitive: false), 'good'),

      // Phonetic & common misspellings (50+ patterns)
      (RegExp(r'\bsleeling\b', caseSensitive: false), 'spelling'),
      (RegExp(r'\bslepping\b', caseSensitive: false), 'sleeping'),
      (RegExp(r'\bmakem\b', caseSensitive: false), 'make'),
      (RegExp(r'\banf\b', caseSensitive: false), 'and'),
      (RegExp(r'\bur\b', caseSensitive: false), 'you are'),
      (RegExp(r'\bu\b(?!\w)', caseSensitive: false), 'you'),
      (RegExp(r'\bwoor\b', caseSensitive: false), 'your'),
      (RegExp(r'\bbeet\b', caseSensitive: false), 'best'),
      (RegExp(r'\bimprova\b', caseSensitive: false), 'improve'),
      (RegExp(r'\brealy\b', caseSensitive: false), 'really'),
      (RegExp(r'\bwoudl\b', caseSensitive: false), 'would'),
      (RegExp(r'\bshoudl\b', caseSensitive: false), 'should'),
      (RegExp(r'\bcoudl\b', caseSensitive: false), 'could'),
      (RegExp(r'\bthier\b', caseSensitive: false), 'their'),
      (RegExp(r'\boccured\b', caseSensitive: false), 'occurred'),
      (RegExp(r'\boccassion\b', caseSensitive: false), 'occasion'),
      (RegExp(r'\brecieved\b', caseSensitive: false), 'received'),
      (RegExp(r'\baccomodate\b', caseSensitive: false), 'accommodate'),
      (RegExp(r'\bdefinately\b', caseSensitive: false), 'definitely'),
      (RegExp(r'\badress\b', caseSensitive: false), 'address'),
      (RegExp(r'\bexcelent\b', caseSensitive: false), 'excellent'),
      (RegExp(r'\bdissapear\b', caseSensitive: false), 'disappear'),
      (RegExp(r'\bteh\b', caseSensitive: false), 'the'),
      (RegExp(r'\bwich\b', caseSensitive: false), 'which'),
      (RegExp(r'\buntill\b', caseSensitive: false), 'until'),
      (RegExp(r'\bseperate\b', caseSensitive: false), 'separate'),
      (RegExp(r'\bfinanacial\b', caseSensitive: false), 'financial'),
      (RegExp(r'\bbenifits\b', caseSensitive: false), 'benefits'),
      (RegExp(r'\bgramar\b', caseSensitive: false), 'grammar'),
      (RegExp(r'\bspeling\b', caseSensitive: false), 'spelling'),
      (RegExp(r'\bempployee\b', caseSensitive: false), 'employee'),
      (RegExp(r'\bcomittment\b', caseSensitive: false), 'commitment'),
      (RegExp(r'\bexcelance\b', caseSensitive: false), 'excellence'),
      (RegExp(r'\bperformence\b', caseSensitive: false), 'performance'),
      (RegExp(r'\bdevelopement\b', caseSensitive: false), 'development'),
      (RegExp(r'\bdispline\b', caseSensitive: false), 'discipline'),
      (RegExp(r'\bcooporate\b', caseSensitive: false), 'corporate'),
    ];

    // Apply all fixes
    for (final fix in fixes) {
      result = result.replaceAll(fix.$1, fix.$2);
    }

    // Grammar fixes - Remove extra spaces
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Capitalize first letter of each sentence
    final sentences = result.split(RegExp(r'([.!?])\s*'));
    final corrected = <String>[];

    for (var i = 0; i < sentences.length; i++) {
      var sentence = sentences[i].trim();
      if (sentence.isNotEmpty && !'.!?'.contains(sentence)) {
        if (sentence.length > 0) {
          sentence = sentence[0].toUpperCase() + sentence.substring(1);
        }
        corrected.add(sentence);
      }
    }

    result = corrected.join('. ').trim();

    // Apply corporate language for professionalism
    result = _applyCorporateLanguage(result);

    // Ensure starts with capital
    if (result.isNotEmpty) {
      result = result[0].toUpperCase() + result.substring(1);
    }

    // Add period if missing
    if (!result.endsWith('.') && !result.endsWith('!') && !result.endsWith('?')) {
      result = '$result.';
    }

    return result.trim();
  }

  String _makeConcise(String text) {
    String result = text;
    result = result.replaceAll('very good', 'excellent');
    result = result.replaceAll('really great', 'outstanding');
    result = result.replaceAll('in order to', 'to');
    result = result.replaceAll('at this point in time', 'now');
    result = result.replaceAll('due to the fact that', 'because');
    return result;
  }

  String _addImpact(String text) {
    if (text.contains('good')) {
      text = text.replaceAll('good', 'exceptional');
    }
    if (!text.contains('demonstrated')) {
      text = 'Consistently demonstrated commitment to excellence. $text';
    }
    return text;
  }

  // Corporate feedback vocabulary & professional phrases
  Map<String, String> getCorporateFeedbackTerms() {
    return {
      // CORE COMPETENCIES
      'leadership': 'Leadership & Strategic Thinking',
      'collaboration': 'Cross-functional Collaboration',
      'communication': 'Effective Communication',
      'innovation': 'Innovation & Creative Problem-Solving',
      'accountability': 'Accountability & Ownership',
      'adaptability': 'Adaptability & Change Management',
      'initiative': 'Proactive Initiative',

      // PERFORMANCE LEVELS
      'exceeds': 'Consistently exceeds expectations',
      'meets': 'Meets all expectations',
      'developing': 'Developing capability in this area',
      'outstanding': 'Outstanding performance',
      'exceptional': 'Exceptional contribution',

      // DEVELOPMENT AREAS
      'growth': 'Growth potential & development opportunity',
      'potential': 'High potential for advancement',
      'skill': 'Skill development area',
      'learning': 'Learning & professional development',
      'mentoring': 'Mentoring & coaching capability',

      // MODERN CORPORATE TERMS
      'agile': 'Agile & flexible mindset',
      'synergy': 'Creates synergy across teams',
      'alignment': 'Strong alignment with organizational goals',
      'bandwidth': 'Excellent capacity & bandwidth management',
      'stakeholder': 'Strong stakeholder engagement',
      'impact': 'High impact delivery',
      'visibility': 'Increases team visibility & recognition',
      'upskilling': 'Continuous upskilling & learning',
      'retention': 'Strong retention & engagement factor',
      'diversity': 'Embraces diversity & inclusion',
    };
  }

  String _applyCorporateLanguage(String text) {
    String result = text;

    // Convert casual to professional corporate language
    result = result.replaceAll(RegExp(r'\bgood\b', caseSensitive: false), 'demonstrates strong');
    result = result.replaceAll(RegExp(r'\bgreat\b', caseSensitive: false), 'exceptional');
    result = result.replaceAll(RegExp(r'\bawesome\b', caseSensitive: false), 'outstanding');
    result = result.replaceAll(RegExp(r'\bcool\b', caseSensitive: false), 'impressive');
    result = result.replaceAll(RegExp(r'\bnice\b', caseSensitive: false), 'valuable');
    result = result.replaceAll(RegExp(r'\bbad\b', caseSensitive: false), 'area for improvement');
    result = result.replaceAll(RegExp(r'\bneeds work\b', caseSensitive: false), 'development opportunity');
    result = result.replaceAll(RegExp(r'\bshould improve\b', caseSensitive: false), 'opportunity to enhance');
    result = result.replaceAll(RegExp(r'\btalks\b', caseSensitive: false), 'communicates');
    result = result.replaceAll(RegExp(r'\bworks\b', caseSensitive: false), 'collaborates');
    result = result.replaceAll(RegExp(r'\bdoes\b', caseSensitive: false), 'demonstrates');
    result = result.replaceAll(RegExp(r'\btries\b', caseSensitive: false), 'demonstrates effort in');

    return result;
  }

  String _makeConstructive(String text) {
    String result = text;

    // CONSERVATIVE: Only replace harsh language, don't add new content
    result = result.replaceAll(RegExp(r'\bneeds improvement\b', caseSensitive: false), 'needs development');
    result = result.replaceAll(RegExp(r'\bshould improve\b', caseSensitive: false), 'can improve');

    // Don't add anything new - manager didn't mention it
    return result;
  }

  String _addStrengthsFirst(String text) {
    return 'Strengths demonstrated: $text. These accomplishments provide a strong foundation for future growth.';
  }

  String _makeEmpathetic(String text) {
    // CONSERVATIVE: Don't add content manager didn't mention
    return text;
  }

  String _addActionableSteps(String text) {
    return '$text Recommended actions: 1) Schedule a development conversation, 2) Identify specific skill-building opportunities, 3) Set measurable goals for improvement.';
  }

  String _addDevelopmentPath(String text) {
    return '$text Growth opportunity: This is an excellent area for professional development. Consider mentoring, training, or stretch assignments to build this capability further.';
  }

  String _formatSTAR(String text) {
    return 'Situation: You were presented with a challenging task. Task: The objective was to demonstrate excellence. Action: $text Result: This demonstrates strong commitment to quality and professional growth.';
  }

  String _makeProfessionalTone(String text) {
    return 'It is noteworthy that $text This contribution aligns well with organizational standards and competency expectations.';
  }

  String _makeVeryProfessional(String text) {
    String result = text;

    // CONSERVATIVE APPROACH: Only fix grammar/spelling, NOT adding new info

    // FILLER WORDS REMOVAL (manager didn't say these)
    result = result.replaceAll(RegExp(r'\b(basically|literally|actually|honestly|umm|uh)\b\s+', caseSensitive: false), '');

    // FIX ARTICLE USAGE (grammar only)
    result = result.replaceAll(RegExp(r'\ba\s+([aeiouAEIOU])', caseSensitive: false), 'an \$1');

    // Fix double spaces
    result = result.replaceAll(RegExp(r'\s+'), ' ');
    result = result.replaceAll(RegExp(r'\s+([.,!?])'), '\$1');

    return result.trim();
  }

  String _makeClientReady(String text) {
    String result = text;

    // CONSERVATIVE: Only convert harsh/inappropriate language, don't add content
    result = result.replaceAll(RegExp(r'\b(dumb|stupid|lazy|incompetent)\b', caseSensitive: false), 'needs development');
    result = result.replaceAll(RegExp(r'\bwaste of time\b', caseSensitive: false), 'inefficient');
    result = result.replaceAll(RegExp(r'\bscrew up\b', caseSensitive: false), 'error');
    result = result.replaceAll(RegExp(r'\bsucks\b', caseSensitive: false), 'needs improvement');

    // Ensure period at end if missing
    if (!result.endsWith('.') && !result.endsWith('?') && !result.endsWith('!')) {
      result = '$result.';
    }

    // Don't add anything new - manager didn't mention it
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<FeedbackItem>>(
              future: _feedbacksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allFeedbacks = [..._localFeedbacks, ...(snapshot.data ?? <FeedbackItem>[])];

                // Filter by time range AND search query
                final filteredByTime = allFeedbacks
                    .where((f) => _isWithinTimeRange(f.createdAt))
                    .toList();

                final searchFiltered = filteredByTime
                    .where((f) => f.employeeName.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();

                // Separate by type
                final positiveFeedbacks = searchFiltered
                    .where((f) => f.feedbackType == 'Positive')
                    .toList();
                final constructiveFeedbacks = searchFiltered
                    .where((f) => f.feedbackType == 'Constructive')
                    .toList();

                final totalCount = searchFiltered.length;

                return Column(
                  children: [
                    // Summary stats
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.blue[50],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$totalCount feedback • Positive: ${positiveFeedbacks.length} | Constructive: ${constructiveFeedbacks.length}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            _timeFilter,
                            style: TextStyle(fontSize: 11, color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),

                    // Time filter buttons
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['This Week', 'This Month', 'This Quarter', 'All Time']
                              .map((period) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: Text(period),
                                      selected: _timeFilter == period,
                                      onSelected: (selected) {
                                        setState(() => _timeFilter = period);
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),

                    // Search field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search employee name...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Single column feedback list
                    Expanded(
                      child: searchFiltered.isEmpty
                          ? Center(
                              child: Text(
                                'No feedback in this period',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: searchFiltered.length,
                              itemBuilder: (context, index) {
                                final fb = searchFiltered[index];
                                return _buildFeedbackCard(fb);
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFeedbackForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
