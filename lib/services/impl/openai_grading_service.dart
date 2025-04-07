import 'package:tutor_bot/services/ai_service.dart';
import 'package:tutor_bot/services/grade_service.dart';
import 'package:tutor_bot/services/impl/openai_thread_service.dart';
import 'package:tutor_bot/services/thread_service.dart';

class OpenAIGradingService extends AiGradingService {

  OpenAIGradingService({
    required AiService aiService,
    required String subject,
    required String language,
    required ThreadService? parent,
  }) : super(aiService: aiService, subject: subject, language: language, parent: parent);

  @override
  ThreadService createThread() {
    return OpenAIThreadService(aiService: aiService, parent: this);
  }
}