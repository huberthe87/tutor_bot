import 'package:flutter/material.dart';

class CropControls extends StatelessWidget {
  final double rotation;
  final VoidCallback onRotate90CCW;
  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;
  final VoidCallback onRotate90CW;
  final VoidCallback onCancel;
  final VoidCallback? onCrop;
  final bool canCrop;

  const CropControls({
    super.key,
    required this.rotation,
    required this.onRotate90CCW,
    required this.onRotateLeft,
    required this.onRotateRight,
    required this.onRotate90CW,
    required this.onCancel,
    required this.onCrop,
    required this.canCrop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // All rotation controls in a single row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 90-degree rotation controls
            IconButton(
              icon: const Icon(Icons.rotate_90_degrees_ccw),
              onPressed: onRotate90CCW,
              tooltip: 'Reset Rotation',
            ),
            const SizedBox(width: 16),
            // 1-degree rotation controls
            IconButton(
              icon: const Icon(Icons.rotate_left),
              onPressed: onRotateLeft,
              tooltip: 'Rotate 1° Counterclockwise',
            ),
            Container(
              width: 80,
              alignment: Alignment.center,
              child: Text(
                '${rotation.toStringAsFixed(1)}°',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.rotate_right),
              onPressed: onRotateRight,
              tooltip: 'Rotate 1° Clockwise',
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.rotate_90_degrees_cw),
              onPressed: onRotate90CW,
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
              onPressed: onCancel,
              icon: const Icon(Icons.close),
              label: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: canCrop ? onCrop : null,
              icon: const Icon(Icons.crop),
              label: const Text('Crop'),
            ),
          ],
        ),
      ],
    );
  }
} 