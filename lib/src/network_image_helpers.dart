import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ImageHelper {
  Logger logger = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 220,
    colors: true,
    printEmojis: true,
    printTime: false,
  ));
  Future<Uint8List> displayFromNetwork({String imageUri = ''}) async {
    final response = await http.get(Uri.parse(imageUri), headers: {
      "Content-Type": "image/jpg",
    });
    final bytes = response.bodyBytes;

    return bytes;
  }
}
