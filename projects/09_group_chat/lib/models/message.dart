class Message {
  final int id;
  final String userId;
  final String username;
  final String content;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    required this.createdAt,
  });

  // Supabase returns each row as a Map, with column names as keys.
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      userId: map['user_id'],
      username: map['username'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']).toLocal(),
    );
  }
}
