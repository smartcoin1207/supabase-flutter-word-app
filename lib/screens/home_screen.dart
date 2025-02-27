import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_word_app/app_router.dart';
import '../providers/user_provider.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider); // Get user data from provider

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(userProvider.notifier).logout();
              context.router.replace(const LoginRoute());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Name: ${user?.name}"),
            Text("Email: ${user?.email}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {context.router.replace(const WordListRoute())},
              child: Text("Word".toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
