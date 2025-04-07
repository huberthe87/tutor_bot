import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_bot/models/chat_message.dart';
import 'package:tutor_bot/models/subject_question.dart';
import 'package:tutor_bot/services/ai_service.dart';
import 'package:tutor_bot/services/grade_service.dart';
import 'package:tutor_bot/services/thread_service.dart';

// Mock implementation of AiService for testing
class MockAiService implements AiService {
  final String response;
  
  MockAiService({required this.response});
  
  @override
  Future<String> askImageQuestion({
    required String imageUrl,
    required List<ChatMessage> history,
    required String prompt,
  }) async {
    return response;
  }
  
  @override
  Future<String> chat({
    required List<ChatMessage> history,
    required String userMessage,
  }) async {
    return response;
  }
  
  @override
  Future<String> askQuestion({
    required List<ChatMessage> history,
    required String userMessage,
  }) async {
    return response;
  }
}

// Mock implementation of ThreadService for testing
class MockThreadService implements ThreadService {
  final List<ChatMessage> _history = [];
  final AiService _aiService = MockAiService(response: '');
  final ThreadService? _parent = null;
  final int _limit = 10;
  
  @override
  List<ChatMessage> history() {
    return _history;
  }
  
  @override
  Future<void> addMessage(ChatMessage message) async {
    _history.add(message);
  }
  
  @override
  ThreadService createThread() {
    return this;
  }
  
  @override
  Future<String> chat({required String userMessage}) async {
    return '';
  }
  
  @override
  List<ChatMessage> getLastMessages(List<ChatMessage> messages) {
    return _history;
  }
  
  @override
  AiService get aiService => _aiService;
  
  @override
  int get limit => _limit;
  
  @override
  ThreadService? get parent => _parent;
}

void main() {
  group('AiGradingService', () {
    test('gradeImage with JSON object response', () async {
      const jsonResponse = '''
      {
        "questions": [
          {
            "question_number": "1",
            "expression": "2 + 2",
            "student_answer": "4",
            "steps": ["Step 1: Add 2 and 2", "Step 2: Result is 4"],
            "correct": true,
            "feedback": "Correct answer!"
          }
        ]
      }
      ''';
      
      final mockAiService = MockAiService(response: jsonResponse);
      final mockThreadService = MockThreadService();
      
      final service = TestAiGradingService(
        aiService: mockAiService,
        subject: 'math',
        language: 'english',
        parent: mockThreadService,
      );
      
      final result = await service.gradeImage(imageUrl: 'https://example.com/image.jpg');
      
      expect(result.questions.length, 1);
      expect(result.questions[0], isA<MathQuestion>());
      
      final question = result.questions[0] as MathQuestion;
      expect(question.questionNumber, '1');
      expect(question.expression, '2 + 2');
      expect(question.studentAnswer, '4');
      expect(question.steps.length, 2);
      expect(question.correct, true);
      expect(question.feedback, 'Correct answer!');
    });
    
    test('gradeImage with JSON array response', () async {
      const jsonResponse = '''
      [
        {
          "question_number": "1",
          "expression": "2 + 2",
          "student_answer": "4",
          "steps": ["Step 1: Add 2 and 2", "Step 2: Result is 4"],
          "correct": true,
          "feedback": "Correct answer!"
        }
      ]
      ''';
      
      final mockAiService = MockAiService(response: jsonResponse);
      final mockThreadService = MockThreadService();
      
      final service = TestAiGradingService(
        aiService: mockAiService,
        subject: 'math',
        language: 'english',
        parent: mockThreadService,
      );
      
      final result = await service.gradeImage(imageUrl: 'https://example.com/image.jpg');
      
      expect(result.questions.length, 1);
      expect(result.questions[0], isA<MathQuestion>());
      
      final question = result.questions[0] as MathQuestion;
      expect(question.questionNumber, '1');
      expect(question.expression, '2 + 2');
      expect(question.studentAnswer, '4');
      expect(question.steps.length, 2);
      expect(question.correct, true);
      expect(question.feedback, 'Correct answer!');
    });
    
    test('gradeImage with JSON in code block', () async {
      const jsonResponse = '''
      ```json
      {
        "questions": [
          {
            "question_number": "1",
            "expression": "2 + 2",
            "student_answer": "4",
            "steps": ["Step 1: Add 2 and 2", "Step 2: Result is 4"],
            "correct": true,
            "feedback": "Correct answer!"
          }
        ]
      }
      ```
      ''';
      
      final mockAiService = MockAiService(response: jsonResponse);
      final mockThreadService = MockThreadService();
      
      final service = TestAiGradingService(
        aiService: mockAiService,
        subject: 'math',
        language: 'english',
        parent: mockThreadService,
      );
      
      final result = await service.gradeImage(imageUrl: 'https://example.com/image.jpg');
      
      expect(result.questions.length, 1);
      expect(result.questions[0], isA<MathQuestion>());
      
      final question = result.questions[0] as MathQuestion;
      expect(question.questionNumber, '1');
      expect(question.expression, '2 + 2');
      expect(question.studentAnswer, '4');
      expect(question.steps.length, 2);
      expect(question.correct, true);
      expect(question.feedback, 'Correct answer!');
    });
  });
}

// Concrete implementation of AiGradingService for testing
class TestAiGradingService extends AiGradingService {
  TestAiGradingService({
    required AiService aiService,
    required String subject,
    required String language,
    required ThreadService? parent,
  }) : super(aiService: aiService, subject: subject, language: language, parent: parent);
  
  @override
  ThreadService createThread() {
    return MockThreadService();
  }
} 