import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_word_app/app_router.dart';
import '../../../constants/constants.dart';

class LoginFormOauth extends StatefulWidget {
  const LoginFormOauth({super.key});

  @override
  State<LoginFormOauth> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginFormOauth> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: googleClientId,
  );

  Future<void> _googleSignInFunction() async {
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
        final response = await Supabase.instance.client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
        );

        if (response.user != null) {
          // Successfully signed in
          context.router.replace(const WordListRoute());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-In failed!')),
          );
        }
      }
    } catch (error) {
      print('Error during Google sign-in: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
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
          onTap: () => _googleSignInFunction(),
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
