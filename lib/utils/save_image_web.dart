import 'dart:typed_data';
import 'dart:html' as html;

import 'package:get/get.dart';

void saveImageToDiskWeb(Uint8List imageData, String fileName) {
  // Create a Blob from the image data
  final blob = html.Blob([imageData], 'image/png');

  // Create an AnchorElement with a download attribute
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", fileName)
    ..click();

  // Clean up the object URL after download
  html.Url.revokeObjectUrl(url);

  Get.snackbar("Image saved!", "$fileName.png in Download Folder",
      animationDuration: const Duration(milliseconds: 100),
      duration: const Duration(seconds: 2));
}
