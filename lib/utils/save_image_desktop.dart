import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:mind_map/utils/save_image.dart';
import 'package:path_provider/path_provider.dart';

class SaveImageImp extends SaveImage {
  @override
  void saveToDisk(Uint8List imageData, String fileName) async {
// Get the directory to store the image
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // Define the file path
    File file = File('$appDocPath/$fileName.png');

    // Write the image data to the file
    await file.writeAsBytes(imageData);

    print("Image saved to $file");
    Get.snackbar("Image saved!", "$fileName.png in Document Folder",
        animationDuration: const Duration(milliseconds: 100),
        duration: const Duration(seconds: 2));
  }
}
