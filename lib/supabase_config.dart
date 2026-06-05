import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Configuration for ELEVATE multi-org backend
class SupabaseConfig {
  // ✅ ELEVATE Supabase Project Credentials (Pratham's backend)
  static const String supabaseUrl = 'https://kylxkksvxkkwvdhatwuc.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5bHhra3N2eGtrd3ZkaGF0d3VjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA2Mzk5MzAsImV4cCI6MjA5NjIxNTkzMH0.p-LYMxX1IVMqaKLUJ2STVSYlLpnQROsIt8K5VsnijAI';

  static late SupabaseClient supabase;

  /// Initialize Supabase connection
  static Future<void> init() async {
    supabase = await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  /// Get current user session
  static Session? get session => supabase.auth.currentSession;
  static User? get user => supabase.auth.currentUser;

  /// Fetch all organizations
  static Future<List<Map<String, dynamic>>> getOrganisations() async {
    final response = await supabase
        .from('organisations')
        .select()
        .order('name');
    return response ?? [];
  }

  /// Fetch organisation by ID
  static Future<Map<String, dynamic>?> getOrganisation(String orgId) async {
    final response = await supabase
        .from('organisations')
        .select()
        .eq('id', orgId)
        .single();
    return response;
  }

  /// Fetch employees for organisation
  static Future<List<Map<String, dynamic>>> getEmployees(String orgId) async {
    final response = await supabase
        .from('employees')
        .select()
        .eq('organisation_id', orgId);
    return response ?? [];
  }

  /// Fetch feedbacks for organisation
  static Future<List<Map<String, dynamic>>> getFeedbacks(String orgId) async {
    final response = await supabase
        .from('feedbacks')
        .select()
        .eq('organisation_id', orgId);
    return response ?? [];
  }

  /// Fetch goals for organisation
  static Future<List<Map<String, dynamic>>> getGoals(String orgId) async {
    final response = await supabase
        .from('goals')
        .select()
        .eq('organisation_id', orgId);
    return response ?? [];
  }

  /// Fetch reviews for organisation
  static Future<List<Map<String, dynamic>>> getReviews(String orgId) async {
    final response = await supabase
        .from('reviews')
        .select()
        .eq('organisation_id', orgId);
    return response ?? [];
  }

  /// Fetch heatmap data for organisation
  static Future<List<Map<String, dynamic>>> getHeatmapData(String orgId) async {
    final response = await supabase
        .from('heatmap_cells')
        .select()
        .eq('organisation_id', orgId);
    return response ?? [];
  }

  /// Add new feedback
  static Future<void> addFeedback(String orgId, Map<String, dynamic> feedback) async {
    await supabase.from('feedbacks').insert({
      'organisation_id': orgId,
      ...feedback,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Add new goal
  static Future<void> addGoal(String orgId, Map<String, dynamic> goal) async {
    await supabase.from('goals').insert({
      'organisation_id': orgId,
      ...goal,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Add new review
  static Future<void> addReview(String orgId, Map<String, dynamic> review) async {
    await supabase.from('reviews').insert({
      'organisation_id': orgId,
      ...review,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
