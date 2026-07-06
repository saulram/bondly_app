import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

const String kPlaceholderAvatar =
    'https://ui-avatars.com/api/?name=User&background=random';

const String kPlaceholderImage =
    'https://placehold.co/200x200/e2e8f0/94a3b8?text=Sin+imagen';

String safeImageUrl(String? path, {bool isAvatar = false}) {
  if (path == null || path.isEmpty) {
    return isAvatar ? kPlaceholderAvatar : kPlaceholderImage;
  }

  // Replace dead minimalavatars URLs that might be hardcoded in the database
  if (path.contains('api.minimalavatars.com')) {
    return kPlaceholderAvatar;
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
    dateTimeFormat: DateTimeFormat.none,
  ));
  Future<Uint8List> displayFromNetwork({String imageUri = ''}) async {
    final response = await http.get(Uri.parse(imageUri), headers: {
      "Content-Type": "image/jpg",
    });
    final bytes = response.bodyBytes;

    return bytes;
  }
}
