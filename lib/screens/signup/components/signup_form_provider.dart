import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../home_screen.dart';

class SignUpFormProvider extends StatelessWidget {
  const SignUpFormProvider({super.key});

  Future<void> _signInWithProvider(
      BuildContext context, OAuthProvider provider) async {
    try {
      final bool res =
          await Supabase.instance.client.auth.signInWithOAuth(provider);

      if (res) {
        // User signed in successfully
        Navigator.pushReplacementNamed(
            context, '/home'); // Redirect to home screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: User not found')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $error')),
      );
    }
  }

  Future<void> _googleSignIn(BuildContext context) async {
    const webClientId =
        '615079494788-4a3g13pp9vh6h3nkvncjurups7irph3r.apps.googleusercontent.com';

    // Initialize Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: webClientId,
    );

    // Sign in with Google
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final idToken = googleAuth.idToken;

    // Check if idToken exists
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    try {
      // Sign in to Supabase using the ID token
      final authResponse =
          await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      // If sign-in is successful, navigate to Home screen
      if (authResponse.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Handle error if user is null
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed. Please try again.')),
        );
      }
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
      children: [
        // Google Button
        GestureDetector(
          onTap: () => _googleSignIn(context),
          child: CircleAvatar(
            radius: 20, // Adjust the size of the button
            backgroundColor: Colors.white,
            child: FaIcon(
              FontAwesomeIcons.google, // Google icon from FontAwesome
              color: Colors.red, // Google’s red color
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 20), // Space between the buttons

        // Facebook Button
        GestureDetector(
          onTap: () => _signInWithProvider(context, OAuthProvider.facebook),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: FaIcon(
              FontAwesomeIcons.facebook, // Facebook icon from FontAwesome
              color: Colors.blue, // Facebook’s blue color
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 20), // Space between the buttons

        // Apple Button
        GestureDetector(
          onTap: () => _signInWithProvider(context, OAuthProvider.apple),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: FaIcon(
              FontAwesomeIcons.apple, // Apple icon from FontAwesome
              color: Colors.black, // Apple’s black color
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
