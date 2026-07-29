class Message {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  const Message({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}
