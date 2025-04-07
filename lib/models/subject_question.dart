abstract class SubjectQuestion {
  String get questionNumber;
  String get feedback;

  static SubjectQuestion fromJson(Map<String, dynamic> q, String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
        return MathQuestion.fromJson(q);
      case 'english':
        return EnglishQuestion.fromJson(q);
      case 'chinese literature':
        return ChineseLiteratureQuestion.fromJson(q);
      default:
        throw UnsupportedError('Unsupported subject: $subject');
    }
  }
}

class MathQuestion implements SubjectQuestion {
  @override
  final String questionNumber;
  final String expression;
  final String? studentAnswer;
  final List<String> steps;
  final bool correct;
  @override
  final String feedback;

  MathQuestion({
    required this.questionNumber,
    required this.expression,
    this.studentAnswer,
    required this.steps,
    required this.correct,
    required this.feedback,
  });

  factory MathQuestion.fromJson(Map<String, dynamic> json) {
    return MathQuestion(
      questionNumber: json['question_number'],
      expression: json['expression'],
      studentAnswer: json['student_answer'],
      steps: List<String>.from(json['steps'] ?? []),
      correct: json['correct'],
      feedback: json['feedback'],
    );
  }
}

class EnglishQuestion implements SubjectQuestion {
  @override
  final String questionNumber;
  final String questionText;
  final String studentAnswer;
  final List<String> grammarErrors;
  final List<String> spellingErrors;
  final int comprehensionScore;
  @override
  final String feedback;

  EnglishQuestion({
    required this.questionNumber,
    required this.questionText,
    required this.studentAnswer,
    required this.grammarErrors,
    required this.spellingErrors,
    required this.comprehensionScore,
    required this.feedback,
  });

  factory EnglishQuestion.fromJson(Map<String, dynamic> json) {
    return EnglishQuestion(
      questionNumber: json['question_number'],
      questionText: json['question_text'],
      studentAnswer: json['student_answer'],
      grammarErrors: List<String>.from(json['grammar_errors'] ?? []),
      spellingErrors: List<String>.from(json['spelling_errors'] ?? []),
      comprehensionScore: json['comprehension_score'],
      feedback: json['feedback'],
    );
  }
}

class ChineseLiteratureQuestion implements SubjectQuestion {
  @override
  final String questionNumber;
  final String questionText;
  final String studentAnswer;
  final List<String> typos;
  final List<String> expressionIssues;
  final List<String> logicIssues;
  final int comprehensionScore;
  @override
  final String feedback;

  ChineseLiteratureQuestion({
    required this.questionNumber,
    required this.questionText,
    required this.studentAnswer,
    required this.typos,
    required this.expressionIssues,
    required this.logicIssues,
    required this.comprehensionScore,
    required this.feedback,
  });

  factory ChineseLiteratureQuestion.fromJson(Map<String, dynamic> json) {
    return ChineseLiteratureQuestion(
      questionNumber: json['question_number'],
      questionText: json['question_text'],
      studentAnswer: json['student_answer'],
      typos: List<String>.from(json['typos'] ?? []),
      expressionIssues: List<String>.from(json['expression_issues'] ?? []),
      logicIssues: List<String>.from(json['logic_issues'] ?? []),
      comprehensionScore: json['comprehension_score'],
      feedback: json['feedback'],
    );
  }
}
