import 'package:flutter/material.dart';

class ImageControls extends StatelessWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onPickImage;

  const ImageControls({
    super.key,
    required this.onTakePhoto,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: onTakePhoto,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Take Photo'),
        ),
        ElevatedButton.icon(
          onPressed: onPickImage,
          icon: const Icon(Icons.photo_library),
          label: const Text('Pick Image'),
        ),
      ],
    );
  }
} 