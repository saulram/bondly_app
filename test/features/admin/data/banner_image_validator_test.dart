import 'dart:math';
import 'dart:typed_data';

import 'package:bondly_app/features/admin/data/validators/banner_image_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('accepts real JPEG, PNG and WebP signatures', () {
    expect(
        BannerImageValidator.validate(Uint8List.fromList(
                img.encodeJpg(img.Image(width: 1, height: 1))))
            .contentType,
        'image/jpeg');
    expect(
        BannerImageValidator.validate(Uint8List.fromList(
                img.encodePng(img.Image(width: 1, height: 1))))
            .contentType,
        'image/png');
    expect(
        BannerImageValidator.validate(Uint8List.fromList(
                img.encodeWebP(img.Image(width: 1, height: 1))))
            .contentType,
        'image/webp');
  });

  test('rejects truncated, corrupt and signature-spoofed images', () {
    expect(
        () => BannerImageValidator.validate(
            Uint8List.fromList([0xff, 0xd8, 0xff])),
        throwsA(isA<FormatException>()));
    expect(
        () => BannerImageValidator.validate(Uint8List.fromList(
            [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])),
        throwsA(isA<FormatException>()));
    final jpeg = img.encodeJpg(img.Image(width: 2, height: 2));
    expect(
      () => BannerImageValidator.validate(
          Uint8List.fromList(jpeg.sublist(0, jpeg.length ~/ 2))),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => BannerImageValidator.validate(Uint8List.fromList([
        0x89,
        0x50,
        0x4e,
        0x47,
        0x0d,
        0x0a,
        0x1a,
        0x0a,
        ...List<int>.filled(40, 0),
      ])),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => BannerImageValidator.validate(Uint8List.fromList([
        0x52,
        0x49,
        0x46,
        0x46,
        0x10,
        0,
        0,
        0,
        0x57,
        0x45,
        0x42,
        0x50,
        0x56,
        0x50,
        0x38,
        0x58,
        0,
        0,
        0,
        0,
      ])),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects spoofed and oversized files', () {
    expect(
        () => BannerImageValidator.validate(
            Uint8List.fromList('x.jpg'.codeUnits)),
        throwsA(isA<FormatException>()));
    expect(
        () => BannerImageValidator.validate(
            Uint8List(BannerImageValidator.maxBytes + 1)),
        throwsA(isA<FormatException>()));
  });

  test('generates web-safe unique storage object names', () {
    final timestamp = DateTime.fromMicrosecondsSinceEpoch(1730000000000);
    final first = BannerStorageObjectName.generate(
      extension: 'webp',
      timestamp: timestamp,
      random: Random(1),
    );
    final second = BannerStorageObjectName.generate(
      extension: 'webp',
      timestamp: timestamp,
      random: Random(2),
    );

    expect(first, matches(RegExp(r'^banner_1730000000000_[0-9a-f]{8}\.webp$')));
    expect(second, isNot(first));
  });

  test('decodes only generated banner paths from the real storage origin', () {
    const probe = 'http://127.0.0.1:54321/storage/v1/object/public/banners/'
        'banner_origin_probe.jpg';
    expect(
      BannerStorageUrlDecoder.decodeOwnedBannerPath(
        originProbeUrl: probe,
        candidateUrl: 'http://127.0.0.1:54321/storage/v1/object/public/banners/'
            'banner_1730000000000_deadbeef.webp',
      ),
      'banner_1730000000000_deadbeef.webp',
    );
    expect(
      BannerStorageUrlDecoder.decodeOwnedBannerPath(
        originProbeUrl: probe,
        candidateUrl: 'https://project.supabase.co/storage/v1/object/public/'
            'banners/banner_1730000000000_deadbeef.webp',
      ),
      isNull,
    );
    expect(
      BannerStorageUrlDecoder.decodeOwnedBannerPath(
        originProbeUrl: 'https://cdn.example.test/storage/v1/object/public/'
            'banners/banner_origin_probe.jpg',
        candidateUrl: 'https://cdn.example.test/storage/v1/object/public/'
            'banners/banner_1730000000000_abc123.jpg',
      ),
      'banner_1730000000000_abc123.jpg',
    );
    for (final candidate in [
      'https://foreign.example/storage/v1/object/public/banners/'
          'banner_1730000000000_abc123.jpg',
      'http://127.0.0.1:54321/storage/v1/object/public/banners/not-owned.jpg',
      'http://127.0.0.1:54321/storage/v1/object/public/banners/'
          'banner_1730000000000_abc123.jpg?x=1',
      'not a url',
    ]) {
      expect(
        BannerStorageUrlDecoder.decodeOwnedBannerPath(
          originProbeUrl: probe,
          candidateUrl: candidate,
        ),
        isNull,
      );
    }
  });
}
