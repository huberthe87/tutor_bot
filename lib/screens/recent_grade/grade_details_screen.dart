import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/grade_result.dart';
import '../../models/subject_question.dart';
import '../../services/grade_storage_service.dart';
import '../../l10n/app_localizations.dart';

class GradeDetailsScreen extends StatelessWidget {
  final GradeResult grade;
  final GradeStorageService _gradeStorage = GradeStorageService();

  GradeDetailsScreen({super.key, required this.grade});

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteGrade),
        content: Text(l10n.deleteGradeConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await _gradeStorage.deleteGradeResult(grade.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.gradeDeleted)),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  l10n.errorDeletingGrade.replaceAll('{error}', e.toString())),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gradeDetails.replaceAll('{subject}', grade.subject)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grade Score Card
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      l10n.score,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      grade.score.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.gradedOn
                          .replaceAll('{date}', _formatDate(grade.timestamp)),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Original Image Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.originalImage,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (grade.imagePath != null && grade.imagePath!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(grade.imagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          l10n.imageNotAvailable,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Questions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.questions,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...grade.questions.map((question) {
                    // Create a widget based on the question type
                    Widget questionWidget;

                    if (question is MathQuestion) {
                      questionWidget = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: question.correct
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  question.correct
                                      ? l10n.correct
                                      : l10n.incorrect,
                                  style: TextStyle(
                                    color: question.correct
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                  l10n.questionNumber.replaceAll('{number}',
                                      question.questionNumber.toString()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(l10n.expression
                              .replaceAll('{expr}', question.expression)),
                          Text(l10n.studentAnswer.replaceAll(
                              '{answer}',
                              question.studentAnswer ??
                                  l10n.imageNotAvailable)),
                          Text(l10n.feedback
                              .replaceAll('{text}', question.feedback)),
                          Text(l10n.steps,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          ...question.steps.map((step) => Text('• $step')),
                          const SizedBox(height: 12),
                        ],
                      );
                    } else if (question is EnglishQuestion) {
                      questionWidget = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: question.comprehensionScore >= 7
                                      ? Colors.green.shade100
                                      : question.comprehensionScore >= 5
                                          ? Colors.orange.shade100
                                          : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  l10n.comprehensionScore.replaceAll('{score}',
                                      question.comprehensionScore.toString()),
                                  style: TextStyle(
                                    color: question.comprehensionScore >= 7
                                        ? Colors.green.shade800
                                        : question.comprehensionScore >= 5
                                            ? Colors.orange.shade800
                                            : Colors.red.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                  l10n.questionNumber.replaceAll('{number}',
                                      question.questionNumber.toString()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Question: ${question.questionText}'),
                          Text(l10n.studentAnswer
                              .replaceAll('{answer}', question.studentAnswer)),
                          if (question.grammarErrors.isNotEmpty)
                            Text(l10n.grammarErrors.replaceAll(
                                '{errors}', question.grammarErrors.join(", "))),
                          if (question.spellingErrors.isNotEmpty)
                            Text(l10n.spellingErrors.replaceAll('{errors}',
                                question.spellingErrors.join(", "))),
                          Text(l10n.feedback
                              .replaceAll('{text}', question.feedback)),
                          const SizedBox(height: 12),
                        ],
                      );
                    } else if (question is ChineseLiteratureQuestion) {
                      questionWidget = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: question.comprehensionScore >= 7
                                      ? Colors.green.shade100
                                      : question.comprehensionScore >= 5
                                          ? Colors.orange.shade100
                                          : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  l10n.comprehensionScore.replaceAll('{score}',
                                      question.comprehensionScore.toString()),
                                  style: TextStyle(
                                    color: question.comprehensionScore >= 7
                                        ? Colors.green.shade800
                                        : question.comprehensionScore >= 5
                                            ? Colors.orange.shade800
                                            : Colors.red.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                  l10n.questionNumber.replaceAll('{number}',
                                      question.questionNumber.toString()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Question: ${question.questionText}'),
                          Text(l10n.studentAnswer
                              .replaceAll('{answer}', question.studentAnswer)),
                          if (question.typos.isNotEmpty)
                            Text(l10n.spellingErrors.replaceAll(
                                '{errors}', question.typos.join(", "))),
                          if (question.expressionIssues.isNotEmpty)
                            Text(l10n.grammarErrors.replaceAll('{errors}',
                                question.expressionIssues.join(", "))),
                          if (question.logicIssues.isNotEmpty)
                            Text(l10n.feedback.replaceAll(
                                '{text}', question.logicIssues.join(", "))),
                          Text(l10n.feedback
                              .replaceAll('{text}', question.feedback)),
                          const SizedBox(height: 12),
                        ],
                      );
                    } else {
                      questionWidget = Text(
                          'Unknown question type: ${question.runtimeType}');
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: questionWidget,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
