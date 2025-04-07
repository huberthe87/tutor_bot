import 'package:flutter/material.dart';
import 'package:tutor_bot/screens/grade_process/grade_processing_screen.dart';
import 'package:tutor_bot/screens/grade_result/grade_result_screen.dart';
import 'package:tutor_bot/models/grade_result.dart';
import 'dart:io';
import 'screens/main_screen.dart';
import 'screens/worksheet_editor/worksheet_editor_screen.dart';
import 'screens/image_crop_screen.dart';
import 'screens/recent_grade/grade_details_screen.dart';
import 'theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutor Bot',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/worksheetEditor': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return WorksheetEditorScreen(
            imageFile: args as File?,
          );
        },
        '/grading': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final imageFile = args['imageFile'] as File;
          final subject = args['subject'] as String;
          final language = args['language'] as String;
          return GradeProcessingScreen(
            imageFile: imageFile,
            subject: subject,
            language: language,
          );
        },
        '/gradeResult': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final imageFile = args['imageFile'] as File;
          final gradeResult = args['gradeResult'] as GradeResult;
          return GradeResultScreen(
              imageFile: imageFile, gradingResult: gradeResult);
        },
        '/gradeDetails': (context) {
          final grade =
              ModalRoute.of(context)!.settings.arguments as GradeResult;
          return GradeDetailsScreen(grade: grade);
        },
        '/imageCrop': (context) => ImageCropScreen(
              imageFile: ModalRoute.of(context)!.settings.arguments as File,
            ),
      },
    );
  }
}
