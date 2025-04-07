import 'package:tutor_bot/models/chat_message.dart';
import 'package:tutor_bot/services/ai_service.dart';

abstract class ThreadService {
  ThreadService({required this.aiService, this.parent});

  final ThreadService? parent;

  final AiService aiService;

  final List<ChatMessage> _history = [];
  
  final int limit = 5;

  List<ChatMessage> history() {
    return _history;
  }

  Future<String> chat({
    required String userMessage,
  }) async {
    String response = await aiService.askQuestion(userMessage: userMessage, history: _history);
    addMessage(ChatMessage(role: 'user', content: userMessage));
    addMessage(ChatMessage(role: 'assistant', content: response));
    return response;
  }

  ThreadService createThread();

  Future<void> addMessage(ChatMessage message) async {
    _history.add(message);
  }

  List<ChatMessage> getLastMessages(List<ChatMessage> history) {
    if (history.length <= limit) return history;

    return history.sublist(history.length - limit);
  }
}
