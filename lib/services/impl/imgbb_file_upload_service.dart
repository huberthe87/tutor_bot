import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_bot/services/file_upload_service.dart';

class ImgbbFileUploadService implements FileUploadService  {

  final String apiKey;

  ImgbbFileUploadService({required this.apiKey});

  @override
  Future<String> uploadFile(File file) async {
       try {
      // Convert image to base64
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Create form data
      final formData = {
        'key': apiKey,
        'image': base64Image,
      };
      
      // Send request to ImgBB API
      final response = await http.post(
        Uri.parse('https://api.imgbb.com/1/upload'),
        body: formData,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data']['url'] != null) {
          return data['data']['url'];
        } else {
          debugPrint('ImgBB upload failed: ${data['error']?.message ?? 'Unknown error'}');
          throw Exception('ImgBB upload failed: ${data['error']?.message ?? 'Unknown error'}');
        }
      } else {
        debugPrint('ImgBB upload failed with status code: ${response.statusCode}');
        throw Exception('ImgBB upload failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception uploading to ImgBB: $e');
      throw Exception('Exception uploading to ImgBB: $e');
    }
  }
}
