
abstract class CameraGalleryService {
  Future<String?> pickImageFromGallery();

  Future<String?> takePictureWithCamera();
}