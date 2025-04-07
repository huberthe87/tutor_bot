import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_bot/models/chat_message.dart';
import 'package:tutor_bot/services/ai_service.dart';

class OpenAIService implements AiService {
  final String apiKey;

  OpenAIService({required this.apiKey});

  /// Ask a question of the AI model
  @override
  Future<String> askQuestion(
      {required String userMessage, required List<ChatMessage> history}) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful assistant that can answer questions and help with tasks.'
            },
            ...history.map((message) => message.toJson()).toList(),
            {
              'role': 'user',
              'content': [
                {'type': 'text', 'text': userMessage}
              ]
            }
          ],
          'max_tokens': 2048,
          'temperature': 0.3
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'API request failed with status code: ${response.statusCode}');
      }

      final decodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedBody);
      final content = data['choices'][0]['message']['content'];

      if (content == null || content.isEmpty) {
        return 'No response generated';
      }

      return content;
    } catch (e) {
      debugPrint('Exception: $e');
      throw Exception('Failed to ask question: $e');
    }
  }

  /// Ask a question of the AI model with an image
  @override
  Future<String> askImageQuestion(
      {required String imageUrl,
      required String prompt,
      required List<ChatMessage> history}) async {
    debugPrint(
        'askImageQuestion: $imageUrl, $prompt, ${history.map((message) => message.toJson()).toList()}');
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-4-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful assistant that can answer questions and help with tasks.'
            },
            ...history.map((message) => message.toJson()).toList(),
            {
              'role': 'user',
              'content': [
                {
                  'type': 'image_url',
                  'image_url': {'url': imageUrl}
                },
                {'type': 'text', 'text': prompt}
              ]
            }
          ],
          'max_tokens': 2048,
          'temperature': 0.3
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'API request failed with status code: ${response.statusCode}');
      }

      final decodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedBody);
      final content = data['choices'][0]['message']['content'];

      if (content == null || content.isEmpty) {
        return 'No response generated';
      }
      debugPrint('askImageQuestion content: $content');
      return content;
    } catch (e) {
      debugPrint('Exception: $e');
      throw Exception('Failed to ask image question: $e');
    }
  }
}
