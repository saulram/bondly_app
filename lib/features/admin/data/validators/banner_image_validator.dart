import 'dart:typed_data';

import 'package:image/image.dart' as img;

class BannerImageInfo {
  final String extension;
  final String contentType;

  const BannerImageInfo(this.extension, this.contentType);
}

/// Validates image structure and dimensions, rather than trusting a filename
/// or MIME type supplied by a picker.
class BannerImageValidator {
  static const maxBytes = 10 * 1024 * 1024;

  static BannerImageInfo validate(Uint8List bytes) {
    if (bytes.isEmpty || bytes.length > maxBytes) {
      throw const FormatException('La imagen debe pesar como máximo 10 MB.');
    }
    final extension = _extensionFromSignature(bytes);
    if (extension == null) {
      throw const FormatException('Formato no válido. Usa JPEG, PNG o WebP.');
    }
    try {
      final decoded = img.decodeImage(bytes);
      if (decoded == null || decoded.width <= 0 || decoded.height <= 0) {
        throw const FormatException('Formato no válido. Usa JPEG, PNG o WebP.');
      }
      final contentType =
          extension == 'jpg' ? 'image/jpeg' : 'image/$extension';
      return BannerImageInfo(extension, contentType);
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('Formato no válido. Usa JPEG, PNG o WebP.');
    }
  }

  static String? _extensionFromSignature(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xff &&
        bytes[1] == 0xd8 &&
        bytes[2] == 0xff) {
      return 'jpg';
    }
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4e &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0d &&
        bytes[5] == 0x0a &&
        bytes[6] == 0x1a &&
        bytes[7] == 0x0a) {
      return 'png';
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return 'webp';
    }
    return null;
  }
}

class BannerStorageUrlDecoder {
  static final _generatedName =
      RegExp(r'^banner_[0-9]+_[0-9a-f]{1,8}\.(jpg|png|webp)$');

  static String? decodeOwnedBannerPath({
    required String candidateUrl,
    required String originProbeUrl,
  }) {
    final candidate = Uri.tryParse(candidateUrl);
    final probe = Uri.tryParse(originProbeUrl);
    if (candidate == null ||
        probe == null ||
        candidate.scheme.isEmpty ||
        probe.scheme.isEmpty ||
        candidate.scheme != probe.scheme ||
        candidate.host != probe.host ||
        candidate.port != probe.port ||
        candidate.userInfo.isNotEmpty ||
        probe.userInfo.isNotEmpty ||
        candidate.query.isNotEmpty ||
        candidate.fragment.isNotEmpty ||
        probe.query.isNotEmpty ||
        probe.fragment.isNotEmpty) {
      return null;
    }
    final slash = probe.path.lastIndexOf('/');
    if (slash <= 0 || !probe.path.startsWith('/')) {
      return null;
    }
    final prefix = probe.path.substring(0, slash + 1);
    if (!prefix.endsWith('/banners/') || !candidate.path.startsWith(prefix)) {
      return null;
    }
    final path = candidate.path.substring(prefix.length);
    return path.isNotEmpty &&
            !path.contains('/') &&
            _generatedName.hasMatch(path)
        ? path
        : null;
  }
}
