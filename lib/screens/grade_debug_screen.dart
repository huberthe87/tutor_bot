import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../utils/image_utils.dart';
import '../models/worksheet.dart';
import '../services/grade_processor.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

class GradeDebugScreen extends StatefulWidget {
  final File imageFile;
  final List<Rect> regions;
  
  const GradeDebugScreen({
    super.key,
    required this.imageFile,
    required this.regions,
  });

  @override
  State<GradeDebugScreen> createState() => _GradeDebugScreenState();
}

class _GradeDebugScreenState extends State<GradeDebugScreen> {
  bool _isLoading = false;
  List<GradeResult> _gradeResults = [];
  Size? _imageSize;
  Size? _screenSize;
  double _scale = 1.0;
  final TransformationController _transformationController = TransformationController();
  
  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformChanged);
    _getImageDimensions();
    _processRegions();
  }
  
  void _onTransformChanged() {
    final matrix = _transformationController.value;
    final double scale = matrix.getMaxScaleOnAxis();
    
    setState(() {
      _scale = scale;
    });
  }
  
  Future<void> _getImageDimensions() async {
    final Size size = await ImageUtils.getImageDimensions(widget.imageFile);
    setState(() {
      _imageSize = size;
    });
  }
  
  Future<void> _processRegions() async {
    if (_imageSize == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load the image
      final img.Image? image = img.decodeImage(await widget.imageFile.readAsBytes());
      if (image == null) {
        throw Exception('Failed to decode image');
      }
      
      // Process each region
      final List<GradeResult> results = [];
      
      for (int i = 0; i < widget.regions.length; i++) {
        final Rect region = widget.regions[i];
        
        // Convert screen coordinates to image coordinates
        final Rect imageRegion = _convertScreenRectToImageRect(region);
        
        // Extract the region from the image
        final img.Image regionImage = img.copyCrop(
          image,
          x: imageRegion.left.toInt(),
          y: imageRegion.top.toInt(),
          width: imageRegion.width.toInt(),
          height: imageRegion.height.toInt(),
        );
        
        // Process the region
        final GradeResult result = await GradeProcessor.processRegion(regionImage);
        results.add(result);
      }
      
      setState(() {
        _gradeResults = results;
      });
    } catch (e) {
      debugPrint('Error processing regions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing regions: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Rect _convertScreenRectToImageRect(Rect screenRect) {
    if (_imageSize == null || _screenSize == null) {
      return Rect.zero;
    }
    
    // Get the current transformation matrix
    final Matrix4 matrix = _transformationController.value;
    
    // Calculate the scale factor between image and screen
    final double scaleX = _imageSize!.width / _screenSize!.width;
    final double scaleY = _imageSize!.height / _screenSize!.height;
    
    // Create a matrix that represents the transformation from screen to image coordinates
    final Matrix4 screenToImage = Matrix4.identity()
      ..scale(scaleX, scaleY);
    
    // Apply the inverse of the current transformation to get back to the original image coordinates
    final Matrix4 inverseTransform = Matrix4.inverted(matrix);
    
    // Combine the transformations
    final Matrix4 combinedTransform = screenToImage * inverseTransform;
    
    // Convert the screen rectangle corners to image coordinates
    final vector_math.Vector3 topLeft = combinedTransform.transform3(vector_math.Vector3(screenRect.left, screenRect.top, 0));
    final vector_math.Vector3 bottomRight = combinedTransform.transform3(vector_math.Vector3(screenRect.right, screenRect.bottom, 0));
    
    // Ensure the region is within the image bounds
    final double imageLeft = topLeft.x.clamp(0.0, _imageSize!.width);
    final double imageTop = topLeft.y.clamp(0.0, _imageSize!.height);
    final double imageRight = bottomRight.x.clamp(0.0, _imageSize!.width);
    final double imageBottom = bottomRight.y.clamp(0.0, _imageSize!.height);
    
    return Rect.fromLTRB(imageLeft, imageTop, imageRight, imageBottom);
  }
  
  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Debug'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _processRegions,
            tooltip: 'Reprocess Regions',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _gradeResults.isEmpty
              ? const Center(child: Text('No regions to display'))
              : ListView.builder(
                  itemCount: _gradeResults.length,
                  itemBuilder: (context, index) {
                    final GradeResult result = _gradeResults[index];
                    
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Region ${index + 1}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: _getGradeColor(result.grade),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                '${result.grade} (${(result.confidence * 100).toStringAsFixed(1)}%)',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (result.metadata != null) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Metadata:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ...result.metadata!.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '${entry.key}: ${entry.value.toStringAsFixed(2)}',
                                  ),
                                );
                              }).toList(),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
  
  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.deepOrange;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 