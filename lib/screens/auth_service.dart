import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Access global initialized Supabase client
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Sign In via Email & Password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (error) {
      throw error.message;
    } catch (error) {
      throw 'An unexpected error occurred during sign-in.';
    }
  }

  // 2. Sign Up via Email & Password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: metadata, // Pass custom operational metrics into User Metadata
      );
      return response;
    } on AuthException catch (error) {
      throw error.message;
    } catch (error) {
      throw 'An unexpected error occurred during registration.';
    }
  }

  // 3. Current Active Auth Session State Check
  User? get currentUser => _supabase.auth.currentUser;
}
