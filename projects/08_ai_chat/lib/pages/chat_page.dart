import 'package:ai_chat/components/chat_bubble.dart';
import 'package:ai_chat/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().addListener(_scrollToBottom);
    });
  }

  @override
  void dispose() {
    context.read<ChatProvider>().removeListener(_scrollToBottom);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showApiKeyDialog() {
    final provider = context.read<ChatProvider>();
    final keyController = TextEditingController(text: provider.apiKey);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Key Configuration'),
        content: TextField(
          controller: keyController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Enter Anthropic API Key (sk-ant-...)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.setApiKey(keyController.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Assistant'),
        actions: [
          IconButton(
            icon: const Icon(HugeIcons.strokeRoundedKey01),
            tooltip: 'Set API Key',
            onPressed: _showApiKeyDialog,
          ),
          IconButton(
            icon: const Icon(HugeIcons.strokeRoundedDelete02),
            tooltip: 'Clear Chat',
            onPressed: () => context.read<ChatProvider>().clearChat(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _messageList()),
            _loadingIndicator(),
            _inputRow(),
          ],
        ),
      ),
    );
  }

  Widget _messageList() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'Start a conversation!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: chatProvider.messages.length,
          itemBuilder: (context, index) {
            final message = chatProvider.messages[index];
            return ChatBubble(message: message);
          },
        );
      },
    );
  }

  Widget _loadingIndicator() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.isLoading) {
          return const LinearProgressIndicator();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _inputRow() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            icon: const Icon(HugeIcons.strokeRoundedSent),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text;
    if (text.trim().isNotEmpty) {
      context.read<ChatProvider>().sendMessage(text);
      _controller.clear();
      _scrollToBottom();
    }
  }
}
