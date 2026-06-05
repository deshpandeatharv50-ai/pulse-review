import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import '../models/feedback.dart';
import '../models/goal.dart';
import '../models/review.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  // Get current organization (use first company for now)
  Future<String> getCurrentOrgId() async {
    try {
      final orgs = await client
          .from('organisations')
          .select('id')
          .limit(1)
          .timeout(const Duration(seconds: 5));

      if (orgs.isNotEmpty && orgs[0]['id'] != null) {
        print('✅ Got org ID: ${orgs[0]['id']}');
        return orgs[0]['id'].toString();
      }
      print('⚠️ No organisations found');
    } on TimeoutException catch (_) {
      print('⚠️ Supabase query timeout - using fallback');
    } catch (e) {
      print('⚠️ Error getting org ID: $e');
    }

    // Fallback - return empty string to allow app to load
    // Data queries will handle empty org ID gracefully
    return '';
  }

  // Get employees
  Future<List<Employee>> getEmployees() async {
    final orgId = await getCurrentOrgId();
    if (orgId.isEmpty) return [];

    try {
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
    } catch (e) {
      print('Error getting employees: $e');
      return [];
    }
  }

  // Get feedbacks
  Future<List<FeedbackItem>> getFeedbacks() async {
    final orgId = await getCurrentOrgId();
    if (orgId.isEmpty) return [];

    try {
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
    } catch (e) {
      print('Error getting feedbacks: $e');
      return [];
    }
  }

  // Get goals
  Future<List<Goal>> getGoals() async {
    final orgId = await getCurrentOrgId();
    if (orgId.isEmpty) return [];

    try {
      final data = await client
          .from('goals')
          .select()
          .eq('organisation_id', orgId);

      return data.map((e) => Goal(
        id: e['id'],
        name: e['name'],
        progress: (e['progress'] as num).toDouble(),
      )).toList();
    } catch (e) {
      print('Error getting goals: $e');
      return [];
    }
  }

  // Get reviews
  Future<List<Review>> getReviews() async {
    final orgId = await getCurrentOrgId();
    if (orgId.isEmpty) return [];

    try {
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
    } catch (e) {
      print('Error getting reviews: $e');
      return [];
    }
  }

  // Get heatmap data
  Future<List<Map>> getHeatmapData() async {
    final orgId = await getCurrentOrgId();
    if (orgId.isEmpty) return [];

    try {
      return await client
          .from('heatmap_cells')
          .select()
          .eq('organisation_id', orgId);
    } catch (e) {
      print('Error getting heatmap data: $e');
      return [];
    }
  }

  // Submit feedback
  Future<void> submitFeedback(String employeeName, String feedbackType, String comment) async {
    final orgId = await getCurrentOrgId();

    await client.from('feedbacks').insert({
      'organisation_id': orgId,
      'employee_name': employeeName,
      'feedback_type': feedbackType,
      'comment': comment,
    });
  }

  // Logout
  Future<void> logout() async {
    await client.auth.signOut();
  }
}
