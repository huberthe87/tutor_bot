import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import '../utils/image_utils.dart';
import '../widgets/worksheet_editor/crop_controls.dart';

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
  late File _imageFile;
  Offset? _startPoint;
  Offset? _endPoint;
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
    _imageFile = widget.imageFile;
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
    
    setState(() {
      _scale = scale;
    });
  }
  
  // Get image dimensions after loading
  Future<void> _getImageDimensions() async {
    final Size size = await ImageUtils.getImageDimensions(_imageFile);
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
      
      // Only update if we have a valid size
      if (containerSize.width > 0 && containerSize.height > 0) {
        setState(() {
          _imageContainerSize = containerSize;
        });
        _isMeasuring = false;
      } else {
        // Retry measurement after a short delay
        Future.delayed(const Duration(milliseconds: 200), () {
          _isMeasuring = false;
          _measureImageContainer();
        });
      }
    } else {
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
    debugPrint('=== Image Crop Screen - Crop Image ===');
    debugPrint('Start Point: $_startPoint');
    debugPrint('End Point: $_endPoint');
    debugPrint('Image Size: $_imageSize');
    debugPrint('Image Container Size: $_imageContainerSize');
    debugPrint('Scale: $_scale');
    debugPrint('Rotation: $_rotation');
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
      }
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Calculate the crop area in screen coordinates
      final Rect screenCropRect = Rect.fromPoints(_startPoint!, _endPoint!);
      
      // Get the current transformation matrix
      final Matrix4 matrix = _transformationController.value;
      final vector_math.Vector3 translation = matrix.getTranslation();
      
      // Use the utility class to crop the image
      final File croppedFile = await ImageUtils.cropImage(
        imageFile: _imageFile,
        screenRect: screenCropRect,
        screenSize: _imageContainerSize!,
        imageSize: _imageSize!,
        scale: _scale,
        translation: translation,
        rotation: _rotation, // Pass the rotation angle
      );
      
      // Navigate back to WorksheetEditorScreen with the cropped image
      if (mounted) {
        setState(() {
          _imageFile = croppedFile;
          _imageSize = null;
          _imageContainerSize = null;
          _scale = 1.0;
          _rotation = 0.0;
          _startPoint = null;
          _endPoint = null;
        });
         _getImageDimensions();
      }
    } catch (e) {
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
      _startPoint = details.localPosition;
      _endPoint = details.localPosition;
    });
  }
  
  void _updateCrop(DragUpdateDetails details) {
    setState(() {
      _endPoint = details.localPosition;
    });
  }
  
  void _endCrop(DragEndDetails details) {
    setState(() {
    });
  }
  
  void _cancelCrop() {
    setState(() {
      _startPoint = null;
      _endPoint = null;
    });
  }
  
  void _doneEditing() {
    setState(() {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/worksheetEditor',
        (route) => route.isFirst,
        arguments: _imageFile,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: _doneEditing,
            tooltip: 'Done',
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
                      return GestureDetector(
                        onPanStart: _startCrop,
                        onPanUpdate: _updateCrop,
                        onPanEnd: _endCrop,
                        child: InteractiveViewer(
                          transformationController: _transformationController,
                          boundaryMargin: EdgeInsets.zero,
                          clipBehavior: Clip.none,
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: Stack(
                            children: [
                              Transform.rotate(
                                angle: _rotation * (3.14159 / 180.0), // Convert degrees to radians
                                child: Image.file(
                                  _imageFile,
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
                  child: CropControls(
                    rotation: _rotation,
                    onRotate90CCW: _rotateImage90CCW,
                    onRotateLeft: () => _rotateImageBy(-1.0),
                    onRotateRight: () => _rotateImageBy(1.0),
                    onRotate90CW: _rotateImage90CW,
                    onCancel: _cancelCrop,
                    onCrop: _cropImage,
                    canCrop: _startPoint != null && _endPoint != null,
                  ),
                ),
              ],
            ),
    );
  }
} 