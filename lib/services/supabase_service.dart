import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // ১. নতুন ডিজাইন তৈরি হলে ট্র্যাক করা
  Future<void> trackNewDesign({
    required String title,
    required String createdBy, // ইউজারের নাম
    required String status, // 'Completed' বা 'In Review'
  }) async {
    await _supabase.from('dress_designs').insert({
      'title': title,
      'created_by': createdBy,
      'status': status,
    });
  }

  // ২. ইমেজ বা পিডিএফ এক্সপোর্ট করলে ট্র্যাক করা
  Future<void> trackExport({
    required String userId,
    required String designId,
    required String exportType, // 'PNG' অথবা 'PDF'
  }) async {
    await _supabase.from('exports').insert({
      'user_id': userId,
      'design_id': designId,
      'export_type': exportType,
    });
  }

  // ৩. কোনো ক্লায়েন্ট পেমেন্ট করলে রেভিনিউ যোগ করা
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
