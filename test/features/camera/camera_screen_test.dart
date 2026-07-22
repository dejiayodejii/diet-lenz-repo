import 'dart:typed_data';
import 'dart:ui' show Offset, Size;

import 'package:diet_lenz/features/camera/camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('upload preparation bakes EXIF orientation into image pixels', () {
    final source = img.Image(width: 2, height: 1);
    source
      ..setPixelRgba(0, 0, 255, 0, 0, 255)
      ..setPixelRgba(1, 0, 0, 0, 255, 255)
      ..exif.imageIfd.orientation = 6;

    final encoded = Uint8List.fromList(img.encodeJpg(source, quality: 100));
    final encodedInfo = img.JpegDecoder().startDecode(encoded)!;
    expect(encodedInfo.width, 2);
    expect(encodedInfo.height, 1);

    final prepared = prepareImageForUpload(encoded);
    final preparedInfo = img.JpegDecoder().startDecode(prepared)!;
    final normalized = img.decodeJpg(prepared)!;

    expect(preparedInfo.width, 1);
    expect(preparedInfo.height, 2);
    expect(normalized.width, 1);
    expect(normalized.height, 2);
    expect(normalized.exif.imageIfd.hasOrientation, isFalse);
  });

  test('upload preparation preserves detail up to 2048 pixels', () {
    final source = img.Image(width: 1600, height: 1200);
    final encoded = Uint8List.fromList(img.encodeJpg(source, quality: 95));

    final prepared = prepareImageForUpload(encoded);
    final preparedInfo = img.JpegDecoder().startDecode(prepared)!;

    expect(preparedInfo.width, 1600);
    expect(preparedInfo.height, 1200);
  });

  test('focus point is normalized and clamped to the preview', () {
    expect(
      normalizedCameraPoint(const Offset(150, 300), const Size(300, 600)),
      const Offset(0.5, 0.5),
    );
    expect(
      normalizedCameraPoint(const Offset(-20, 700), const Size(300, 600)),
      const Offset(0, 1),
    );
  });

  test('focus point accounts for a cover-cropped portrait preview', () {
    final top = normalizedCameraPointForCover(
      const Offset(150, 0),
      const Size(300, 300),
      const Size(1920, 1080),
    );
    final center = normalizedCameraPointForCover(
      const Offset(150, 150),
      const Size(300, 300),
      const Size(1920, 1080),
    );
    final bottom = normalizedCameraPointForCover(
      const Offset(150, 300),
      const Size(300, 300),
      const Size(1920, 1080),
    );

    expect(top.dx, closeTo(0.5, 0.001));
    expect(top.dy, closeTo(0.21875, 0.001));
    expect(center, const Offset(0.5, 0.5));
    expect(bottom.dy, closeTo(0.78125, 0.001));
  });

  test('preferred camera selects the primary wide rear lens', () {
    const front = CameraDescription(
      name: 'front',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 90,
    );
    const ultraWide = CameraDescription(
      name: 'ultra-wide',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 90,
      lensType: CameraLensType.ultraWide,
    );
    const wide = CameraDescription(
      name: 'wide',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 90,
      lensType: CameraLensType.wide,
    );

    expect(preferredCamera([front, ultraWide, wide]), wide);
  });
}
