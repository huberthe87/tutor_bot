import 'package:tutor_bot/models/subject_question.dart';

SubjectQuestion parseSubjectQuestion(String subject, Map<String, dynamic> json) {
  switch (subject.toLowerCase()) {
    case 'math':
      return MathQuestion.fromJson(json);
    case 'english':
      return EnglishQuestion.fromJson(json);
    case 'chinese literature':
    case '语文':
      return ChineseLiteratureQuestion.fromJson(json);
    default:
      throw UnsupportedError('Unsupported subject: $subject');
  }
}
