import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutor_bot/models/grade_result.dart';
import 'package:tutor_bot/models/subject_question.dart';

class GradeResultScreen extends StatefulWidget {
  final File imageFile;
  final GradeResult gradingResult;

  const GradeResultScreen({
    super.key,
    required this.imageFile,
    required this.gradingResult,
  });

  @override
  State<StatefulWidget> createState() => _GradeResultScreenState();
}

class _GradeResultScreenState extends State<GradeResultScreen> {
  @override
  void initState() {
    super.initState();
    // Prevent going back with system back button/gesture
    SystemChannels.platform
        .invokeMethod('SystemNavigator.setNavigationEnabledForAndroid', false);
  }

  void _onDone() {
    // Re-enable system back navigation before navigating
    SystemChannels.platform
        .invokeMethod('SystemNavigator.setNavigationEnabledForAndroid', true);
    // Navigate to home and clear the stack
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text('Grade Result'),
          automaticallyImplyLeading: false, // Remove back button
          actions: [
            IconButton(
              onPressed: _onDone,
              icon: const Icon(Icons.done),
              tooltip: 'Done',
            ),
            const SizedBox(width: 8), // Add some padding at the end
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Hero(
                tag: 'worksheet_image',
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: FileImage(widget.imageFile),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'AI Grading Result',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            // Overall score card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${widget.gradingResult.score}/10',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(widget.gradingResult.score),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Overall Score',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...widget.gradingResult.questions.map((question) {
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
                            question.correct ? '✓ Correct' : '✗ Incorrect',
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
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
                      Text('Logic Issues: ${question.logicIssues.join(", ")}'),
                    Text('Feedback: ${question.feedback}'),
                    const SizedBox(height: 12),
                  ],
                );
              } else {
                questionWidget =
                    Text('Unknown question type: ${question.runtimeType}');
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: questionWidget,
                ),
              );
            }).toList(),
            // Add some padding at the bottom
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 7) return Colors.green;
    if (score >= 5) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    // Re-enable system back navigation when leaving the screen
    SystemChannels.platform
        .invokeMethod('SystemNavigator.setNavigationEnabledForAndroid', true);
    super.dispose();
  }
}
