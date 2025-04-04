import 'package:flutter/material.dart';
import 'dart:io';
import 'screens/home_screen.dart';
import 'screens/worksheet_editor_screen.dart';
import 'screens/image_crop_screen.dart';
import 'screens/region_debug_screen.dart';
import 'screens/grade_debug_screen.dart';
import 'theme/app_theme.dart';
import 'models/worksheet.dart';

void main() {
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
        '/': (context) => const HomeScreen(),
        '/worksheetEditor': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return WorksheetEditorScreen(
            imageFile: args as File?,
          );
        },
        '/imageCrop': (context) => ImageCropScreen(
          imageFile: ModalRoute.of(context)!.settings.arguments as File,
        ),
        '/regionDebug': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          
          // Create a worksheet from the provided image file
          final worksheet = Worksheet(
            id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
            title: 'Debug Worksheet',
            imageFile: args['imageFile'] as File,
            regions: [],
            gradeResults: [],
            createdAt: DateTime.now(),
          );
          
          return RegionDebugScreen(
            worksheet: worksheet,
          );
        },
        '/gradeDebug': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return GradeDebugScreen(
            imageFile: args['imageFile'] as File,
            regions: args['regions'] as List<Rect>,
          );
        },
      },
    );
  }
}
