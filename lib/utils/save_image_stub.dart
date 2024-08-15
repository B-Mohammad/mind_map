import 'dart:typed_data';

import 'package:mind_map/utils/save_image.dart';

class SaveImageImp extends SaveImage {
  @override
  void saveToDisk(Uint8List imageData, String fileName) {
    throw UnsupportedError('Cannot save image on this platform');
  }
}
