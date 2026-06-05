import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import '../models/feedback.dart';
import '../models/goal.dart';
import '../models/review.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  // Get current organization (use first company for now)
  Future<String> getCurrentOrgId() async {
    final orgs = await client
        .from('organisations')
        .select('id')
        .limit(1);

    return orgs[0]['id'];
  }

  // Get employees
  Future<List<Employee>> getEmployees() async {
    final orgId = await getCurrentOrgId();

    final data = await client
        .from('employees')
        .select()
        .eq('organisation_id', orgId);

    return data.map((e) => Employee(
      id: e['id'],
      name: e['name'],
      department: e['department'],
      region: e['region'],
    )).toList();
  }

  // Get feedbacks
  Future<List<FeedbackItem>> getFeedbacks() async {
    final orgId = await getCurrentOrgId();

    final data = await client
        .from('feedbacks')
        .select()
        .eq('organisation_id', orgId);

    return data.map((e) => FeedbackItem(
      id: e['id'],
      employeeName: e['employee_name'],
      feedbackType: e['feedback_type'],
      comment: e['comment'],
    )).toList();
  }

  // Get goals
  Future<List<Goal>> getGoals() async {
    final orgId = await getCurrentOrgId();

    final data = await client
        .from('goals')
        .select()
        .eq('organisation_id', orgId);

    return data.map((e) => Goal(
      id: e['id'],
      name: e['name'],
      progress: (e['progress'] as num).toDouble(),
    )).toList();
  }

  // Get reviews
  Future<List<Review>> getReviews() async {
    final orgId = await getCurrentOrgId();

    final data = await client
        .from('reviews')
        .select()
        .eq('organisation_id', orgId);

    return data.map((e) => Review(
      id: e['id'],
      employeeName: e['employee_name'],
      cycle: e['cycle'],
      rating: double.parse(e['rating'].toString()),
    )).toList();
  }

  // Get heatmap data
  Future<List<Map>> getHeatmapData() async {
    final orgId = await getCurrentOrgId();

    return await client
        .from('heatmap_cells')
        .select()
        .eq('organisation_id', orgId);
  }

  // Logout
  Future<void> logout() async {
    await client.auth.signOut();
  }
}
