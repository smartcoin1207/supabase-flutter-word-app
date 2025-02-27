import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_word_app/app_router.dart';
import 'package:supabase_word_app/services/supabase_service.dart';

class SignInOauth extends StatefulWidget {
  const SignInOauth({super.key});

  @override
  State<SignInOauth> createState() => _SignInOauthState();
}

class _SignInOauthState extends State<SignInOauth> {
  final SupabaseService supabaseService = SupabaseService();

  Future<void> _googleSignInFunction(BuildContext context) async {
    try {
      await supabaseService.googleSignInFunction();
      context.router.replace(const WordListRoute());
    } catch (error) {
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
          onTap: () => _googleSignInFunction(context),
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
