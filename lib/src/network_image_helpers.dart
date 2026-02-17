import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

const String kPlaceholderAvatar =
    'https://api.minimalavatars.com/avatar/avatar/png';

const String kPlaceholderImage =
    'https://placehold.co/200x200/e2e8f0/94a3b8?text=Sin+imagen';

/// Returns a valid image URL or a placeholder if the path is null/empty.
String safeImageUrl(String? path, {bool isAvatar = false}) {
  if (path == null || path.isEmpty) {
    return isAvatar ? kPlaceholderAvatar : kPlaceholderImage;
  }
  if (path.startsWith('http')) return path;
  return 'https://api.bondly.mx/$path';
}

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
