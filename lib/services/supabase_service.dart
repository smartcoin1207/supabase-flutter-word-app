import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Check if user is logged in
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  // Listen to auth state changes
  Stream<AuthState> onAuthStateChange() {
    return supabase.auth.onAuthStateChange;
  }

  Future<void> login(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await supabase.auth.signOut();
  }
}
