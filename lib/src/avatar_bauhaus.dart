import 'package:flutter/material.dart';
import './utilities.dart';
import 'avatar_base.dart';
import 'package:flutter/foundation.dart';

class AvatarBauhausData {
  late Color bgColor;
  late double element1TranslateX;
  late double element1TranslateY;
  late Color element1Color;
  late double element1Rotate;
  late double element1Height;
  late double element2TranslateX;
  late double element2TranslateY;
  late Color element2Color;
  late double element3TranslateX;
  late double element3TranslateY;
  late Color element3Color;
  late double element3Rotate;
  AvatarBauhausData({
    required this.bgColor,
    required this.element1TranslateX,
    required this.element1TranslateY,
    required this.element1Color,
    required this.element1Rotate,
    required this.element1Height,
    required this.element2TranslateX,
    required this.element2TranslateY,
    required this.element2Color,
    required this.element3TranslateX,
    required this.element3TranslateY,
    required this.element3Color,
    required this.element3Rotate,
  });

  AvatarBauhausData.generate(String name, [List<Color>? colors]) {
    colors ??= defaultBoringAvatarsColors;
    const double boxSize = 80;
    final numFromName = getHashCode(name);
    final range = colors.length;
    final isSquare = getBoolean(numFromName, 2);
    int i = 0;
    bgColor = getRandomColor(numFromName, colors, range);

    i = 1;
    element1Color = getRandomColor(numFromName + i, colors, range);
    element1TranslateX =
        getUnit(numFromName * (i + 1), boxSize ~/ 2 - (i + 17), 1);
    element1TranslateY =
        getUnit(numFromName * (i + 1), boxSize ~/ 2 - (i + 17), 2);
    element1Rotate = getUnit(numFromName * (i + 1), 360);
    element1Height = isSquare ? boxSize : boxSize / 8;

    i = 2;
    element2Color = getRandomColor(numFromName + i, colors, range);
    element2TranslateX =
        getUnit(numFromName * (i + 1), boxSize ~/ 2 - (i + 17), 1);
    element2TranslateY =
        getUnit(numFromName * (i + 1), boxSize ~/ 2 - (i + 17), 2);

    i = 3;
    element3Color = getRandomColor(numFromName + i, colors, range);
    element3TranslateX =
        getUnit(numFromName * (i + 1), boxSize ~/ 2 - (i + 17), 1);
    element3TranslateY =
        getUnit(numFromName * (i + 1), boxSize ~/ 2 - (i + 17), 2);
    element3Rotate = getUnit(numFromName * (i + 1), 360);
  }

  static AvatarBauhausData? lerp(
      AvatarBauhausData? a, AvatarBauhausData? b, double t) {
    a ??= AvatarBauhausData.generate('');
    b ??= AvatarBauhausData.generate('');
    return AvatarBauhausData(
        bgColor: Color.lerp(a.bgColor, b.bgColor, t)!,
        element1TranslateX:
            lerpDouble(a.element1TranslateX, b.element1TranslateX, t),
        element1TranslateY:
            lerpDouble(a.element1TranslateY, b.element1TranslateY, t),
        element1Color: Color.lerp(a.element1Color, b.element1Color, t)!,
        element1Rotate: lerpRotate(a.element1Rotate, b.element1Rotate, t),
        element1Height: lerpDouble(a.element1Height, b.element1Height, t),
        element2TranslateX:
            lerpDouble(a.element2TranslateX, b.element2TranslateX, t),
        element2TranslateY:
            lerpDouble(a.element2TranslateY, b.element2TranslateY, t),
        element2Color: Color.lerp(a.element2Color, b.element2Color, t)!,
        element3TranslateX:
            lerpDouble(a.element3TranslateX, b.element3TranslateX, t),
        element3TranslateY:
            lerpDouble(a.element3TranslateY, b.element3TranslateY, t),
        element3Color: Color.lerp(a.element3Color, b.element3Color, t)!,
        element3Rotate: lerpRotate180(a.element3Rotate, b.element3Rotate, t));
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is AvatarBauhausData) {
      return bgColor == other.bgColor &&
          element1TranslateX == other.element1TranslateX &&
          element1TranslateY == other.element1TranslateY &&
          element1Color == other.element1Color &&
          element1Rotate == other.element1Rotate &&
          element1Height == other.element1Height &&
          element2TranslateX == other.element2TranslateX &&
          element2TranslateY == other.element2TranslateY &&
          element2Color == other.element2Color &&
          element3TranslateX == other.element3TranslateX &&
          element3TranslateY == other.element3TranslateY &&
          element3Color == other.element3Color &&
          element3Rotate == other.element3Rotate;
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll([
        bgColor,
        element1TranslateX,
        element1TranslateY,
        element1Color,
        element1Rotate,
        element1Height,
        element2TranslateX,
        element2TranslateY,
        element2Color,
        element3TranslateX,
        element3TranslateY,
        element3Color,
        element3Rotate,
      ]);
}

class AvatarBauhausPainter extends AvatarCustomPainter {
  final AvatarBauhausData properties;

