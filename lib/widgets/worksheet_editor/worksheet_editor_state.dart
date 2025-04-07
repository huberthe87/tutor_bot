import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import '../../utils/image_utils.dart';

class WorksheetEditorState extends ChangeNotifier {
  File? _image;
  bool _isEditMode = false;
  final TransformationController _transformationController = TransformationController();
  
  // Stream controllers for scale and pan events
  final _scaleController = StreamController<double>.broadcast();
  final _panController = StreamController<Offset>.broadcast();
  
  // Region selection variables
  List<Rect> _selectedRegions = [];
  
  // Image size tracking
  final GlobalKey _imageContainerKey = GlobalKey();
  Size? _imageContainerSize;

  // Getters
  File? get image => _image;
  bool get isEditMode => _isEditMode;
  List<Rect> get selectedRegions => _selectedRegions;
  Stream<double> get scaleStream => _scaleController.stream;
  Stream<Offset> get panStream => _panController.stream;
  GlobalKey get imageContainerKey => _imageContainerKey;
  Size? get imageContainerSize => _imageContainerSize;
  TransformationController get transformationController => _transformationController;

  WorksheetEditorState() {
    _transformationController.addListener(_onTransformChanged);
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
    
    notifyListeners();
  }

  Future<void> setImage(File file) async {
    _image = file;
    await _getImageDimensions();
    notifyListeners();
  }

  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }

  void addRegion(Rect region) {
    _selectedRegions.add(region);
    notifyListeners();
  }

  void undoLastRegion() {
    if (_selectedRegions.isNotEmpty) {
      _selectedRegions.removeLast();
      notifyListeners();
    }
  }

  void clearRegions() {
    _selectedRegions = [];
    notifyListeners();
  }

  Future<void> _getImageDimensions() async {
    if (_image == null) return;
    
    try {
      final size = await ImageUtils.getImageDimensions(_image!);
      debugPrint('Image dimensions: $size');
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting image dimensions: $e');
    }
  }

  void setContainerSize(Size size) {
    _imageContainerSize = size;
    notifyListeners();
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    _scaleController.close();
    _panController.close();
    super.dispose();
  }

  void sendImageForGrading() {
    // _openAiClient.gradeImage(_image!);
  }
} 