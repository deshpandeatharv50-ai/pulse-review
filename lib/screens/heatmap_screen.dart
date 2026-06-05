import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({Key? key}) : super(key: key);

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  final _supabaseService = SupabaseService();
  late Future<List<Map>> _heatmapFuture;

  @override
  void initState() {
    super.initState();
    _heatmapFuture = _supabaseService.getHeatmapData();
  }

  Color _getHeatColor(double score) {
    if (score >= 4.5) return const Color(0xFF2E7D32); // Dark green
    if (score >= 4.0) return const Color(0xFF66BB6A); // Green
    if (score >= 3.5) return const Color(0xFFFFB74D); // Orange
    if (score >= 3.0) return const Color(0xFFEF5350); // Red
    return const Color(0xFFC62828); // Dark red
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Heatmap')),
      body: FutureBuilder<List<Map>>(
        future: _heatmapFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final heatmapData = snapshot.data ?? [];

          // Group by department
          final departments = <String, List<Map>>{};
          for (final item in heatmapData) {
            final dept = item['department'] as String;
            if (!departments.containsKey(dept)) {
              departments[dept] = [];
            }
            departments[dept]!.add(item);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Legend
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Score Legend',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...[
                        ('4.5+', _getHeatColor(4.5)),
                        ('4.0-4.5', _getHeatColor(4.2)),
                        ('3.5-4.0', _getHeatColor(3.7)),
                        ('3.0-3.5', _getHeatColor(3.2)),
                        ('< 3.0', _getHeatColor(2.5)),
                      ]
                          .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: e.$2,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(e.$1),
                              ],
                            ),
                          ))
                          .toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Heatmap by department
              ...departments.entries.map((entry) {
                final department = entry.key;
                final cells = entry.value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(department,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: cells.map((cell) {
                            final region = cell['region'] as String;
                            final score =
                                (cell['score'] as num).toDouble();

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _getHeatColor(score),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    region,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    score.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
