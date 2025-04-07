import 'dart:io';

/// A service for uploading files to a remote storage service
abstract class FileUploadService {
  
  /// Upload a file to a remote storage service
  Future<String> uploadFile(File file);
}

