// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import './utilities.dart';
import 'dart:ui';
import 'avatar_base.dart';

const List<List<int>> _avatarPixelPos = [[0,0],[2,0],[4,0],[6,0],[1,0],[3,0],[5,0],[7,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],[2,1],[2,2],[2,3],[2,4],[2,5],[2,6],[2,7],[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[4,7],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[3,1],[3,2],[3,3],[3,4],[3,5],[3,6],[3,7],[5,1],[5,2],[5,3],[5,4],[5,5],[5,6],[5,7],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7]];
class AvatarPixelData {
  Color color;
  AvatarPixelData({
    required this.color,
  });
}

class AvatarPixelPainter extends AvatarCustomPainter {
  final String name;
  final List<Color> colors;
  final List<AvatarPixelData> properties;

  @override
  double get boxSize => 64;

  AvatarPixelPainter(this.name, this.colors)
      : properties = generate(name, colors);

  static List<AvatarPixelData> generate(String name, List<Color> colors) {
    final numFromName = getNumber(name);
    final range = colors.length;
    final elementsProperties = List.generate(
        64,
        (i) => AvatarPixelData(
              color:
                  getRandomColor<Color>(numFromName % (i + 13), colors, range),
            ));
    return elementsProperties;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    int i = 0;
    final itemWidth = size.width / 8;
    final itemHeight = size.height / 8;
    for (var p in properties) {
      final pos = _avatarPixelPos[i++];
      final x = pos[0];
      final y = pos[1];
      canvas.drawRect(Rect.fromLTWH(itemWidth * x, itemHeight * y, itemWidth, itemHeight), fillPaint(p.color));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
