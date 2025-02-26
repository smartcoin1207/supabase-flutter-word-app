import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jhhogeuvvtrwegcdijut.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpoaG9nZXV2dnRyd2VnY2RpanV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA1Njk4OTAsImV4cCI6MjA1NjE0NTg5MH0.L0_E2EVfYU45xBAexNOJyr8ifJ7tyMT2x_AenlI7rCc',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SupabaseService supabaseService = SupabaseService();
  late Stream<AuthState> authStateStream;

  @override
  void initState() {
    super.initState();
    authStateStream = supabaseService.onAuthStateChange();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: authStateStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }

        final session = Supabase.instance.client.auth.currentSession;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: session != null ? HomeScreen() : LoginScreen(),
        );
      },
    );
  }
}
