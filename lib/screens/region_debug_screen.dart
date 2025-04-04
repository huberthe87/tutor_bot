import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../utils/image_utils.dart';
import '../services/grade_processor.dart';
import '../models/worksheet.dart';
import '../utils/openai_client.dart';
import '../config/api_config.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class RegionDebugScreen extends StatefulWidget {
  final Worksheet worksheet;

  const RegionDebugScreen({Key? key, required this.worksheet}) : super(key: key);

  @override
  State<RegionDebugScreen> createState() => _RegionDebugScreenState();
}

class _RegionDebugScreenState extends State<RegionDebugScreen> {
  final List<File> _croppedImages = [];
  final List<String> _aiFeedbacks = [];
  final List<bool> _isLoadingFeedback = [];
  late OpenAIClient _openAiClient;
  bool _isProcessing = false;
  bool _isLoading = false;
  String? _errorMessage;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _openAiClient = OpenAIClient(
      apiKey: ApiConfig.openAiApiKey,
      imgbbApiKey: ApiConfig.imgbbApiKey,
    );
    _loadWorksheet();
  }

  void _loadWorksheet() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.worksheet.imageFile != null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No image file found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading worksheet: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      try {
        // Create a temporary file
        final tempDir = await getTemporaryDirectory();
        final tempPath = '${tempDir.path}/${_uuid.v4()}.jpg';
        final tempFile = File(tempPath);
        
        // Copy the image to the temporary file
        await tempFile.writeAsBytes(await image.readAsBytes());
        
        // Update the worksheet with the new image file
        final updatedWorksheet = widget.worksheet.copyWith(
          imageFile: tempFile,
        );
        
        // TODO: Save the updated worksheet to storage
        
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Error processing image: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _cropImage() async {
    if (widget.worksheet.imageFile == null) {
      setState(() {
        _errorMessage = 'No image to crop';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Load the image
      final imageBytes = await widget.worksheet.imageFile!.readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('Failed to decode image');
      }
      
      // For demonstration, let's crop the image into 4 equal parts
      final width = image.width;
      final height = image.height;
      
      final crops = [
        img.copyCrop(image, x: 0, y: 0, width: width ~/ 2, height: height ~/ 2),
        img.copyCrop(image, x: width ~/ 2, y: 0, width: width ~/ 2, height: height ~/ 2),
        img.copyCrop(image, x: 0, y: height ~/ 2, width: width ~/ 2, height: height ~/ 2),
        img.copyCrop(image, x: width ~/ 2, y: height ~/ 2, width: width ~/ 2, height: height ~/ 2),
      ];
      
      // Save each crop to a temporary file
      final tempDir = await getTemporaryDirectory();
      final croppedFiles = <File>[];
      
      for (var i = 0; i < crops.length; i++) {
        final crop = crops[i];
        final tempPath = '${tempDir.path}/crop_${_uuid.v4()}.jpg';
        final tempFile = File(tempPath);
        
        // Encode the image as JPEG and write to the file
        final jpegBytes = img.encodeJpg(crop);
        await tempFile.writeAsBytes(jpegBytes);
        
        croppedFiles.add(tempFile);
      }
      
      setState(() {
        _croppedImages.clear();
        _croppedImages.addAll(croppedFiles);
        _aiFeedbacks.clear();
        _aiFeedbacks.addAll(List.filled(croppedFiles.length, ''));
        _isLoadingFeedback.clear();
        _isLoadingFeedback.addAll(List.filled(croppedFiles.length, false));
        _isProcessing = false;
      });
      
      // Load AI feedbacks asynchronously
      _loadAIFeedbacks();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error cropping image: $e';
        _isProcessing = false;
      });
    }
  }

  Future<void> _loadAIFeedbacks() async {
    for (var i = 0; i < _croppedImages.length; i++) {
      if (_isLoadingFeedback[i]) continue; // Skip if already loading
      
      setState(() {
        _isLoadingFeedback[i] = true;
      });
      
      try {
        // Use the existing gradeQuestionInImage method
        final feedback = await _openAiClient.gradeQuestionInImage(
          _croppedImages[i],
          'You are a helpful teacher grading a student\'s worksheet. Provide a grade (A, B, C, D, or F) and brief feedback explaining the grade.',
        );
        
        setState(() {
          _aiFeedbacks[i] = feedback;
          _isLoadingFeedback[i] = false;
        });
      } catch (e) {
        setState(() {
          _aiFeedbacks[i] = 'Error generating feedback: $e';
          _isLoadingFeedback[i] = false;
        });
      }
    }
  }

  Color _getGradeColor(String feedback) {
    if (feedback.toLowerCase().contains('a')) {
      return Colors.green;
    } else if (feedback.toLowerCase().contains('b')) {
      return Colors.lightGreen;
    } else if (feedback.toLowerCase().contains('c')) {
      return Colors.orange;
    } else if (feedback.toLowerCase().contains('d')) {
      return Colors.deepOrange;
    } else if (feedback.toLowerCase().contains('f')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Region Debug'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWorksheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Pick Image'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: widget.worksheet.imageFile != null
                          ? FutureBuilder<bool>(
                              future: _isValidImageFile(widget.worksheet.imageFile!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                
                                if (snapshot.hasError || !snapshot.data!) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Invalid image file',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: _pickImage,
                                          child: const Text('Pick Image'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                
                                return Image.file(
                                  widget.worksheet.imageFile!,
                                  fit: BoxFit.contain,
                                );
                              },
                            )
                          : Center(
                              child: ElevatedButton(
                                onPressed: _pickImage,
                                child: const Text('Pick Image'),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text('Pick Image'),
                          ),
                          ElevatedButton(
                            onPressed: _isProcessing ? null : _cropImage,
                            child: _isProcessing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Crop Image'),
                          ),
                        ],
                      ),
                    ),
                    if (_croppedImages.isNotEmpty)
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Cropped Regions (${_croppedImages.length})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: _croppedImages.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.file(
                                            _croppedImages[index],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          color: _getGradeColor(_aiFeedbacks[index]),
                                          child: _isLoadingFeedback[index]
                                              ? const Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(strokeWidth: 2),
                                                  ),
                                                )
                                              : Text(
                                                  _aiFeedbacks[index],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }

  Future<bool> _isValidImageFile(File file) async {
    try {
      if (!await file.exists()) {
        return false;
      }
      
      final fileSize = await file.length();
      if (fileSize == 0) {
        return false;
      }
      
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      return image != null;
    } catch (e) {
      return false;
    }
  }
} 