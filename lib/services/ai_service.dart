import 'package:tutor_bot/models/chat_message.dart';

/// An abstract class for interacting with an AI model
abstract class AiService {
  /// Ask a question of the AI model
  Future<String> askQuestion({
    required String userMessage,
    required List<ChatMessage> history,
  });

  /// Ask a question of the AI model with an image
  Future<String> askImageQuestion({
    required String imageUrl,
    required String prompt,
    required List<ChatMessage> history,
  });
}
