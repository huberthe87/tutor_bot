import 'package:tutor_bot/models/chat_message.dart';
import 'package:tutor_bot/services/thread_service.dart';

class OpenAIThreadService extends ThreadService {
  
  OpenAIThreadService({required aiService, parent}) : super(aiService: aiService, parent: parent);
  
  @override
  Future<String> chat({required String userMessage}) async {
    final response = await aiService.askQuestion(
      userMessage: userMessage,
      history: history(),
    );
    addMessage(ChatMessage(role: 'user', content: userMessage));
    addMessage(ChatMessage(role: 'assistant', content: response));
    return response;
  }
  
  @override
  ThreadService createThread() {
    return OpenAIThreadService(aiService: aiService, parent: this);
  }
}