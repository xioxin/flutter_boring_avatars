import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_boring_avatars/src/painter/marble.dart';

// ---------------------------------------------------------------------------
// Original marble painting implementation (pre-optimization).
// Paths are built inline and transformed twice per path.
// ---------------------------------------------------------------------------
void _paintOriginalMarble(
    BoringAvatarMarbleData data, Canvas canvas, Rect rect) {
  const double boxSize = 80;
  final size = rect.size;
  final scaleW = size.width / boxSize;
  final scaleH = size.height / boxSize;
  double cX(double x) => x * scaleW;

  canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
  final blur = MaskFilter.blur(BlurStyle.normal, cX(7));

  Paint paintFill = Paint()
    ..style = PaintingStyle.fill
    ..color = data.bgColor;
  canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paintFill);

  final resizeTransform = Matrix4.identity()..scaleByDouble(scaleW, scaleH, scaleW, 1.0);

  final path1Transform = Matrix4.identity()
    ..translateByDouble(data.element1TranslateX, data.element1TranslateY, 0.0, 1.0)
    ..translateByDouble(boxSize / 2, boxSize / 2, 0.0, 1.0)
    ..rotateZ(data.element1Rotate * (pi / 180))
    ..translateByDouble(-boxSize / 2, -boxSize / 2, 0.0, 1.0)
    ..scaleByDouble(data.element1Scale, data.element1Scale, data.element1Scale, 1.0);

  Path path1 = (Path()
        ..moveTo(32.414, 59.35)
        ..lineTo(50.376, 70.5)
        ..lineTo(72.5, 70.5)
        ..lineTo(72.5, -0.5)
        ..lineTo(33.728, -0.5)
        ..lineTo(26.5, 13.381)
        ..relativeLineTo(19.057, 27.08)
        ..close())
      .transform(path1Transform.storage)
      .transform(resizeTransform.storage);

  Paint paintFill1 = Paint()
    ..style = PaintingStyle.fill
    ..color = data.element1Color
    ..maskFilter = blur;
  canvas.drawPath(path1, paintFill1);

  final paintFill2 = Paint()
    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.overlay
    ..color = data.element2Color
    ..maskFilter = blur;

  final path2Transform = Matrix4.identity()
    ..translateByDouble(data.element2TranslateX, data.element2TranslateY, 0.0, 1.0)
    ..translateByDouble(boxSize / 2, boxSize / 2, 0.0, 1.0)
    ..rotateZ(data.element2Rotate * (pi / 180))
    ..translateByDouble(-boxSize / 2, -boxSize / 2, 0.0, 1.0)
    ..scaleByDouble(data.element2Scale, data.element2Scale, data.element2Scale, 1.0);

  final path2 = (Path()
        ..moveTo(22.216, 24)
        ..lineTo(0, 46.75)
        ..relativeLineTo(14.108, 38.129)
        ..lineTo(78, 86)
        ..relativeLineTo(-3.081, -59.276)
        ..relativeLineTo(-22.378, 4.005)
        ..relativeLineTo(12.972, 20.186)
        ..relativeLineTo(-23.35, 27.395)
        ..close())
      .transform(path2Transform.storage)
      .transform(resizeTransform.storage);
  canvas.drawPath(path2, paintFill2);
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
Future<ui.Image> _renderToImage(
    void Function(Canvas, Rect) painter, Size size) {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final rect = Offset.zero & size;
  painter(canvas, rect);
  return recorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());
}

