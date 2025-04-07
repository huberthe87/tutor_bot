import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tutor_bot/config/api_config.dart';
import 'package:tutor_bot/services/file_upload_service.dart';
import 'package:tutor_bot/services/grade_service.dart';
import 'package:tutor_bot/services/grade_storage_service.dart';
import 'package:tutor_bot/services/impl/imgbb_file_upload_service.dart';
import 'package:tutor_bot/services/impl/openai_grading_service.dart';
import 'package:tutor_bot/services/impl/openai_service.dart';

class GradeProcessingScreen extends StatefulWidget {
  final File imageFile;
  final String subject;
  final String language;

  const GradeProcessingScreen(
      {super.key,
      required this.imageFile,
      required this.subject,
      required this.language});

  @override
  State<GradeProcessingScreen> createState() => _GradeProcessingState();
}

class _GradeProcessingState extends State<GradeProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AiGradingService _aiGradingService;
  late FileUploadService _fileUploadService;
  late GradeStorageService _gradeStorageService;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('GradeProcessingScreen initState');

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // 360 degrees in radians
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Initialize services
    final aiService = OpenAIService(apiKey: ApiConfig.openAiApiKey);
    _fileUploadService = ImgbbFileUploadService(apiKey: ApiConfig.imgbbApiKey);
    _aiGradingService = OpenAIGradingService(
      aiService: aiService,
      subject: widget.subject,
      language: widget.language,
      parent: null,
    );
    _gradeStorageService = GradeStorageService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('GradeProcessingScreen addPostFrameCallback');
      await _gradeWorksheet(widget.imageFile);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _gradeWorksheet(File imageFile) async {
    try {
      String imageUrl = await _fileUploadService.uploadFile(imageFile);
      final gradeResult =
          await _aiGradingService.gradeImage(imageUrl: imageUrl);
      gradeResult.imagePath = imageFile.path;
      _gradeStorageService.saveGradeResult(gradeResult);

      if (mounted) {
        Navigator.of(context).popAndPushNamed(
          '/gradeResult',
          arguments: {
            'imageFile': imageFile,
            'gradeResult': gradeResult,
          },
        );
      }
    } catch (e) {
      debugPrint('GradeProcessingScreen _gradeWorksheet error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70.withAlpha(51),
      body: SafeArea(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: const Icon(
                              Icons.auto_awesome,
                              size: 60,
                              color: Colors.amber,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Processing Grades',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please wait while we calculate the grades for your worksheet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'This may take a few seconds...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning, color: Colors.grey, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Do not close this window.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel Processing'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
