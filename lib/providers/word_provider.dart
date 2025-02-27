import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_word_app/models/word_model.dart';
import 'package:supabase_word_app/providers/user_provider.dart';

final supabase = Supabase.instance.client;

class WordNotifier extends StateNotifier<List<WordModel>> {
  WordNotifier(this.ref) : super([]) {
    fetchWordsAll();
    _subscribeToWords(); // Start the real-time subscription
  }

  final Ref ref;

  // Fetch all words for all users (not filtered by user_id)
  Future<void> fetchWordsAll() async {
    final response =
        await supabase.from('words').select(); // Fetch words for all users

    // Map the Supabase response to a list of WordModel
    state = response.map<WordModel>((word) {
      return WordModel(
        id: word['id'] as int,
        word: word['word'] as String,
        user_id: word['user_id'] as String,
      );
    }).toList();
  }

  // Real-time subscription for insert, update, and delete events
  void _subscribeToWords() {
    supabase
        .channel('public:words')
        .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'words',
            callback: (payload) {
              final newWord = WordModel(
                id: payload.newRecord['id'] as int,
                word: payload.newRecord['word'] as String,
                user_id: payload.newRecord['user_id'] as String,
              );
              state = [...state, newWord]; // Add the new word to the state
            })
        .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'words',
            callback: (payload) {
              final updatedWord = WordModel(
                id: payload.newRecord['id'] as int,
                word: payload.newRecord['word'] as String,
                user_id: payload.newRecord['user_id'] as String,
              );
              state = state
                  .map((word) => word.id == updatedWord.id ? updatedWord : word)
                  .toList(); // Update the word
            })
        .onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: 'words',
            callback: (payload) {
              state = state
                  .where((word) => word.id != payload.oldRecord['id'] as String)
                  .toList(); // Remove deleted word
            })
        .subscribe(); // Begin subscription to real-time changes
  }

  // Add new word (user's ID will be saved with the word)
  Future<void> addWord(String newWord) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    newWord = newWord.trim();
    if (newWord.isEmpty) return;

    final response = await supabase
        .from('words')
        .insert({
          'word': newWord,
          'user_id': user.id, // Store the user's ID with the word
        })
        .select()
        .single();

    // Add the new word to the state
    state = [
      ...state,
      WordModel(
        id: response['id'] as int,
        word: response['word'] as String,
        user_id: response['user_id'] as String,
      )
    ];
  }

  // Delete word only for the authenticated user
  Future<void> deleteWord(String word) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    await supabase
        .from('words')
        .delete()
        .eq('word', word)
        .eq('user_id', user.id); // Ensure only user's words are deleted

    fetchWordsAll(); // Refresh list after deletion
  }
}

// Riverpod Provider for WordNotifier
final wordProvider =
    StateNotifierProvider<WordNotifier, List<WordModel>>((ref) {
  return WordNotifier(ref);
});
