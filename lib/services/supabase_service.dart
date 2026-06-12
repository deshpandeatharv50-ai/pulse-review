import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import '../models/feedback.dart';
import '../models/goal.dart';
import '../models/review.dart';
import '../supabase_config.dart';

class SupabaseService {
  get client => SupabaseConfig.supabase;

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
        id: e['id'].toString(),
        employeeName: e['employee_name'],
        feedbackType: e['feedback_type'],
        comment: e['comment'],
        createdAt: e['created_at'] != null
            ? DateTime.tryParse(e['created_at'].toString())
            : null,
        rating: e['rating'] == null
            ? null
            : double.tryParse(e['rating'].toString()),
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

  // Submit feedback to Supabase. Returns the inserted row id on success,
  // null on failure (caller falls back to local-only storage).
  // `rating` is a half-star value (0.5–5.0 in 0.5 steps).
  Future<String?> submitFeedback(
    String employeeName,
    String feedbackType,
    String comment, {
    double? rating,
    DateTime? createdAt,
  }) async {
    final snapped = rating == null
        ? null
        : ((rating * 2).round() / 2.0).clamp(0.5, 5.0);
    try {
      final inserted = await client.from('feedbacks').insert({
        'employee_name': employeeName,
        'feedback_type': feedbackType,
        'comment': comment,
        if (snapped != null) 'rating': snapped,
        if (createdAt != null) 'created_at': createdAt.toIso8601String(),
      }).select().single();
      print('✅ Feedback saved to Supabase (id=${inserted['id']})');
      return inserted['id'].toString();
    } catch (e) {
      print('⚠️ Supabase submit failed: $e');
      return null;
    }
  }

  // Update an existing Supabase feedback row.
  Future<bool> updateFeedback(
    String id, {
    String? employeeName,
    String? feedbackType,
    String? comment,
    double? rating,
    DateTime? createdAt,
  }) async {
    final snapped = rating == null
        ? null
        : ((rating * 2).round() / 2.0).clamp(0.5, 5.0);
    try {
      await client.from('feedbacks').update({
        if (employeeName != null) 'employee_name': employeeName,
        if (feedbackType != null) 'feedback_type': feedbackType,
        if (comment != null) 'comment': comment,
        if (snapped != null) 'rating': snapped,
        if (createdAt != null) 'created_at': createdAt.toIso8601String(),
      }).eq('id', id);
      print('✅ Feedback updated in Supabase (id=$id)');
      return true;
    } catch (e) {
      print('⚠️ Supabase update failed: $e');
      return false;
    }
  }

  // Delete a Supabase feedback row.
  Future<bool> deleteFeedback(String id) async {
    try {
      await client.from('feedbacks').delete().eq('id', id);
      print('✅ Feedback deleted from Supabase (id=$id)');
      return true;
    } catch (e) {
      print('⚠️ Supabase delete failed: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await client.auth.signOut();
  }
}
