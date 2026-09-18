import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message.dart';

class ChatService {
  final _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  /// Returns true if the user is signed in right away, or false if Supabase
  /// first wants them to confirm their email address.
  Future<bool> signUp(String email, String password, String username) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      // Saved on the user; the database copies it into each message they send.
      data: {'username': username},
    );
    return response.session != null;
  }

  Future<void> signOut() => _supabase.auth.signOut();

  /// The latest 100 messages, newest first. Supabase pushes a fresh list
  /// every time someone sends a message, so the UI updates on its own.
  Stream<List<Message>> messagesStream() {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(100)
        .map((rows) => rows.map(Message.fromMap).toList());
  }

  /// Only the text is sent: the database fills in user_id and username
  /// from whoever is signed in (see supabase/schema.sql).
  Future<void> sendMessage(String content) async {
    await _supabase.from('messages').insert({'content': content});
  }
}
