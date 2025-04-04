import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'worksheet_editor_screen.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import '../utils/image_utils.dart';

class ImageCropScreen extends StatefulWidget {
  final File imageFile;
  
  const ImageCropScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final GlobalKey _cropKey = GlobalKey();
  final TransformationController _transformationController = TransformationController();
  Offset? _startPoint;
  Offset? _endPoint;
  bool _isCropping = false;
  bool _isLoading = false;
  
  // Image size tracking
  Size? _imageSize;
  Size? _imageContainerSize;
  double _scale = 1.0;
  bool _isMeasuring = false; // Flag to track if we're already measuring
  
  // Rotation tracking
  double _rotation = 0.0;
  
  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformChanged);
    _getImageDimensions();
    
    // Schedule a post-frame callback to measure the image container size
    // We need to wait for the image to be fully rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add a small delay to ensure the image is fully rendered
      Future.delayed(const Duration(milliseconds: 100), () {
        _measureImageContainer();
      });
    });
  }
  
  void _onTransformChanged() {
    final matrix = _transformationController.value;
    final double scale = matrix.getMaxScaleOnAxis();
    final vector_math.Vector3 translation = matrix.getTranslation();
    
    setState(() {
      _scale = scale;
    });
  }
  
  // Get image dimensions after loading
  Future<void> _getImageDimensions() async {
    if (widget.imageFile == null) return;
    
    final Size size = await ImageUtils.getImageDimensions(widget.imageFile);
    setState(() {
      _imageSize = size;
    });
  }
  
  // Measure the actual size of the image container
  void _measureImageContainer() {
    // If we're already measuring or have a valid container size, don't measure again
    if (_isMeasuring || (_imageContainerSize != null && 
        _imageContainerSize!.width > 0 && 
        _imageContainerSize!.height > 0)) {
      return;
    }
    
    _isMeasuring = true;
    
    if (_cropKey.currentContext != null) {
      final RenderBox renderBox = _cropKey.currentContext!.findRenderObject() as RenderBox;
      final Size containerSize = renderBox.size;
      
      debugPrint('=== Image Crop Screen - Measure Image Container ===');
      debugPrint('Image Container Size: $containerSize');
      
      // Only update if we have a valid size
      if (containerSize.width > 0 && containerSize.height > 0) {
        setState(() {
          _imageContainerSize = containerSize;
        });
        _isMeasuring = false;
      } else {
        debugPrint('Warning: Image container size is zero, will retry measurement');
        // Retry measurement after a short delay
        Future.delayed(const Duration(milliseconds: 200), () {
          _isMeasuring = false;
          _measureImageContainer();
        });
      }
    } else {
      debugPrint('Warning: Could not measure image container size - context is null');
      // Retry measurement after a short delay
      Future.delayed(const Duration(milliseconds: 200), () {
        _isMeasuring = false;
        _measureImageContainer();
      });
    }
  }
  
  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    super.dispose();
  }
  
  // Add a method to rotate the image by a specific angle
  void _rotateImageBy(double angle) {
    setState(() {
      _rotation = (_rotation + angle) % 360.0;
      // Reset the transformation controller to avoid conflicts with rotation
      _transformationController.value = Matrix4.identity();
    });
  }
  
  // Rotate the image by 90 degrees clockwise
  void _rotateImage90CW() {
    _rotateImageBy(90.0);
  }
  
  // Resetthe image by 90 degrees counter clockwise
  void _rotateImage90CCW() {
    _rotateImageBy(-90.0);
  }
  
  Future<void> _cropImage() async {
    if (_startPoint == null || _endPoint == null || _imageSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an area to crop')),
      );
      return;
    }
    
    // If we don't have a valid container size, try to measure it again
    if (_imageContainerSize == null || 
        _imageContainerSize!.width == 0 || 
        _imageContainerSize!.height == 0) {
      _measureImageContainer();
      
      // If we still don't have a valid size, use the image size as a fallback
      if (_imageContainerSize == null || 
          _imageContainerSize!.width == 0 || 
          _imageContainerSize!.height == 0) {
        setState(() {
          _imageContainerSize = _imageSize;
        });
        debugPrint('Using image size as fallback for container size: $_imageSize');
      }
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Calculate the crop area in screen coordinates
      final Rect screenCropRect = Rect.fromPoints(_startPoint!, _endPoint!);
      
      // Debug info
      debugPrint('=== Image Crop Screen - Crop Image ===');
      debugPrint('Screen Crop Rect: $screenCropRect');
      debugPrint('Image Container Size: $_imageContainerSize');
      debugPrint('Image Size: $_imageSize');
      debugPrint('Scale: $_scale');
      debugPrint('Rotation: $_rotation');
      
      // Get the current transformation matrix
      final Matrix4 matrix = _transformationController.value;
      final vector_math.Vector3 translation = matrix.getTranslation();
      debugPrint('Translation: $translation');
      
      // Use the utility class to crop the image
      final File croppedFile = await ImageUtils.cropImage(
        imageFile: widget.imageFile,
        screenRect: screenCropRect,
        screenSize: _imageContainerSize!,
        imageSize: _imageSize!,
        scale: _scale,
        translation: translation,
        rotation: _rotation, // Pass the rotation angle
      );
      
      debugPrint('Cropped Image Path: ${croppedFile.path}');
      debugPrint('=== End Crop Image ===');
      
      // Navigate back to WorksheetEditorScreen with the cropped image
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/worksheetEditor',
          (route) => route.isFirst,
          arguments: croppedFile,
        );
      }
    } catch (e) {
      debugPrint('Error cropping image: $e');
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cropping image: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _startCrop(DragStartDetails details) {
    setState(() {
      _isCropping = true;
      _startPoint = details.localPosition;
      _endPoint = details.localPosition;
    });
    
    // Debug info
    debugPrint('=== Image Crop Screen - Start Crop ===');
    debugPrint('Start Point: $_startPoint');
    debugPrint('Image Container Size: $_imageContainerSize');
    debugPrint('Image Size: $_imageSize');
    debugPrint('Scale: $_scale');
  }
  
  void _updateCrop(DragUpdateDetails details) {
    setState(() {
      _endPoint = details.localPosition;
    });
    
    // Debug info
    debugPrint('=== Image Crop Screen - Update Crop ===');
    debugPrint('End Point: $_endPoint');
    debugPrint('Crop Rect: ${Rect.fromPoints(_startPoint!, _endPoint!)}');
  }
  
  void _endCrop(DragEndDetails details) {
    setState(() {
      _isCropping = false;
    });
    
    // Debug info
    debugPrint('=== Image Crop Screen - End Crop ===');
    debugPrint('Final Crop Rect: ${Rect.fromPoints(_startPoint!, _endPoint!)}');
    debugPrint('=== End Crop ===');
  }
  
  void _cancelCrop() {
    setState(() {
      _startPoint = null;
      _endPoint = null;
      _isCropping = false;
    });
  }
  
  void _resetTransform() {
    setState(() {
      _transformationController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Image'),
        actions: [
          if (_startPoint != null && _endPoint != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _isLoading ? null : _cropImage,
              tooltip: 'Apply Crop',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetTransform,
            tooltip: 'Reset Zoom',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // We'll get the image container size from the Image widget's RenderBox
                      // after it's rendered
                      return InteractiveViewer(
                        transformationController: _transformationController,
                        clipBehavior: Clip.none,
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: GestureDetector(
                          onPanStart: _startCrop,
                          onPanUpdate: _updateCrop,
                          onPanEnd: _endCrop,
                          child: Stack(
                            children: [
                              Transform.rotate(
                                angle: _rotation * (3.14159 / 180.0), // Convert degrees to radians
                                child: Image.file(
                                  widget.imageFile,
                                  fit: BoxFit.contain,
                                  key: _cropKey,
                                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                    if (frame != null && (_imageContainerSize == null || 
                                        _imageContainerSize!.width == 0 || 
                                        _imageContainerSize!.height == 0)) {
                                      // Image is loaded and we don't have a valid container size yet
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        _measureImageContainer();
                                      });
                                    }
                                    return child;
                                  },
                                ),
                              ),
                              if (_startPoint != null && _endPoint != null)
                                Positioned.fromRect(
                                  rect: Rect.fromPoints(_startPoint!, _endPoint!),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue, width: 2),
                                      color: Colors.blue.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // All rotation controls in a single row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 90-degree rotation controls
                          IconButton(
                            icon: const Icon(Icons.rotate_90_degrees_ccw),
                            onPressed: _rotateImage90CCW,
                            tooltip: 'Reset Rotation',
                          ),
                          const SizedBox(width: 16),
                          // 1-degree rotation controls
                          IconButton(
                            icon: const Icon(Icons.rotate_left),
                            onPressed: () => _rotateImageBy(-1.0),
                            tooltip: 'Rotate 1° Counterclockwise',
                          ),
                          Container(
                            width: 80,
                            alignment: Alignment.center,
                            child: Text(
                              '${_rotation.toStringAsFixed(1)}°',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.rotate_right),
                            onPressed: () => _rotateImageBy(1.0),
                            tooltip: 'Rotate 1° Clockwise',
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.rotate_90_degrees_cw),
                            onPressed: _rotateImage90CW,
                            tooltip: 'Rotate 90° Clockwise',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Crop controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _cancelCrop,
                            icon: const Icon(Icons.close),
                            label: const Text('Cancel'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _startPoint != null && _endPoint != null
                                ? _cropImage
                                : null,
                            icon: const Icon(Icons.crop),
                            label: const Text('Crop'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
} 