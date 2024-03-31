import 'dart:math';

import 'package:flutter/material.dart';
import './utilities.dart';
import 'avatar_base.dart';
import 'package:flutter/foundation.dart';

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

class AvatarPixelData {
  late List<Color> colorList;
  AvatarPixelData({
    required this.colorList,
  });
  static lerp(AvatarPixelData? a, AvatarPixelData? b, double t) {
    final newColor = List.generate(
        max(a?.colorList.length ?? 0, b?.colorList.length ?? 0),
        (index) => Color.lerp(a?.colorList[index], b?.colorList[index], t)!);
    return AvatarPixelData(colorList: newColor);
  }

  AvatarPixelData.generate(String name, [List<Color>? colors]) {
    colors ??= defaultBoringAvatarsColors;
    final numFromName = getHashCode(name);
    final range = colors.length;
    colorList = List.generate(64,
        (i) => getRandomColor<Color>(numFromName % (i + 13), colors!, range));
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is AvatarPixelData) {
      if (colorList.length != other.colorList.length) return false;
      int i = 0;
      return colorList.every((c) => c == other.colorList[i++]);
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll(colorList);
}

class AvatarPixelPainter extends AvatarCustomPainter {
  final AvatarPixelData properties;

  @override
  double get boxSize => 64;

  AvatarPixelPainter(String name, [List<Color>? colors])
      : properties = AvatarPixelData.generate(name, colors);

  AvatarPixelPainter.data(this.properties);

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

class AvatarPixelDataTween extends Tween<AvatarPixelData?> {
  AvatarPixelDataTween({AvatarPixelData? begin, AvatarPixelData? end})
      : super(begin: begin, end: end);
  @override
  AvatarPixelData? lerp(double t) => AvatarPixelData.lerp(begin, end, t);
}

class AnimatedAvatarPixel extends ImplicitlyAnimatedWidget {
  AnimatedAvatarPixel({
    Key? key,
    required this.name,
    this.colors,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
    this.size = Size.zero,
  })  : data = AvatarPixelData.generate(name, colors),
        super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final String name;
  final List<Color>? colors;
  final AvatarPixelData data;
  final Size size;

  @override
  AnimatedWidgetBaseState<AnimatedAvatarPixel> createState() =>
      _AnimatedAvatarPixelState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('name', name));
    properties.add(DiagnosticsProperty<List<Color>?>('colors', colors));
    properties.add(DiagnosticsProperty<AvatarPixelData>('data', data));
    properties.add(DiagnosticsProperty<Size>('size', size));
  }
}

class _AnimatedAvatarPixelState
    extends AnimatedWidgetBaseState<AnimatedAvatarPixel> {
  AvatarPixelDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data,
            (dynamic value) => AvatarPixelDataTween(begin: value))
        as AvatarPixelDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: AvatarPixelPainter.data(_data!.evaluate(animation)!),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AvatarPixelDataTween>('data', _data,
        defaultValue: null));
  }
}
