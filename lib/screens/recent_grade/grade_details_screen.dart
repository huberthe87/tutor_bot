import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/grade_result.dart';
import '../../models/subject_question.dart';
import '../../services/grade_storage_service.dart';

class GradeDetailsScreen extends StatelessWidget {
  final GradeResult grade;
  final GradeStorageService _gradeStorage = GradeStorageService();

  GradeDetailsScreen({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grade Details - ${grade.subject}'),
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
                    const Text(
                      'Score',
                      style: TextStyle(
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
                      'Graded on ${_formatDate(grade.timestamp)}',
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
                  const Text(
                    'Original Image',
                    style: TextStyle(
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
                      child: const Center(
                        child: Text(
                          'Image not available',
                          style: TextStyle(
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
                  const Text(
                    'Questions',
                    style: TextStyle(
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
                                      ? '✓ Correct'
                                      : '✗ Incorrect',
                                  style: TextStyle(
                                    color: question.correct
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('Question ${question.questionNumber}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Expression: ${question.expression}'),
                          Text(
                              'Student Answer: ${question.studentAnswer ?? "Not provided"}'),
                          Text('Feedback: ${question.feedback}'),
                          const Text('Steps:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  'Score: ${question.comprehensionScore}/10',
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
                              Text('Question ${question.questionNumber}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Question: ${question.questionText}'),
                          Text('Student Answer: ${question.studentAnswer}'),
                          if (question.grammarErrors.isNotEmpty)
                            Text(
                                'Grammar Errors: ${question.grammarErrors.join(", ")}'),
                          if (question.spellingErrors.isNotEmpty)
                            Text(
                                'Spelling Errors: ${question.spellingErrors.join(", ")}'),
                          Text('Feedback: ${question.feedback}'),
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
                                  'Score: ${question.comprehensionScore}/10',
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
                              Text('Question ${question.questionNumber}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Question: ${question.questionText}'),
                          Text('Student Answer: ${question.studentAnswer}'),
                          if (question.typos.isNotEmpty)
                            Text('Typos: ${question.typos.join(", ")}'),
                          if (question.expressionIssues.isNotEmpty)
                            Text(
                                'Expression Issues: ${question.expressionIssues.join(", ")}'),
                          if (question.logicIssues.isNotEmpty)
                            Text(
                                'Logic Issues: ${question.logicIssues.join(", ")}'),
                          Text('Feedback: ${question.feedback}'),
                          const SizedBox(height: 12),
                        ],
                      );
                    } else {
                      questionWidget = Text(
                          'Unknown question type: ${question.runtimeType}');
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: questionWidget,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Grade'),
        content: const Text(
            'Are you sure you want to delete this grade? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _gradeStorage.deleteGradeResult(grade.id);
      if (context.mounted) {
        Navigator.of(context).pop(true); // Return true to indicate deletion
      }
    }
  }
}
