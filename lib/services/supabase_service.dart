import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_word_app/constants/constants.dart';

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: googleClientId, // Make sure this is set correctly
  );

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

  // Google Sign-In logic in SupabaseService
  Future<void> googleSignInFunction() async {
    await GoogleSignIn().signOut();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // If the user cancels the sign-in
        return;
      }

      // Authenticate with Supabase using Google ID Token
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final response = await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
        );

        if (response.user == null) {
          throw Exception('Sign-In failed!');
        }
      }
    } catch (error) {
      throw Exception('Error during Google sign-in: $error');
    }
  }
}
