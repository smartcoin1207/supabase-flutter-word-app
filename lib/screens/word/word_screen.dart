import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_word_app/providers/user_provider.dart';
import 'package:supabase_word_app/providers/word_provider.dart';

@RoutePage()
class WordListScreen extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(wordProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Word List")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  final isUserWord = word.user_id == user!.id;

                  return ListTile(
                    title: Text(word.word),
                    trailing: isUserWord
                        ? IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ref
                                  .read(wordProvider.notifier)
                                  .deleteWord(word.word);
                            },
                          )
                        : null,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "New Word",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.read(wordProvider.notifier).addWord(_controller.text);
                    _controller.clear();
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
