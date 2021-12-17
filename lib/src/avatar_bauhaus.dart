import 'dart:math';

import 'package:flutter/material.dart';
import './utilities.dart';
import 'dart:ui';
import 'avatar_base.dart';
import 'package:flutter/foundation.dart';

class AvatarBauhausDataItem {
  Color color;
  double translateX;
  double translateY;
  double rotate;
  double height;
  bool isSquare;
  AvatarBauhausDataItem({
    required this.color,
    required this.translateX,
    required this.translateY,
    required this.rotate,
    required this.isSquare,
    required this.height,
  });
  static AvatarBauhausDataItem? lerp(AvatarBauhausDataItem? a, AvatarBauhausDataItem? b, double t) {
    assert(a != null);
    assert(b != null);
    return AvatarBauhausDataItem(
      color: Color.lerp(a!.color, b!.color, t)!,
      translateX: lerpDouble(a.translateX, b.translateX, t),
      translateY: lerpDouble(a.translateY, b.translateY, t), 
      rotate: lerpDouble(a.rotate, b.rotate, t), 
      height: lerpDouble(a.height, b.height, t), 
      isSquare: t >= 0.5 ? b.isSquare : a.isSquare
    );
  }
}

class AvatarBauhausData {
  
  late List<AvatarBauhausDataItem> elements;

  AvatarBauhausData({
    required this.elements
  });

  AvatarBauhausData.generate(String name, [List<Color>? colors]) {
    colors ??= defaultBoringAvatarsColors;
    const double boxSize = 80;
      final numFromName = getNumber(name);
  final range = colors.length;
  final isSquare = getBoolean(numFromName, 2);
  elements = List.generate(
      4,
      (i) => AvatarBauhausDataItem(
          color: getRandomColor(numFromName + i, colors!, range),
          translateX: getUnit(numFromName * (i + 1), boxSize ~/ 2 - (i + 17), 1).toDouble(),
          translateY: getUnit(numFromName * (i + 1), boxSize ~/ 2 - (i + 17), 2).toDouble(),
          rotate: getUnit(numFromName * (i + 1), 360).toDouble(),
          isSquare: isSquare,
          height: isSquare ? boxSize : boxSize / 8,
          ));
  }

  static AvatarBauhausData? lerp(AvatarBauhausData? a, AvatarBauhausData? b, double t) {
    assert(a != null);
    assert(b != null);
    a ??= AvatarBauhausData.generate('');
    b ??= AvatarBauhausData.generate('');
    return AvatarBauhausData(elements: [
      AvatarBauhausDataItem.lerp(a.elements[0], b.elements[0], t)!,
      AvatarBauhausDataItem.lerp(a.elements[1], b.elements[1], t)!,
      AvatarBauhausDataItem.lerp(a.elements[2], b.elements[2], t)!,
      AvatarBauhausDataItem.lerp(a.elements[3], b.elements[3], t)!,
    ]);
  }
}

class AvatarBauhausPainter extends AvatarCustomPainter {
  final AvatarBauhausData propertie;

  @override
  double get boxSize => 80;

  AvatarBauhausPainter(String name, List<Color>? colors)
      : propertie = AvatarBauhausData.generate(name, colors);

  AvatarBauhausPainter.data(this.propertie);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    final p0 = propertie.elements[0];
    final p1 = propertie.elements[1];
    final p2 = propertie.elements[2];
    final p3 = propertie.elements[3];

    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), fillPaint(p0.color));

    final t1 = getTransform(translateX: p1.translateX, translateY: p1.translateY, rotate: p1.rotate);
    canvas.transform(t1.storage);
    canvas.drawRect(getRectFromLTWH(( boxSize - 60 ) / 2, ( boxSize - 20 ) / 2, boxSize, p1.height), fillPaint(p1.color));
    t1.invert();
    canvas.transform(t1.storage);

    final t2 = getTransform(translateX: p2.translateX, translateY: p2.translateY);
    canvas.transform(t2.storage);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 5, fillPaint(p2.color));
    t2.invert();
    canvas.transform(t2.storage);

    final t3 = getTransform(translateX: p3.translateX, translateY: p3.translateY, rotate: p3.rotate);
    canvas.transform(t3.storage);
    canvas.drawLine(Offset(0, size.width / 2), Offset(size.height, size.height / 2), strokePaint(p3.color, 2));
    t3.invert();
    canvas.transform(t3.storage);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AvatarBauhausDataTween extends Tween<AvatarBauhausData?> {
  AvatarBauhausDataTween({ AvatarBauhausData? begin, AvatarBauhausData? end }) : super(begin: begin, end: end);
  @override
  AvatarBauhausData? lerp(double t) => AvatarBauhausData.lerp(begin, end, t);
}

class AnimatedAvatarBauhaus extends ImplicitlyAnimatedWidget {
  AnimatedAvatarBauhaus({
    Key? key,
    required this.name,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  }): data = AvatarBauhausData.generate(name), super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final String name;
  final AvatarBauhausData data;

  @override
  AnimatedWidgetBaseState<AnimatedAvatarBauhaus> createState() => _AnimatedAvatarBauhausState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('name', name));
    properties.add(DiagnosticsProperty<AvatarBauhausData>('data', data));
  }
}

class _AnimatedAvatarBauhausState extends AnimatedWidgetBaseState<AnimatedAvatarBauhaus> {
  AvatarBauhausDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data, (dynamic value) => AvatarBauhausDataTween(begin: value)) as AvatarBauhausDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: AvatarBauhausPainter.data(_data!.evaluate(animation)!),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AvatarBauhausDataTween>('data', _data, defaultValue: null));
  }
}
