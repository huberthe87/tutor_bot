import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OpenAIClient {
  final String apiKey;
  final String? imgbbApiKey;
  
  OpenAIClient({
    required this.apiKey, 
    this.imgbbApiKey,
  });
  
  /// Upload an image to ImgBB and return the URL
  Future<String?> uploadImageToImgBB(File imageFile) async {
    if (imgbbApiKey == null) {
      debugPrint('ImgBB API key not provided, skipping upload');
      return null;
    }
    
    try {
      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Create form data
      final formData = {
        'key': imgbbApiKey,
        'image': base64Image,
      };
      
      // Send request to ImgBB API
      final response = await http.post(
        Uri.parse('https://api.imgbb.com/1/upload'),
        body: formData,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data']['url'];
        } else {
          debugPrint('ImgBB upload failed: ${data['error']?.message ?? 'Unknown error'}');
          return null;
        }
      } else {
        debugPrint('ImgBB upload failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception uploading to ImgBB: $e');
      return null;
    }
  }
  
  /// Analyze text using OpenAI's API
  Future<String> analyzeText(String text) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant that analyzes text for educational purposes.'
            },
            {
              'role': 'user',
              'content': text
            }
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('API request failed with status code: ${response.statusCode}');
      }
      
      final data = json.decode(response.body);
      final content = data['choices'][0]['message']['content'];
      
      if (content == null || content.isEmpty) {
        return 'No response generated';
      }
      
      return content;
    } catch (e) {
      debugPrint('Exception: $e');
      throw Exception('Failed to analyze text: $e');
    }
  }
  
  /// Analyze an image using OpenAI's Vision API
  Future<String> analyzeImage(File imageFile) async {
    try {
      String imageUrl;
      
      // Try to upload to ImgBB first if API key is available
      if (imgbbApiKey != null) {
        final imgbbUrl = await uploadImageToImgBB(imageFile);
        if (imgbbUrl != null) {
          imageUrl = imgbbUrl;
          debugPrint('Using ImgBB URL: $imageUrl');
        } else {
          // Fallback to base64 if ImgBB upload fails
          final bytes = await imageFile.readAsBytes();
          final base64Image = base64Encode(bytes);
          imageUrl = 'data:image/jpeg;base64,$base64Image';
          debugPrint('Using base64 encoding (ImgBB upload failed)');
        }
      } else {
        // Use base64 if no ImgBB API key is provided
        final bytes = await imageFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        imageUrl = 'data:image/jpeg;base64,$base64Image';
        debugPrint('Using base64 encoding (no ImgBB API key)');
      }
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant that analyzes images for educational purposes.'
            },
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': 'Analyze this worksheet image and provide feedback on the student\'s work.'
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': imageUrl
                  }
                }
              ]
            }
          ],
          'max_tokens': 1000,
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('API request failed with status code: ${response.statusCode}');
      }
      
      final data = json.decode(response.body);
      final content = data['choices'][0]['message']['content'];
      
      if (content == null || content.isEmpty) {
        return 'No response generated';
      }
      
      return content;
    } catch (e) {
      debugPrint('Exception: $e');
      throw Exception('Failed to analyze image: $e');
    }
  }
  
  /// Grade a question in an image
  Future<String> gradeQuestionInImage(File imageFile, String prompt) async {
    try {
      String imageUrl;
      
      // Try to upload to ImgBB first if API key is available
      if (imgbbApiKey != null) {
        final imgbbUrl = await uploadImageToImgBB(imageFile);
        if (imgbbUrl != null) {
          imageUrl = imgbbUrl;
          debugPrint('Using ImgBB URL: $imageUrl');
        } else {
          // Fallback to base64 if ImgBB upload fails
          final bytes = await imageFile.readAsBytes();
          final base64Image = base64Encode(bytes);
          imageUrl = 'data:image/jpeg;base64,$base64Image';
          debugPrint('Using base64 encoding (ImgBB upload failed)');
        }
      } else {
        // Use base64 if no ImgBB API key is provided
        final bytes = await imageFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        imageUrl = 'data:image/jpeg;base64,$base64Image';
        debugPrint('Using base64 encoding (no ImgBB API key)');
      }
      
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': prompt
            },
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': 'Read this homework question in the image briefly and concisely, give the answer in one sentence.'
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': imageUrl
                  }
                }
              ]
            }
          ],
          'max_tokens': 300,
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('API request failed with status code: ${response.statusCode}');
      }
      
      final data = json.decode(response.body);
      final content = data['choices'][0]['message']['content'];
      
      if (content == null || content.isEmpty) {
        return 'No response generated';
      }
      
      return content;
    } catch (e) {
      debugPrint('Exception: $e');
      throw Exception('Failed to grade region: $e');
    }
  }
} 