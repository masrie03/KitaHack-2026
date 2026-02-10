import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Needed to check if we are on Web

class UploadService {
  final Dio _dio = Dio();
  
  // Use 127.0.0.1 for Web to talk to your local backend
  static const String _uploadUrl = "http://127.0.0.1:5001/kitahack-byteme-backend/us-central1/parsePolicy";

  Future<PlatformFile?> pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true, // MANDATORY for Web to get the bytes
      );

      if (result != null) {
        return result.files.first; // Return the PlatformFile object instead of File
      }
      return null;
    } catch (e) {
      print("Error picking file: $e");
      return null;
    }
  }

  Future<dynamic> uploadToBackend(PlatformFile pickedFile) async {
    try {
      MultipartFile filePayload;

      if (kIsWeb) {
        // On Web, use the bytes we grabbed
        filePayload = MultipartFile.fromBytes(
          pickedFile.bytes!,
          filename: pickedFile.name,
        );
      } else {
        // On Mobile/Desktop, use the path
        filePayload = await MultipartFile.fromFile(
          pickedFile.path!,
          filename: pickedFile.name,
        );
      }

      FormData formData = FormData.fromMap({
        "file": filePayload,
      });

      print("Uploading ${pickedFile.name}...");
      final response = await _dio.post(_uploadUrl, data: formData);

      print("Upload Successful");
      return response.data;
      
    } catch (e) {
      print("Upload error: $e");
      rethrow;
    }
  }
}