import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

class ImageUtils {
  /// Crops an image based on screen coordinates
  static Future<File> cropImage({
    required File imageFile,
    required Rect screenRect,
    required Size screenSize, // This is actually the image container size
    required Size imageSize,
    required double scale,
    required vector_math.Vector3 translation,
    double rotation = 0.0, // Default rotation is 0 degrees
  }) async {
    // Debug info
    debugPrint('=== ImageUtils - Crop Image ===');
    debugPrint('Screen Rect: $screenRect');
    debugPrint('Image Container Size: $screenSize');
    debugPrint('Image Size: $imageSize');
    debugPrint('Scale: $scale');
    debugPrint('Translation: $translation');
    debugPrint('Rotation: $rotation degrees');
    
    // Convert screen coordinates to image coordinates
    final Rect imageCropRect = convertScreenRectToImageRect(
      screenRect: screenRect,
      screenSize: screenSize,
      imageSize: imageSize,
      scale: scale,
      translation: translation,
    );
    
    debugPrint('Image Crop Rect: $imageCropRect');
    
    // Load the image
    final ui.Image image = await _loadImage(imageFile);
    
    // Apply rotation if needed
    ui.Image rotatedImage = image;
    if (rotation != 0.0) {
      rotatedImage = await _rotateImage(image, rotation);
    }
    
    // Crop the image
    final ui.Image croppedImage = await _cropImageFromRect(rotatedImage, imageCropRect);
    
    // Save the cropped image to a temporary file
    final String tempPath = '${imageFile.parent.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File croppedFile = File(tempPath);
    
    // Convert the image to bytes and save it
    final ByteData? byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      await croppedFile.writeAsBytes(byteData.buffer.asUint8List());
      debugPrint('Cropped image saved to: ${croppedFile.path}');
    } else {
      throw Exception('Failed to convert cropped image to bytes');
    }
    
