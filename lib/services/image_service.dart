import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  // Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from camera: $e');
    }
  }

  // Pick multiple images
  Future<List<File>> pickMultipleImages({int maxImages = 5}) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      // Limit the number of images
      final limitedImages = images.take(maxImages).toList();
      
      return limitedImages.map((image) => File(image.path)).toList();
    } catch (e) {
      throw Exception('Failed to pick multiple images: $e');
    }
  }

  // Upload single image
  Future<String> uploadImage(File imageFile, String folder) async {
    try {
      final String fileName = '${_uuid.v4()}.jpg';
      final String filePath = '$folder/$fileName';
      
      final Reference ref = _storage.ref().child(filePath);
      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );
      
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(List<File> imageFiles, String folder) async {
    try {
      final List<String> downloadUrls = [];
      
      for (final File imageFile in imageFiles) {
        final String url = await uploadImage(imageFile, folder);
        downloadUrls.add(url);
      }
      
      return downloadUrls;
    } catch (e) {
      throw Exception('Failed to upload multiple images: $e');
    }
  }

  // Upload profile image
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      return await uploadImage(imageFile, 'profile_images/$userId');
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Upload review images
  Future<List<String>> uploadReviewImages(List<File> imageFiles, String reviewId) async {
    try {
      return await uploadMultipleImages(imageFiles, 'review_images/$reviewId');
    } catch (e) {
      throw Exception('Failed to upload review images: $e');
    }
  }

  // Upload chat image
  Future<String> uploadChatImage(File imageFile, String chatRoomId) async {
    try {
      return await uploadImage(imageFile, 'chat_images/$chatRoomId');
    } catch (e) {
      throw Exception('Failed to upload chat image: $e');
    }
  }

  // Delete image
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Delete multiple images
  Future<void> deleteMultipleImages(List<String> imageUrls) async {
    try {
      for (final String imageUrl in imageUrls) {
        await deleteImage(imageUrl);
      }
    } catch (e) {
      throw Exception('Failed to delete multiple images: $e');
    }
  }

  // Get image upload progress
  Stream<TaskSnapshot> uploadImageWithProgress(File imageFile, String folder) {
    final String fileName = '${_uuid.v4()}.jpg';
    final String filePath = '$folder/$fileName';
    
    final Reference ref = _storage.ref().child(filePath);
    final UploadTask uploadTask = ref.putFile(
      imageFile,
      SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      ),
    );
    
    return uploadTask.snapshotEvents;
  }

  // Show image picker options
  Future<File?> showImagePickerOptions() async {
    // This would typically show a bottom sheet or dialog
    // For now, we'll just use gallery
    return await pickImageFromGallery();
  }

  // Compress image (basic compression is already applied in picker)
  Future<File?> compressImage(File imageFile) async {
    try {
      // Basic compression is already applied in the picker
      // For advanced compression, you might use packages like flutter_image_compress
      return imageFile;
    } catch (e) {
      throw Exception('Failed to compress image: $e');
    }
  }

  // Get storage usage
  Future<int> getStorageUsage(String userId) async {
    try {
      // This would require iterating through user's files
      // For now, return a placeholder
      return 0;
    } catch (e) {
      throw Exception('Failed to get storage usage: $e');
    }
  }

  // Validate image file
  bool isValidImageFile(File file) {
    final String extension = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  // Get image size
  Future<int> getImageSize(File file) async {
    try {
      return await file.length();
    } catch (e) {
      return 0;
    }
  }

  // Check if image size is acceptable (max 10MB)
  bool isAcceptableSize(int sizeInBytes) {
    const int maxSize = 10 * 1024 * 1024; // 10MB
    return sizeInBytes <= maxSize;
  }
}