import 'package:ai_chat/services/claude_api_service.dart';
import 'package:ai_chat/models/message.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final List<Message> _messages = [];
  bool _isLoading = false;
  String _apiKey = '';

  List<Message> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String get apiKey => _apiKey;

  void setApiKey(String key) {
    _apiKey = key;
    notifyListeners();
  }

  Future<void> sendMessage(String prompt) async {
    final trimmedPrompt = prompt.trim();
    if (trimmedPrompt.isEmpty) return;

    final userMessage = Message(
      content: trimmedPrompt,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      final apiService = ClaudeApiService(apiKey: _apiKey);
      final responseText = await apiService.sendMessage(trimmedPrompt);
      final responseMessage = Message(
        content: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(responseMessage);
    } catch (e) {
      final errorMessage = Message(
        content: 'Error: ${e.toString().replaceAll('Exception: ', '')}',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}
