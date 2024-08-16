import 'dart:math';
import 'package:flutter/material.dart';
import '../utilities.dart';
import '../painter.dart';
import '../color_palette.dart';

const List<List<int>> _avatarPixelPos = [
  [0, 0],
  [2, 0],
  [4, 0],
  [6, 0],
  [1, 0],
  [3, 0],
  [5, 0],
  [7, 0],
  [0, 1],
  [0, 2],
  [0, 3],
  [0, 4],
  [0, 5],
  [0, 6],
  [0, 7],
  [2, 1],
  [2, 2],
  [2, 3],
  [2, 4],
  [2, 5],
  [2, 6],
  [2, 7],
  [4, 1],
  [4, 2],
  [4, 3],
  [4, 4],
  [4, 5],
  [4, 6],
  [4, 7],
  [6, 1],
  [6, 2],
  [6, 3],
  [6, 4],
  [6, 5],
  [6, 6],
  [6, 7],
  [1, 1],
  [1, 2],
  [1, 3],
  [1, 4],
  [1, 5],
  [1, 6],
  [1, 7],
  [3, 1],
  [3, 2],
  [3, 3],
  [3, 4],
  [3, 5],
  [3, 6],
  [3, 7],
  [5, 1],
  [5, 2],
  [5, 3],
  [5, 4],
  [5, 5],
  [5, 6],
  [5, 7],
  [7, 1],
  [7, 2],
  [7, 3],
  [7, 4],
  [7, 5],
  [7, 6],
  [7, 7]
];

class BoringAvatarPixelData extends BoringAvatarData {
  late List<Color> colorList;

  BoringAvatarPixelData({
    required this.colorList,
  });

  BoringAvatarPixelData.generate(
      {required String name,
      BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
      BoringAvatarHashCodeFunc getHashCode = boringAvatarHashCode}) {
    final numFromName = getHashCode(name);
    colorList =
        List.generate(64, (i) => palette.getColor(numFromName % (i + 13)));
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is BoringAvatarPixelData) {
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
    assert(end is BoringAvatarPixelData);
    final a = this;
    final b = end as BoringAvatarPixelData;
    final newColor = List.generate(max(a.colorList.length, b.colorList.length),
        (index) => Color.lerp(a.colorList[index], b.colorList[index], t)!);
    return BoringAvatarPixelData(colorList: newColor);
  }

  @override
  CustomPainter get painter => AvatarPixelPainter(this);
}

class AvatarPixelPainter extends AvatarCustomPainter {
  final BoringAvatarPixelData properties;

  @override
  double get boxSize => 64;

  AvatarPixelPainter(this.properties);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    int i = 0;
    final itemWidth = size.width / 8;
    final itemHeight = size.height / 8;
    for (var color in properties.colorList) {
      final pos = _avatarPixelPos[i++];
      final x = pos[0];
      final y = pos[1];
      canvas.drawRect(
          Rect.fromLTWH(itemWidth * x, itemHeight * y, itemWidth, itemHeight),
          fillPaint(color));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is AvatarPixelPainter &&
        oldDelegate.properties != properties;
  }
}
