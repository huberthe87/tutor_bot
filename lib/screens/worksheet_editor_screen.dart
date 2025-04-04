import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import '../utils/permission_utils.dart';
import '../utils/image_utils.dart';
import 'image_crop_screen.dart';
import 'grade_debug_screen.dart';
import 'region_debug_screen.dart';

class WorksheetEditorScreen extends StatefulWidget {
  final File? imageFile;
  
  const WorksheetEditorScreen({
    super.key,
    this.imageFile,
  });

  @override
  State<WorksheetEditorScreen> createState() => _WorksheetEditorScreenState();
}

class _WorksheetEditorScreenState extends State<WorksheetEditorScreen> {
  File? _image;
  bool _isEditMode = false;
  final ImagePicker _picker = ImagePicker();
  final TransformationController _transformationController = TransformationController();
  
  // Stream controllers for scale and pan events
  final _scaleController = StreamController<double>.broadcast();
  final _panController = StreamController<Offset>.broadcast();
  
  // Stream getters
  Stream<double> get scaleStream => _scaleController.stream;
  Stream<Offset> get panStream => _panController.stream;
  
  // Region selection variables
  List<Rect> _selectedRegions = [];
  
  // Image size tracking
  Size? _imageSize;
  Size? _screenSize;
  double _scale = 1.0;
  final GlobalKey _imageContainerKey = GlobalKey();
  Size? _imageContainerSize;
  bool _isMeasuring = false;
  bool _hasMeasuredContainer = false;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformChanged);
    
    // Initialize with the initial image if provided
    if (widget.imageFile != null) {
      _image = widget.imageFile;
      _getImageDimensions();
    }
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Check if we have arguments from the route
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is File && _image == null) {
      _image = args;
      _getImageDimensions();
    }
  }

  void _onTransformChanged() {
    final matrix = _transformationController.value;
    final double scale = matrix.getMaxScaleOnAxis();
    final vector_math.Vector3 translation = matrix.getTranslation();
    
    debugPrint('Zoom changed: scale=$scale');
    debugPrint('Panned: translateX=${translation.x}, translateY=${translation.y}');
    
    // Emit events to streams
    _scaleController.add(scale);
    _panController.add(Offset(translation.x, translation.y));
    
    setState(() {
      _scale = scale;
    });
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    _scaleController.close();
    _panController.close();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (!await PermissionUtils.requestCameraPermission(context)) return;
    
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Navigate to the crop screen
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/imageCrop',
        arguments: File(photo.path),
      );
    }
  }

  Future<void> _pickImage() async {
    if (!await PermissionUtils.checkGalleryPermission(context)) return;
    
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Navigate to the crop screen
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/imageCrop',
        arguments: File(image.path),
      );
    }
  }
  
  // Get image dimensions after loading
  Future<void> _getImageDimensions() async {
    if (_image == null) return;
    
    try {
      final size = await ImageUtils.getImageDimensions(_image!);
      debugPrint('Image dimensions: $size');
      
      setState(() {
        _imageSize = size;
      });
      
      // Only measure the container if we haven't already
      if (!_hasMeasuredContainer) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _measureImageContainer();
        });
      }
    } catch (e) {
      debugPrint('Error getting image dimensions: $e');
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _clearRegions() {
    setState(() {
      _selectedRegions = [];
    });
  }
  
  void _undoLastRegion() {
    if (_selectedRegions.isNotEmpty) {
      setState(() {
        _selectedRegions.removeLast();
      });
    }
  }

  void _sendForGrading() {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    if (_selectedRegions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one region to grade')),
      );
      return;
    }

    // TODO: Implement sending for grading functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Worksheet sent for grading!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worksheet Editor'),
        actions: [
          if (_image != null) ...[
            IconButton(
              icon: Icon(_isEditMode ? Icons.check : Icons.edit),
              onPressed: _toggleEditMode,
              tooltip: _isEditMode ? 'Finish Editing' : 'Edit Regions',
              color: _isEditMode ? Colors.green : null,
            ),
            if (!_isEditMode)
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendForGrading,
                tooltip: 'Send for Grading',
              ),
            if (_selectedRegions.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.science),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/gradeDebug',
                    arguments: {
                      'imageFile': _image!,
                      'regions': _selectedRegions,
                    },
                  );
                },
                tooltip: 'Debug Grade Processing',
              ),
            if (_selectedRegions.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.crop),
                onPressed: () {
                  // Get the current image container size
                  final RenderBox? renderBox = _imageContainerKey.currentContext?.findRenderObject() as RenderBox?;
                  final Size? containerSize = renderBox?.size;
                  
                  debugPrint('Navigating to RegionDebugScreen with container size: $containerSize');
                  
                  Navigator.pushNamed(
                    context,
                    '/regionDebug',
                    arguments: {
                      'imageFile': _image!,
                      'regions': _selectedRegions,
                      'screenSize': containerSize,
                    },
                  );
                },
                tooltip: 'View Cropped Regions',
              ),
          ],
        ],
      ),
      body: Expanded(
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 4.0,
            child: Align(
              alignment: Alignment.topCenter,
              child: _image == null
                  ? const Text('No image selected')
                  : ImageRegionSelector(
                      image: _image!,
                      isEditMode: _isEditMode,
                      imageContainerKey: _imageContainerKey,
                      onRegionAdded: (region) {
                        setState(() {
                          _selectedRegions.add(region);
                        });
                      },
                      onContainerMeasured: (size) {
                        setState(() {
                          _imageContainerSize = size;
                          _hasMeasuredContainer = true;
                        });
                      },
                      selectedRegions: _selectedRegions,
                    ),
            ),
          ),
        ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: _isEditMode && _selectedRegions.isNotEmpty
              ? RegionControls(
                  isEditMode: _isEditMode,
                  regionCount: _selectedRegions.length,
                  onUndo: _undoLastRegion,
                  onClear: _clearRegions,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Pick Image'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _measureImageContainer() {
    if (_isMeasuring || _hasMeasuredContainer) return;
    
    _isMeasuring = true;
    
    final RenderBox? renderBox = _imageContainerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      debugPrint('Image container size: $size');
      setState(() {
        _imageContainerSize = size;
        _hasMeasuredContainer = true;
      });
    }
    
    _isMeasuring = false;
  }
}

