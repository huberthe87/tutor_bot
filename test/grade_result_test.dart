import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_bot/models/grade_result.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('GradeResult', () {
    test('fromJson with math subject', () {
      final json = {
        'id': const Uuid().v4(),
        'subject': 'math',
        'score': 8,
        'feedback': 'Good work! You showed clear understanding of the concepts.',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'imagePath': '/path/to/image.jpg'
      };

      final result = GradeResult.fromMap(json);

      expect(result.subject, 'math');
      expect(result.score, 8);
      expect(result.feedback, 'Good work! You showed clear understanding of the concepts.');
      expect(result.imagePath, '/path/to/image.jpg');
    });

    test('fromJson with English subject', () {
      final json = {
        'id': const Uuid().v4(),
        'subject': 'english',
        'score': 9,
        'feedback': 'Excellent writing skills demonstrated.',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'imagePath': '/path/to/image.jpg'
      };

      final result = GradeResult.fromMap(json);

      expect(result.subject, 'english');
      expect(result.score, 9);
      expect(result.feedback, 'Excellent writing skills demonstrated.');
      expect(result.imagePath, '/path/to/image.jpg');
    });

    test('fromJson with Chinese Literature subject', () {
      final json = {
        'id': const Uuid().v4(),
        'subject': 'chinese literature',
        'score': 7,
        'feedback': '很好的理解，但可以更深入地分析。',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'imagePath': '/path/to/image.jpg'
      };

      final result = GradeResult.fromMap(json);

      expect(result.subject, 'chinese literature');
      expect(result.score, 7);
      expect(result.feedback, '很好的理解，但可以更深入地分析。');
      expect(result.imagePath, '/path/to/image.jpg');
    });

    test('toJson and fromJson roundtrip', () {
      final original = GradeResult(
        id: const Uuid().v4(),
        subject: 'math',
        questions: [],
        timestamp: DateTime.now(),
        imagePath: '/path/to/image.jpg'
      );

      final json = original.toMap();
      final reconstructed = GradeResult.fromMap(json);

      expect(reconstructed.id, original.id);
      expect(reconstructed.subject, original.subject);
      expect(reconstructed.score, original.score);
      expect(reconstructed.feedback, original.feedback);
      expect(reconstructed.imagePath, original.imagePath);
      expect(reconstructed.timestamp.millisecondsSinceEpoch, original.timestamp.millisecondsSinceEpoch);
    });
  });
} 