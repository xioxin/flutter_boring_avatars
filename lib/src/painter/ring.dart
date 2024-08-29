import 'dart:math';
import 'package:flutter/material.dart';
import '../utilities.dart';
import '../painter.dart';
import '../palette.dart';

final List<Path> _avatarRingPathList = [
  Path()
    ..moveTo(0, 0) // M0 0
    ..relativeLineTo(90, 0) // h90
    ..relativeLineTo(0, 45) //v45
    ..lineTo(0, 45) // H0
    ..close(), // z
  Path()
    ..moveTo(0, 45) // M0 45
    ..relativeLineTo(90, 0) // h90
    ..relativeLineTo(0, 45) //v45
    ..lineTo(0, 90) // H0
    ..close(), // z
  Path()
    ..moveTo(83, 45) // M83 45
    ..arcTo(Rect.fromCircle(center: const Offset(45, 45), radius: 38), 0, -pi, false)
    ..close(), // z
  Path()
    ..moveTo(83, 45) // M83 45
    ..arcTo(
        Rect.fromCircle(center: const Offset(45, 45), radius: 38), 0, pi, false)
    ..close(), // z
  Path()
    ..moveTo(77, 45) // M77 45
    ..arcTo(Rect.fromCircle(center: const Offset(45, 45), radius: 32), 0, -pi, false)
    ..close(), // z
  Path()
    ..moveTo(77, 45) // M77 45
    ..arcTo(
        Rect.fromCircle(center: const Offset(45, 45), radius: 32), 0, pi, false)
    ..close(), // z
  Path()
    ..moveTo(71, 45) // M71 45
    ..arcTo(Rect.fromCircle(center: const Offset(45, 45), radius: 26), 0, -pi, false)
    ..close(), // z
  Path()
    ..moveTo(71, 45) // M71 45
    ..arcTo(
        Rect.fromCircle(center: const Offset(45, 45), radius: 26), 0, pi, false)
    ..close(), // z
];

class BoringAvatarRingData extends BoringAvatarData {
  late List<Color> colorList;

  BoringAvatarRingData({
    required this.colorList,
  });

  BoringAvatarRingData.generate(
      {required String name,
      BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
      BoringAvatarHashCodeFunc getHashCode = boringAvatarHashCode}) {
    final numFromName = getHashCode(name);
    final colorsShuffle =
        List.generate(5, (i) => palette.getColor(numFromName + i ));
    colorList = [
      colorsShuffle[0],
      colorsShuffle[1],
      colorsShuffle[1],
      colorsShuffle[2],
      colorsShuffle[2],
      colorsShuffle[3],
      colorsShuffle[3],
      colorsShuffle[0],
      colorsShuffle[4],
    ];
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is BoringAvatarRingData) {
      if (colorList.length != other.colorList.length) return false;
      int i = 0;
      return colorList.every((c) => c == other.colorList[i++]);
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll(colorList);

  @override
  BoringAvatarData lerp(BoringAvatarData end, double t) {
    assert(end is BoringAvatarRingData);
    final a = this;
    final b = end as BoringAvatarRingData;
    final newColor = List.generate(max(a.colorList.length, b.colorList.length),
        (index) => Color.lerp(a.colorList[index], b.colorList[index], t)!);
    return BoringAvatarRingData(colorList: newColor);
  }

  @override
  CustomPainter get painter => AvatarRingPainter(this);
}

class AvatarRingPainter extends AvatarCustomPainter {
  final BoringAvatarRingData properties;

  @override
  double get boxSize => 90;

  AvatarRingPainter(this.properties);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    int i = 0;
    final scaleX = size.width / boxSize;
    final scaleY = size.height / boxSize;
    final resizeTransform = Matrix4.identity()..scale(scaleX, scaleY);

    for (var path in _avatarRingPathList) {
      final color = properties.colorList[i++];
      canvas.drawPath(
        path.transform(resizeTransform.storage),
        fillPaint(color),
      );
    }

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), cX(23),
        fillPaint(properties.colorList.last));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is AvatarRingPainter &&
        oldDelegate.properties != properties;
  }
}
