import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tutor_bot/models/chat_message.dart';
import 'package:tutor_bot/models/grade_result.dart';
import 'package:tutor_bot/models/subject_question.dart';
import 'package:tutor_bot/services/thread_service.dart';
import 'package:tutor_bot/utils/prompt_generator.dart';
import 'package:uuid/uuid.dart';

abstract class AiGradingService extends ThreadService {

  final String subject;
  final String language;

  late String prompt;

  AiGradingService({required aiService, required this.subject, required this.language, required parent}) : super(aiService: aiService, parent: parent) {
    prompt = buildHomeworkAnalysisPrompt(
      subject: subject,
      language: language,
    );
  }

  /// Analyze an image and return a grade result
  Future<GradeResult> gradeImage({
    required String imageUrl,
  }) async {
    String response = await aiService.askImageQuestion(
      imageUrl: imageUrl,
      history: history(),
      prompt: prompt,
    );
    
    debugPrint('Raw response: $response');
    
    // Clean up the response to handle line breaks and partial content
    String jsonContent = response;
    
    // Remove the ```json prefix if present
    if (jsonContent.startsWith('```json')) {
      jsonContent = jsonContent.substring('```json'.length).trim();
    }
    
    // Remove any trailing ``` if present
    if (jsonContent.endsWith('```')) {
      jsonContent = jsonContent.substring(0, jsonContent.length - 3).trim();
    }
    
    debugPrint('Cleaned JSON content: $jsonContent');
    
    // Try to parse the cleaned JSON
    try {
      final parsed = jsonDecode(jsonContent);
      debugPrint('Parsed JSON: $parsed');
      
      // Handle both array and object formats
      final List<dynamic> questions;
      if (parsed is List) {
        questions = parsed;
      } else if (parsed is Map && parsed.containsKey('questions')) {
        questions = parsed['questions'] as List<dynamic>;
      } else {
        throw const FormatException('Invalid response format: expected array or object with questions');
      }
      
      // Create a GradeResult from the parsed JSON
      return GradeResult(
        id: const Uuid().v4(),
        subject: subject,
        questions: questions.map((q) {
          final questionMap = q as Map<String, dynamic>;
          switch (subject.toLowerCase()) {
            case 'math':
              return MathQuestion.fromJson(questionMap);
            case 'english':
              return EnglishQuestion.fromJson(questionMap);
            case 'chinese literature':
              return ChineseLiteratureQuestion.fromJson(questionMap);
            default:
              throw UnsupportedError('Unsupported subject: $subject');
          }
        }).toList(),
        timestamp: DateTime.now(),
        imagePath: imageUrl,
      );
    } catch (e) {
      debugPrint('Initial parsing failed: $e');
      // If parsing fails, try to extract just the JSON object part
      // Use a non-greedy match to avoid capturing nested objects incorrectly
      final RegExp objectRegex = RegExp(r'\{(?:[^{}]|(?:\{[^{}]*\}))*\}', dotAll: true);
      final match = objectRegex.firstMatch(jsonContent);
      
      if (match != null) {
        final objectContent = match.group(0) ?? '';
        debugPrint('Extracted object content: $objectContent');
        final parsed = jsonDecode(objectContent);
        debugPrint('Parsed extracted object: $parsed');
        
        // Handle both array and object formats
        final List<dynamic> questions;
        if (parsed is List) {
          questions = parsed;
        } else if (parsed is Map && parsed.containsKey('questions')) {
          questions = parsed['questions'] as List<dynamic>;
        } else {
          throw const FormatException('Invalid response format: expected array or object with questions');
        }
        
        // Create a GradeResult from the parsed JSON
        return GradeResult(
          id: const Uuid().v4(),
          subject: subject,
          questions: questions.map((q) {
            final questionMap = q as Map<String, dynamic>;
            switch (subject.toLowerCase()) {
              case 'math':
                return MathQuestion.fromJson(questionMap);
              case 'english':
                return EnglishQuestion.fromJson(questionMap);
              case 'chinese literature':
                return ChineseLiteratureQuestion.fromJson(questionMap);
              default:
                throw UnsupportedError('Unsupported subject: $subject');
            }
          }).toList(),
          timestamp: DateTime.now(),
          imagePath: imageUrl,
        );
      } else {
        debugPrint('No JSON object found in response');
        // If all else fails, create a default GradeResult
        return GradeResult(
          id: const Uuid().v4(),
          subject: subject,
          questions: [],
          timestamp: DateTime.now(),
          imagePath: imageUrl,
        );
      }
    }
  }

  Future<GradeResult> analyzeHomeworkImage({
    required String imageUrl,
  }) async {
    GradeResult gradeResult = await gradeImage(imageUrl: imageUrl);
    addMessage(ChatMessage(role: 'assistant', content: gradeResult.toString()));
    return gradeResult;
  }
}