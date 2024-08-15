import 'dart:typed_data';

abstract class SaveImage {
  void saveToDisk(Uint8List imageData, String fileName);
}