class ImageRegionSelector extends StatefulWidget {
  final File image;
  final bool isEditMode;
  final GlobalKey imageContainerKey;
  final Function(Rect) onRegionAdded;
  final Function(Size) onContainerMeasured;
  final List<Rect> selectedRegions;

  const ImageRegionSelector({
    super.key,
    required this.image,
    required this.isEditMode,
    required this.imageContainerKey,
    required this.onRegionAdded,
    required this.onContainerMeasured,
    required this.selectedRegions,
  });

  @override
  State<ImageRegionSelector> createState() => _ImageRegionSelectorState();
}

class _ImageRegionSelectorState extends State<ImageRegionSelector> {
  Offset? _startPoint;
  Offset? _endPoint;
  bool _hasMeasuredContainer = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: widget.isEditMode ? (details) {
        setState(() {
          _startPoint = details.localPosition;
          _endPoint = details.localPosition;
        });
      } : null,
      onPanUpdate: widget.isEditMode ? (details) {
        setState(() {
          _endPoint = details.localPosition;
        });
      } : null,
      onPanEnd: widget.isEditMode ? (details) {
        if (_startPoint != null && _endPoint != null) {
          final Rect region = Rect.fromPoints(_startPoint!, _endPoint!);
          widget.onRegionAdded(region);
          setState(() {
            _startPoint = null;
            _endPoint = null;
          });
        }
      } : null,
      child: Stack(
        children: [
          Image.file(
            widget.image,
            key: widget.imageContainerKey,
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (frame != null && !_hasMeasuredContainer) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _measureImageContainer();
                });
              }
              return child;
            },
          ),
          if (widget.isEditMode && _startPoint != null && _endPoint != null)
            Positioned.fill(
              child: CustomPaint(
                painter: RegionSelectionPainter(
                  startPoint: _startPoint!,
                  endPoint: _endPoint!,
                ),
              ),
            ),
          ...widget.selectedRegions.map((region) {
            return Positioned.fromRect(
              rect: region,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                  color: Colors.red.withOpacity(0.2),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _measureImageContainer() {
    final RenderBox? renderBox = widget.imageContainerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      debugPrint('Image container size: $size');
      widget.onContainerMeasured(size);
      setState(() {
        _hasMeasuredContainer = true;
      });
    }
  }
}

class RegionSelectionPainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;

  RegionSelectionPainter({
    required this.startPoint,
    required this.endPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final rect = Rect.fromPoints(startPoint, endPoint);
    canvas.drawRect(rect, paint);
    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(RegionSelectionPainter oldDelegate) {
    return oldDelegate.startPoint != startPoint || oldDelegate.endPoint != endPoint;
  }
}

class RegionControls extends StatelessWidget {
  final bool isEditMode;
  final int regionCount;
  final VoidCallback onUndo;
  final VoidCallback onClear;

  const RegionControls({
    super.key,
    required this.isEditMode,
    required this.regionCount,
    required this.onUndo,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Row(
            children: [
              if (isEditMode && regionCount > 0)
                IconButton(
                  onPressed: onUndo,
                  icon: const Icon(Icons.undo),
                  tooltip: 'Undo Last Region',
                ),
              if (!isEditMode)
                Row(
                  children: [
                    IconButton(
                      onPressed: onClear,
                      icon: const Icon(Icons.delete),
                      tooltip: 'Clear All Regions',
                    ),
                    Text(
                      '($regionCount)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
} 