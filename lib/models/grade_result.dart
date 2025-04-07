import 'dart:convert';

import 'package:tutor_bot/models/subject_question.dart';

class GradeResult {
  final String id;
  final String subject;
  final DateTime timestamp;
  String? imagePath;
  final List<SubjectQuestion> questions;

  GradeResult({
    required this.id,
    required this.subject,
    required this.timestamp,
    required this.imagePath,
    required this.questions,
  });

  // Calculate score based on questions
  int get score {
    if (questions.isEmpty) return 0;
    int totalScore = 0;
    for (var question in questions) {
      if (question is MathQuestion) {
        totalScore += question.correct ? 10 : 0;
      } else if (question is EnglishQuestion) {
        totalScore += question.comprehensionScore;
      } else if (question is ChineseLiteratureQuestion) {
        totalScore += question.comprehensionScore;
      }
    }
    return (totalScore / questions.length).round();
  }

  // Combine feedback from all questions
  String get feedback {
    if (questions.isEmpty) return 'No feedback available';
    return questions.map((q) => q.feedback).join('\n\n');
  }

  // Convert GradeResult to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'score': score,
      'feedback': feedback,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'imagePath': imagePath,
      'questions': questions.map((q) {
        if (q is MathQuestion) {
          return {
            'question_number': q.questionNumber,
            'expression': q.expression,
            'student_answer': q.studentAnswer,
            'steps': q.steps,
            'correct': q.correct,
            'feedback': q.feedback,
          };
        } else if (q is EnglishQuestion) {
          return {
            'question_number': q.questionNumber,
            'question_text': q.questionText,
            'student_answer': q.studentAnswer,
            'grammar_errors': q.grammarErrors,
            'spelling_errors': q.spellingErrors,
            'comprehension_score': q.comprehensionScore,
            'feedback': q.feedback,
          };
        } else if (q is ChineseLiteratureQuestion) {
          return {
            'question_number': q.questionNumber,
            'question_text': q.questionText,
            'student_answer': q.studentAnswer,
            'typos': q.typos,
            'expression_issues': q.expressionIssues,
            'logic_issues': q.logicIssues,
            'comprehension_score': q.comprehensionScore,
            'feedback': q.feedback,
          };
        }
        throw UnsupportedError('Unsupported question type: ${q.runtimeType}');
      }).toList(),
    };
  }

  // Create GradeResult from a Map
  factory GradeResult.fromMap(Map<String, dynamic> map) {
    return GradeResult(
      id: map['id'],
      subject: map['subject'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      imagePath: map['imagePath'],
      questions: (map['questions'] as List).map((q) => SubjectQuestion.fromJson(q as Map<String, dynamic>, map['subject'])).toList(),
    );
  }

  // Convert GradeResult to JSON string
  String toJson() => json.encode(toMap());

  // Create GradeResult from JSON string
  factory GradeResult.fromJson(String source) => GradeResult.fromMap(json.decode(source));
}
