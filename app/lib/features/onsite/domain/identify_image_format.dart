import 'dart:typed_data';

import 'package:app/features/onsite/domain/image_format.dart';

ImageFormat? identifyImageFormat(Uint8List bytes) {
  if (_isJpeg(bytes)) return ImageFormat.jpeg;
  if (_isPng(bytes)) return ImageFormat.png;
  if (_isHeif(bytes)) return ImageFormat.heic;
  return null;
}

bool _isJpeg(Uint8List bytes) {
  return bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xD8;
}

bool _isPng(Uint8List bytes) {
  return bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47 &&
      bytes[4] == 0x0D &&
      bytes[5] == 0x0A &&
      bytes[6] == 0x1A &&
      bytes[7] == 0x0A;
}

/// HEIC/HEIF is an ISO BMFF file whose `ftyp` box lists a HEIF brand.
/// AVIF also uses `mif1`; reject it when the `avif` brand is present.
bool _isHeif(Uint8List bytes) {
  if (bytes.length < 12) return false;
  if (bytes[4] != 0x66 ||
      bytes[5] != 0x74 ||
      bytes[6] != 0x79 ||
      bytes[7] != 0x70) {
    return false;
  }

  const heifBrands = {
    'heic',
    'heix',
    'hevc',
    'hevx',
    'heim',
    'heis',
    'hevm',
    'hevs',
    'mif1',
    'msf1',
  };

  final brands = <String>{_fourCc(bytes, 8)};
  for (var offset = 16; offset + 4 <= bytes.length; offset += 4) {
    brands.add(_fourCc(bytes, offset));
  }
  if (brands.contains('avif') || brands.contains('avis')) return false;
  return brands.any(heifBrands.contains);
}

String _fourCc(Uint8List bytes, int offset) {
  return String.fromCharCodes(bytes.sublist(offset, offset + 4));
}
