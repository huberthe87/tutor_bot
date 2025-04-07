import 'dart:io';
import 'package:flutter/material.dart';

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