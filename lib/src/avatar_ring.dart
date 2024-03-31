import 'dart:math';
import 'package:flutter/material.dart';
import './utilities.dart';
import 'avatar_base.dart';
import 'package:flutter/foundation.dart';

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

class AvatarRingData {
  late List<Color> colorList;
  AvatarRingData({
    required this.colorList,
  });
  static lerp(AvatarRingData? a, AvatarRingData? b, double t) {
    final newColor = List.generate(
        max(a?.colorList.length ?? 0, b?.colorList.length ?? 0),
        (index) => Color.lerp(a?.colorList[index], b?.colorList[index], t)!);
    return AvatarRingData(colorList: newColor);
  }

  AvatarRingData.generate(String name, [List<Color>? colors]) {
    colors ??= defaultBoringAvatarsColors;
    final numFromName = getHashCode(name);
    final range = colors.length;
    final colorsShuffle = List.generate(
        5, (i) => getRandomColor<Color>(numFromName + (1 + i), colors!, range));
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
    if (other is AvatarRingData) {
      if (colorList.length != other.colorList.length) return false;
      int i = 0;
      return colorList.every((c) => c == other.colorList[i++]);
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll(colorList);
}

class AvatarRingPainter extends AvatarCustomPainter {
  final AvatarRingData properties;

  @override
  double get boxSize => 90;

  AvatarRingPainter(String name, [List<Color>? colors])
      : properties = AvatarRingData.generate(name, colors);

  AvatarRingPainter.data(this.properties);

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

class AvatarRingDataTween extends Tween<AvatarRingData?> {
  AvatarRingDataTween({AvatarRingData? begin, AvatarRingData? end})
      : super(begin: begin, end: end);
  @override
  AvatarRingData? lerp(double t) => AvatarRingData.lerp(begin, end, t);
}

class AnimatedAvatarRing extends ImplicitlyAnimatedWidget {
  AnimatedAvatarRing({
    Key? key,
    required this.name,
    this.colors,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
    this.size = Size.zero,
  })  : data = AvatarRingData.generate(name, colors),
        super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final String name;
  final List<Color>? colors;
  final AvatarRingData data;
  final Size size;

  @override
  AnimatedWidgetBaseState<AnimatedAvatarRing> createState() =>
      _AnimatedAvatarRingState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('name', name));
    properties.add(DiagnosticsProperty<List<Color>?>('colors', colors));
    properties.add(DiagnosticsProperty<AvatarRingData>('data', data));
    properties.add(DiagnosticsProperty<Size>('size', size));
  }
}

class _AnimatedAvatarRingState
    extends AnimatedWidgetBaseState<AnimatedAvatarRing> {
  AvatarRingDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data,
            (dynamic value) => AvatarRingDataTween(begin: value))
        as AvatarRingDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: AvatarRingPainter.data(_data!.evaluate(animation)!),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AvatarRingDataTween>('data', _data,
        defaultValue: null));
  }
}
