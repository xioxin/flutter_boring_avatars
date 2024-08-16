import 'dart:math';
import 'package:flutter/material.dart';
import '../utilities.dart';
import '../painter.dart';
import '../palette.dart';

const List<String> _avatarRingPath = [
  'M0 0h90v45H0z',
  'M0 45h90v45H0z',
  'M83 45a38 38 0 00-76 0h76z',
  'M83 45a38 38 0 01-76 0h76z',
  'M77 45a32 32 0 10-64 0h64z',
  'M77 45a32 32 0 11-64 0h64z',
  'M71 45a26 26 0 00-52 0h52z',
  'M71 45a26 26 0 01-52 0h52z',
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
        List.generate(5, (i) => palette.getColor(numFromName + i + 1));
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
    for (var pathString in _avatarRingPath) {
      final color = properties.colorList[i++];
      canvas.drawPath(svgPath(pathString), fillPaint(color));
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
