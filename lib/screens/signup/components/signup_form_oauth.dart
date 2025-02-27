import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_word_app/app_router.dart';
import '../../../constants/constants.dart';

class SignUpFormOauth extends StatelessWidget {
  const SignUpFormOauth({super.key});

  Future<void> _googleSignIn(BuildContext context) async {
    final webClientId = googleClientId;

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
        context.router.replace(const HomeRoute());
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
          onTap: () => {},
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
          onTap: () => {},
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
