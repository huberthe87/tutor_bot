import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionUtils {
  /// Request camera permission
  static Future<bool> requestCameraPermission(BuildContext context) async {
    // First check if permission is already granted
    if (await Permission.camera.isGranted) {
      return true;
    }
    
    // Check if permission is permanently denied
    if (await Permission.camera.isPermanentlyDenied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is permanently denied. Please enable it in Settings.'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: openAppSettings,
            ),
          ),
        );
      }
      return false;
    }
    
    // Request the permission using the system dialog
    final status = await Permission.camera.request();
    
    if (status.isDenied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to take photos'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: openAppSettings,
            ),
          ),
        );
      }
      return false;
    }
    return true;
  }

  /// Check and request gallery permissions
  static Future<bool> checkGalleryPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      // Get Android SDK version
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      
      // For Android 13 and above (API 33+)
      if (sdkInt >= 33) {
        if (await Permission.photos.status.isDenied) {
          // Check if permission is permanently denied
          if (await Permission.photos.isPermanentlyDenied) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Media access is permanently denied. Please enable it in Settings.'),
                  action: SnackBarAction(
                    label: 'Settings',
                    onPressed: openAppSettings,
                  ),
                ),
              );
            }
            return false;
          }
          
          // Try to request the permission
          final status = await Permission.photos.request();
          
          // If still denied, show settings dialog
          if (status.isDenied) {
            if (context.mounted) {
              // Show a dialog explaining why we need the permission
              final bool shouldOpenSettings = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Permission Required'),
                  content: const Text('This app needs access to your media files to select worksheets. Please grant permission in Settings.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              ) ?? false;
              
              if (shouldOpenSettings) {
                await openAppSettings();
              }
            }
            return false;
          }
        }
      }
      // For Android 12 (API 31-32)
      else if (sdkInt >= 31) {
        if (await Permission.storage.status.isDenied) {
          // Check if permission is permanently denied
          if (await Permission.storage.isPermanentlyDenied) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Files and media access is permanently denied. Please enable it in Settings.'),
                  action: SnackBarAction(
                    label: 'Settings',
                    onPressed: openAppSettings,
                  ),
                ),
              );
            }
            return false;
          }
          
          final status = await Permission.storage.request();
          if (status.isDenied) {
            if (context.mounted) {
              // Show a dialog explaining why we need the permission
              final bool shouldOpenSettings = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Permission Required'),
                  content: const Text('This app needs access to your files and media to select worksheets. Please grant permission in Settings.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              ) ?? false;
              
              if (shouldOpenSettings) {
                await openAppSettings();
              }
            }
            return false;
          }
        }
      }
      // For Android 11 and below (API 30-)
      else {
        if (await Permission.manageExternalStorage.status.isDenied) {
          // Check if permission is permanently denied
          if (await Permission.manageExternalStorage.isPermanentlyDenied) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All files access is permanently denied. Please enable it in Settings.'),
                  action: SnackBarAction(
                    label: 'Settings',
                    onPressed: openAppSettings,
                  ),
                ),
              );
            }
            return false;
          }
          
          final status = await Permission.manageExternalStorage.request();
          if (status.isDenied) {
            if (context.mounted) {
              // Show a dialog explaining why we need the permission
              final bool shouldOpenSettings = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Permission Required'),
                  content: const Text('This app needs access to all files to select worksheets. Please grant permission in Settings.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              ) ?? false;
              
              if (shouldOpenSettings) {
                await openAppSettings();
              }
            }
            return false;
          }
        }
      }

      // Check if we have any of the required permissions based on Android version
      if (sdkInt >= 33) {
        final hasPhotosPermission = await Permission.photos.status.isGranted;
        if (!hasPhotosPermission) {
          if (context.mounted) {
            // Show a dialog explaining why we need the permission
            final bool shouldOpenSettings = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Permission Required'),
                content: const Text('This app needs access to your media files to select worksheets. Please grant permission in Settings.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            ) ?? false;
            
            if (shouldOpenSettings) {
              await openAppSettings();
            }
          }
          return false;
        }
      } else if (sdkInt >= 31) {
        final hasStoragePermission = await Permission.storage.status.isGranted;
        if (!hasStoragePermission) {
          if (context.mounted) {
            // Show a dialog explaining why we need the permission
            final bool shouldOpenSettings = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Permission Required'),
                content: const Text('This app needs access to your files and media to select worksheets. Please grant permission in Settings.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            ) ?? false;
            
            if (shouldOpenSettings) {
              await openAppSettings();
            }
          }
          return false;
        }
      } else {
        final hasManageStoragePermission = await Permission.manageExternalStorage.status.isGranted;
        if (!hasManageStoragePermission) {
          if (context.mounted) {
            // Show a dialog explaining why we need the permission
            final bool shouldOpenSettings = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Permission Required'),
                content: const Text('This app needs access to all files to select worksheets. Please grant permission in Settings.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            ) ?? false;
            
            if (shouldOpenSettings) {
              await openAppSettings();
            }
          }
          return false;
        }
      }
    }
    return true;
  }
} 