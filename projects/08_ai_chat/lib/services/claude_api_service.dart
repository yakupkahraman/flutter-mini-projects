import 'dart:convert';
import 'package:http/http.dart' as http;

class ClaudeApiService {
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _apiVersion = '2023-06-01';
  static const String _model = 'claude-3-5-sonnet-20241022';
  static const int _maxTokens = 1024;

  final String apiKey;

  ClaudeApiService({required this.apiKey});

  Future<String> sendMessage(String prompt) async {
    if (apiKey.trim().isEmpty) {
      throw Exception(
        'API Key is missing. Please provide a valid Anthropic API key in ChatProvider.',
      );
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'anthropic-version': _apiVersion,
          'content-type': 'application/json',
          'x-api-key': apiKey,
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': _maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final responseBody = jsonDecode(decodedBody) as Map<String, dynamic>;
        final content = responseBody['content'] as List<dynamic>;
        return content[0]['text'] as String;
      } else {
        throw Exception(
          'Failed to get response from Claude API (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('API error: $e');
    }
  }
}
