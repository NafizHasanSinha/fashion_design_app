import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // 1. Track when a new design is created
  Future<void> trackNewDesign({
    required String title,
    required String createdBy, // User's name
    required String status, // 'Completed' or 'In Review'
  }) async {
    await _supabase.from('dress_designs').insert({
      'title': title,
      'created_by': createdBy,
      'status': status,
    });
  }

  // 2. Track image or PDF exports
  Future<void> trackExport({
    required String userId,
    required String designId,
    required String exportType, // 'PNG' or 'PDF'
  }) async {
    await _supabase.from('exports').insert({
      'user_id': userId,
      'design_id': designId,
      'export_type': exportType,
    });
  }

  // 3. Add revenue when a client makes a payment
  Future<void> trackRevenue({
    required String clientId,
    required double amount,
  }) async {
    await _supabase.from('revenue').insert({
      'client_id': clientId,
      'amount': amount,
    });
  }
}