BoringAvatarCustomPainter _findPainter(WidgetTester tester) {
  final finder = find.byWidgetPredicate(
    (w) => w is CustomPaint && w.painter is BoringAvatarCustomPainter,
  );
  final customPaint = tester.widget<CustomPaint>(finder);
  return customPaint.painter! as BoringAvatarCustomPainter;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  // -------------------------------------------------------
  // 1. Visual regression – pixel-identical output
  // -------------------------------------------------------
  group('Marble visual regression', () {
    const testSize = Size(128, 128);
    const testNames = ['Maya Angelou', 'Margaret Bourke', 'test', ''];

    for (final name in testNames) {
      test('pixel-identical output for "$name"', () async {
        final data =
            BoringAvatarMarbleData.generate(name: name);

        final originalImage = await _renderToImage(
          (canvas, rect) => _paintOriginalMarble(data, canvas, rect),
          testSize,
        );
        final optimizedImage = await _renderToImage(
          (canvas, rect) => data.paint(canvas, rect),
          testSize,
        );

        final originalBytes = (await originalImage.toByteData(
            format: ui.ImageByteFormat.rawRgba))!;
        final optimizedBytes = (await optimizedImage.toByteData(
            format: ui.ImageByteFormat.rawRgba))!;

        expect(optimizedBytes.lengthInBytes, originalBytes.lengthInBytes,
            reason: 'image byte length mismatch');
        expect(
          optimizedBytes.buffer.asUint8List(),
          originalBytes.buffer.asUint8List(),
          reason: 'pixel data differs for "$name"',
        );
      });
    }

    test('pixel-identical at different sizes', () async {
      final data =
          BoringAvatarMarbleData.generate(name: 'size test');

      for (final size in [
        const Size(32, 32),
        const Size(64, 64),
        const Size(256, 256),
        const Size(100, 200),
      ]) {
        final originalImage = await _renderToImage(
          (canvas, rect) => _paintOriginalMarble(data, canvas, rect),
          size,
        );
        final optimizedImage = await _renderToImage(
          (canvas, rect) => data.paint(canvas, rect),
          size,
        );

        final originalBytes = (await originalImage.toByteData(
            format: ui.ImageByteFormat.rawRgba))!;
        final optimizedBytes = (await optimizedImage.toByteData(
            format: ui.ImageByteFormat.rawRgba))!;

        expect(
          optimizedBytes.buffer.asUint8List(),
          originalBytes.buffer.asUint8List(),
          reason: 'pixel data differs at size $size',
        );
      }
    });
  });

  // -------------------------------------------------------
  // 2. Data generation regression – all types deterministic
  // -------------------------------------------------------
  group('Data generation determinism', () {
    for (final type in BoringAvatarType.values) {
      test('$type generates identical data for same input', () {
        final a = BoringAvatarData.generate(name: 'test', type: type);
        final b = BoringAvatarData.generate(name: 'test', type: type);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('$type generates different data for different input', () {
        final a = BoringAvatarData.generate(name: 'Alice', type: type);
        final b = BoringAvatarData.generate(name: 'Bob', type: type);
        expect(a, isNot(equals(b)));
      });
    }
  });

  // -------------------------------------------------------
  // 3. Performance benchmark – old vs new marble painting
  // -------------------------------------------------------
  group('Performance benchmark', () {
    const iterations = 10000;
    const benchSize = Size(128, 128);
    final benchRect = Offset.zero & benchSize;
    final testData = BoringAvatarMarbleData.generate(name: 'benchmark');

    test('marble data generation ($iterations iterations)', () {
      final names =
          List.generate(iterations, (i) => 'user_$i');

      final sw = Stopwatch()..start();
      for (final name in names) {
        BoringAvatarMarbleData.generate(name: name);
      }
      sw.stop();

      // ignore: avoid_print
      print('Data generation: ${sw.elapsedMilliseconds} ms '
          '($iterations iterations, '
          '${(sw.elapsedMicroseconds / iterations).toStringAsFixed(1)} µs/iter)');
    });

    test('original marble paint ($iterations iterations)', () {
      final recorder = ui.PictureRecorder();
      var canvas = Canvas(recorder);

      final sw = Stopwatch()..start();
      for (int i = 0; i < iterations; i++) {
        _paintOriginalMarble(testData, canvas, benchRect);
      }
      sw.stop();
      recorder.endRecording();

      // ignore: avoid_print
      print('Original marble paint: ${sw.elapsedMilliseconds} ms '
          '($iterations iterations, '
          '${(sw.elapsedMicroseconds / iterations).toStringAsFixed(1)} µs/iter)');
    });

    test('optimized marble paint ($iterations iterations)', () {
      final recorder = ui.PictureRecorder();
      var canvas = Canvas(recorder);

      final sw = Stopwatch()..start();
      for (int i = 0; i < iterations; i++) {
        testData.paint(canvas, benchRect);
      }
      sw.stop();
      recorder.endRecording();

      // ignore: avoid_print
      print('Optimized marble paint: ${sw.elapsedMilliseconds} ms '
          '($iterations iterations, '
          '${(sw.elapsedMicroseconds / iterations).toStringAsFixed(1)} µs/iter)');
    });
  });

  // -------------------------------------------------------
  // 4. Widget caching – BoringAvatar StatefulWidget
  // -------------------------------------------------------
  group('Widget data caching', () {
    testWidgets('BoringAvatar caches data across rebuilds with same inputs',
        (tester) async {
      late StateSetter outerSetState;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              outerSetState = setState;
              return const BoringAvatar(name: 'cached');
            },
          ),
        ),
      );

      final data1 = _findPainter(tester).avatarData;

      // Trigger parent rebuild without changing inputs.
      outerSetState(() {});
      await tester.pump();

      final data2 = _findPainter(tester).avatarData;

      expect(identical(data1, data2), isTrue,
          reason: 'data should be the same object when inputs unchanged');
    });

    testWidgets('BoringAvatar regenerates data when name changes',
        (tester) async {
      var name = 'Alice';

      late StateSetter outerSetState;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              outerSetState = setState;
              return BoringAvatar(name: name);
            },
          ),
        ),
      );

      final data1 = _findPainter(tester).avatarData;

      outerSetState(() => name = 'Bob');
      await tester.pump();

      final data2 = _findPainter(tester).avatarData;

      expect(identical(data1, data2), isFalse,
          reason: 'data should be regenerated when name changes');
      expect(data1, isNot(equals(data2)));
    });

    testWidgets('BoringAvatar regenerates data when type changes',
        (tester) async {
      var type = BoringAvatarType.marble;

      late StateSetter outerSetState;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              outerSetState = setState;
              return BoringAvatar(name: 'test', type: type);
            },
          ),
        ),
      );

      final data1 = _findPainter(tester).avatarData;

      outerSetState(() => type = BoringAvatarType.beam);
      await tester.pump();

      final data2 = _findPainter(tester).avatarData;

      expect(identical(data1, data2), isFalse,
          reason: 'data should be regenerated when type changes');
    });

    testWidgets('BoringAvatar regenerates when inherited palette changes',
        (tester) async {
      const palette1 = BoringAvatarPalette.defaultPalette;
      const palette2 = BoringAvatarPalette([
        Color(0xffFF0000),
        Color(0xff00FF00),
        Color(0xff0000FF),
        Color(0xffFFFF00),
        Color(0xffFF00FF),
      ]);

      var palette = palette1;
      late StateSetter outerSetState;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              outerSetState = setState;
              return DefaultBoringAvatarPalette(
                palette: palette,
                child: const BoringAvatar(name: 'inherited'),
              );
            },
          ),
        ),
      );

      final data1 = _findPainter(tester).avatarData;

      outerSetState(() => palette = palette2);
      await tester.pump();

      final data2 = _findPainter(tester).avatarData;

      expect(identical(data1, data2), isFalse,
          reason: 'data should regenerate when inherited palette changes');
    });
  });
}