    return croppedFile;
  }
  
  /// Converts screen coordinates to image coordinates
  static Rect convertScreenRectToImageRect({
    required Rect screenRect,
    required Size screenSize, // This is actually the image container size
    required Size imageSize,
    required double scale,
    required vector_math.Vector3 translation,
  }) {
    // Debug info
    debugPrint('=== ImageUtils - Convert Screen Rect to Image Rect ===');
    debugPrint('Screen Rect: $screenRect');
    debugPrint('Image Container Size: $screenSize');
    debugPrint('Image Size: $imageSize');
    debugPrint('Scale: $scale');
    debugPrint('Translation: $translation');
    
    // Calculate scale factors for x and y dimensions
    final double imageScale = imageSize.width / screenSize.width;
    
    debugPrint('Scale Factors: $imageScale');
    
    // Convert screen coordinates to image coordinates
    // Note: screenRect coordinates are relative to the image container
    final double left = (screenRect.left - translation.x) * imageScale / scale;
    final double top = (screenRect.top - translation.y) * imageScale / scale;
    final double right = (screenRect.right - translation.x) * imageScale / scale;
    final double bottom = (screenRect.bottom - translation.y) * imageScale / scale;
    
    debugPrint('Converted Coordinates - Left: $left, Top: $top, Right: $right, Bottom: $bottom');
    
    // Ensure the crop rectangle is within the image bounds
    final double imageLeft = left.clamp(0.0, imageSize.width);
    final double imageTop = top.clamp(0.0, imageSize.height);
    final double imageRight = right.clamp(0.0, imageSize.width);
    final double imageBottom = bottom.clamp(0.0, imageSize.height);
    
    debugPrint('Clamped Coordinates - Left: $imageLeft, Top: $imageTop, Right: $imageRight, Bottom: $imageBottom');
    
    // Ensure left < right and top < bottom
    final double finalLeft = imageLeft < imageRight ? imageLeft : imageRight;
    final double finalTop = imageTop < imageBottom ? imageTop : imageBottom;
    final double finalRight = imageLeft < imageRight ? imageRight : imageLeft;
    final double finalBottom = imageTop < imageBottom ? imageBottom : imageTop;
    
    debugPrint('Final Coordinates - Left: $finalLeft, Top: $finalTop, Right: $finalRight, Bottom: $finalBottom');
    
    // Create a new rectangle with the final coordinates
    final Rect result = Rect.fromLTRB(finalLeft, finalTop, finalRight, finalBottom);
    
    // Verify the rectangle is valid
    if (result.isEmpty) {
      debugPrint('WARNING: Resulting rectangle is empty!');
    }
    
    return result;
  }
  
  /// Crops an image based on a rectangle
  static Future<ui.Image> _cropImageFromRect(ui.Image image, Rect cropRect) async {
    // Debug info
    debugPrint('=== ImageUtils - Crop Image From Rect ===');
    debugPrint('Original Image Size: ${image.width} x ${image.height}');
    debugPrint('Crop Rect: $cropRect');
    
    // Create a new image with the cropped dimensions
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    
    // Draw the cropped portion of the image
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(
        cropRect.left,
        cropRect.top,
        cropRect.width,
        cropRect.height,
      ),
      Rect.fromLTWH(
        0,
        0,
        cropRect.width,
        cropRect.height,
      ),
      Paint(),
    );
    
    // Finish recording and create the image
    final ui.Picture picture = recorder.endRecording();
    final ui.Image croppedImage = await picture.toImage(
      cropRect.width.toInt(),
      cropRect.height.toInt(),
    );
    
    debugPrint('Cropped Image Size: ${croppedImage.width} x ${croppedImage.height}');
    debugPrint('=== End Crop Image From Rect ===');
    
    return croppedImage;
  }
  
  /// Gets the dimensions of an image from a file
  static Future<Size> getImageDimensions(File imageFile) async {
    final Image image = Image.file(imageFile);
    final Completer<Size> completer = Completer();
    
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    
    return await completer.future;
  }
  
  /// Loads an image from a file
  static Future<ui.Image> _loadImage(File imageFile) async {
    final Uint8List bytes = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
  
  /// Rotates an image by the specified angle in degrees
  static Future<ui.Image> _rotateImage(ui.Image image, double angleDegrees) async {
    // Convert angle from degrees to radians
    final double angleRadians = angleDegrees * (3.14159 / 180.0);
    
    // Calculate the new dimensions after rotation
    final int width = image.width;
    final int height = image.height;
    
    // Create a new image with the same dimensions
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    
    // Translate to the center of the image
    canvas.translate(width / 2, height / 2);
    
    // Rotate around the center
    canvas.rotate(angleRadians);
    
    // Draw the image centered
    canvas.drawImage(image, Offset(-width / 2, -height / 2), Paint());
    
    // Finish recording and create the image
    final ui.Picture picture = recorder.endRecording();
    final ui.Image rotatedImage = await picture.toImage(width, height);
    
    debugPrint('Image rotated by $angleDegrees degrees');
    
    return rotatedImage;
  }
  
  /// Crops a specific region from an image
  static Future<File?> cropRegion(File imageFile, Rect region, String regionName, {double? padding}) async {
    debugPrint('=== ImageUtils - Crop Region ===');
    debugPrint('Image File: ${imageFile.path}');
    debugPrint('Region: $region');
    debugPrint('Region Name: $regionName');
    
    try {
      // Load the image
      final ui.Image image = await _loadImage(imageFile);
      
      // Calculate dynamic padding based on region size
      // Use 10% of the smaller dimension (width or height) as padding
      // with a minimum of 5 pixels and a maximum of 30 pixels
      final double calculatedPadding = padding ?? _calculateDynamicPadding(region);
      debugPrint('Calculated Padding: $calculatedPadding');
      
      // Add padding to the region
      final Rect paddedRegion = Rect.fromLTWH(
        (region.left - calculatedPadding).clamp(0.0, image.width.toDouble()),
        (region.top - calculatedPadding).clamp(0.0, image.height.toDouble()),
        (region.width + 2 * calculatedPadding).clamp(0.0, image.width.toDouble()),
        (region.height + 2 * calculatedPadding).clamp(0.0, image.height.toDouble()),
      );
      
      debugPrint('Padded Region: $paddedRegion');
      
      // Ensure the region is valid
      if (paddedRegion.isEmpty || 
          paddedRegion.left < 0 || 
          paddedRegion.top < 0 || 
          paddedRegion.right > image.width || 
          paddedRegion.bottom > image.height) {
        debugPrint('Invalid region after padding, skipping');
        return null;
      }
      
      // Crop the image
      final ui.Image croppedImage = await _cropImageFromRect(image, paddedRegion);
      
      // Create a temporary directory if it doesn't exist
      final Directory tempDir = Directory('${imageFile.parent.path}/temp');
      if (!tempDir.existsSync()) {
        tempDir.createSync(recursive: true);
      }
      
      // Save the cropped image to a temporary file
      final String tempPath = '${tempDir.path}/${regionName}_${DateTime.now().millisecondsSinceEpoch}.png';
      final File croppedFile = File(tempPath);
      
      // Convert the image to bytes and save it
      final ByteData? byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        await croppedFile.writeAsBytes(byteData.buffer.asUint8List());
        debugPrint('Cropped region saved to: ${croppedFile.path}');
        return croppedFile;
      } else {
        debugPrint('Failed to convert cropped image to bytes');
        return null;
      }
    } catch (e) {
      debugPrint('Error cropping region: $e');
      return null;
    }
  }
  
  /// Calculates dynamic padding based on region size
  static double _calculateDynamicPadding(Rect region) {
    // Use 10% of the smaller dimension (width or height) as padding
    final double minDimension = region.width < region.height ? region.width : region.height;
    final double calculatedPadding = minDimension * 0.1;
    
    // Clamp the padding between 5 and 30 pixels
    return calculatedPadding.clamp(5.0, 30.0);
  }
} 