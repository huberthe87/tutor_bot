import 'package:uuid/uuid.dart';
import '../models/grade_result.dart';
import '../models/question.dart';
import '../amplify_models/amplify_grade_result.dart';
import '../amplify_models/amplify_question.dart';

class ModelConverter {
  // Convert from your GradeResult to AmplifyGradeResult
  static AmplifyGradeResult toAmplifyGradeResult(GradeResult gradeResult) {
    return AmplifyGradeResult(
      id: gradeResult.id,
      userId: gradeResult.userId,
      score: gradeResult.score.toDouble(),
      totalQuestions: gradeResult.totalQuestions,
      correctAnswers: gradeResult.correctAnswers,
      timestamp: gradeResult.timestamp,
      questions:
          gradeResult.questions?.map((q) => toAmplifyQuestion(q)).toList(),
    );
  }

  // Convert from AmplifyGradeResult to your GradeResult
  static GradeResult fromAmplifyGradeResult(
      AmplifyGradeResult amplifyGradeResult) {
    return GradeResult(
      id: amplifyGradeResult.id,
      userId: amplifyGradeResult.userId,
      score: amplifyGradeResult.score,
      totalQuestions: amplifyGradeResult.totalQuestions,
      correctAnswers: amplifyGradeResult.correctAnswers,
      timestamp: amplifyGradeResult.timestamp,
      questions: amplifyGradeResult.questions
          ?.map((q) => fromAmplifyQuestion(q))
          .toList(),
    );
  }

  // Convert from your Question to AmplifyQuestion
  static AmplifyQuestion toAmplifyQuestion(Question question) {
    return AmplifyQuestion(
      id: question.id,
      text: question.text,
      correctAnswer: question.correctAnswer,
      options: question.options,
      explanation: question.explanation,
      gradeResultId: question.gradeResultId,
    );
  }

  // Convert from AmplifyQuestion to your Question
  static Question fromAmplifyQuestion(AmplifyQuestion amplifyQuestion) {
    return Question(
      id: amplifyQuestion.id,
      text: amplifyQuestion.text,
      correctAnswer: amplifyQuestion.correctAnswer,
      options: amplifyQuestion.options,
      explanation: amplifyQuestion.explanation,
      gradeResultId: amplifyQuestion.gradeResultId,
    );
  }
}
