import 'package:flutter/material.dart';
import '../models/grade_result.dart';

class RecentGradesList extends StatelessWidget {
  final List<GradeResult> grades;
  final bool isLoading;
  final Function(DateTime) formatDate;

  const RecentGradesList({
    super.key,
    required this.grades,
    required this.isLoading,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Grades',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        _buildContent(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (grades.isEmpty) {
      return const Center(
        child: Text(
          'No recent grades',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(grades.length, (index) {
        final grade = grades[index];
        return Card(
          margin: EdgeInsets.only(
            bottom: 12,
            top: index == 0 ? 0 : 12,
          ),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text(
                grade.score.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              grade.subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Graded on ${formatDate(grade.timestamp)}',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward, size: 16),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/gradeDetails',
                arguments: grade,
              );
            },
          ),
        );
      }),
    );
  }
} 