  @override
  double get boxSize => 80;

  AvatarBauhausPainter(String name, List<Color>? colors)
      : properties = AvatarBauhausData.generate(name, colors);

  AvatarBauhausPainter.data(this.properties);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    final p = properties;

    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, size.height), fillPaint(p.bgColor));

    final t1 = getTransform(
        translateX: p.element1TranslateX,
        translateY: p.element1TranslateY,
        rotate: p.element1Rotate);
    canvas.transform(t1.storage);
    canvas.drawRect(
        getRectFromLTWH(
            (boxSize - 60) / 2, (boxSize - 20) / 2, boxSize, p.element1Height),
        fillPaint(p.element1Color));
    t1.invert();
    canvas.transform(t1.storage);

    final t2 = getTransform(
        translateX: p.element2TranslateX, translateY: p.element2TranslateY);
    canvas.transform(t2.storage);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 5,
        fillPaint(p.element2Color));
    t2.invert();
    canvas.transform(t2.storage);

    final t3 = getTransform(
        translateX: p.element3TranslateX,
        translateY: p.element3TranslateY,
        rotate: p.element3Rotate);
    canvas.transform(t3.storage);
    canvas.drawLine(Offset(0, size.width / 2),
        Offset(size.height, size.height / 2), strokePaint(p.element3Color, 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is AvatarBauhausPainter &&
        oldDelegate.properties != properties;
  }
}

class AvatarBauhausDataTween extends Tween<AvatarBauhausData?> {
  AvatarBauhausDataTween({AvatarBauhausData? begin, AvatarBauhausData? end})
      : super(begin: begin, end: end);

  @override
  AvatarBauhausData? lerp(double t) => AvatarBauhausData.lerp(begin, end, t);
}

class AnimatedAvatarBauhaus extends ImplicitlyAnimatedWidget {
  AnimatedAvatarBauhaus({
    Key? key,
    required this.name,
    this.colors,
    Curve curve = Curves.linear,
    required Duration duration,
    this.size = Size.zero,
    VoidCallback? onEnd,
  })  : data = AvatarBauhausData.generate(name, colors),
        super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final String name;
  final List<Color>? colors;
  final Size size;
  final AvatarBauhausData data;

  @override
  AnimatedWidgetBaseState<AnimatedAvatarBauhaus> createState() =>
      _AnimatedAvatarBauhausState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('name', name));
    properties.add(DiagnosticsProperty<List<Color>?>('colors', colors));
    properties.add(DiagnosticsProperty<AvatarBauhausData>('data', data));
    properties.add(DiagnosticsProperty<Size>('size', size));
  }
}

class _AnimatedAvatarBauhausState
    extends AnimatedWidgetBaseState<AnimatedAvatarBauhaus> {
  AvatarBauhausDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data,
            (dynamic value) => AvatarBauhausDataTween(begin: value))
        as AvatarBauhausDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: AvatarBauhausPainter.data(_data!.evaluate(animation)!),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AvatarBauhausDataTween>('data', _data,
        defaultValue: null));
  }
}
