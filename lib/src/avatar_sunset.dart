import 'dart:math';
import 'package:flutter/material.dart';
import './utilities.dart';
import 'dart:ui';
import 'avatar_base.dart';
import 'package:flutter/foundation.dart';

class AvatarSunsetData {
  late List<Color> colorList;
  AvatarSunsetData({
    required this.colorList,
  });
  static lerp(AvatarSunsetData? a, AvatarSunsetData? b, double t) {
    final newColor = List.generate(max(a?.colorList.length ?? 0, b?.colorList.length ?? 0), (index) => Color.lerp(a?.colorList[index], b?.colorList[index], t)!);
    return AvatarSunsetData(colorList: newColor);
  }
  AvatarSunsetData.generate(String name, [List<Color>? colors]) {
    colors ??= defaultBoringAvatarsColors;
    final numFromName = getNumber(name);
    final range = colors.length;
    colorList = List.generate(
        4,
        (i) => getRandomColor<Color>(numFromName + i, colors!, range));
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is AvatarSunsetData) {
      if(colorList.length != other.colorList.length) return false;
      int i = 0;
      return colorList.every((c) => c == other.colorList[i++]);
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll(colorList);
}

class AvatarSunsetPainter extends AvatarCustomPainter {
  final AvatarSunsetData properties;

  @override
  double get boxSize => 80;

  AvatarSunsetPainter(String name, [List<Color>? colors])
      : properties = AvatarSunsetData.generate(name, colors);
  AvatarSunsetPainter.data(this.properties);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    final p0 = properties.colorList[0];
    final p1 = properties.colorList[1];
    final p2 = properties.colorList[2];
    final p3 = properties.colorList[3];
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final rect1 = Rect.fromLTWH(0, 0, size.width, size.height / 2);
    final paint1 = Paint()
      ..shader = LinearGradient(
              colors: [ p0, p1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
          .createShader(rect1);
    canvas.drawRect(rect1, paint1);

    final rect2 = Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2);
    final paint2 = Paint()
      ..shader = LinearGradient(
              colors: [p2, p3],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
          .createShader(rect2);
    canvas.drawRect(rect2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is AvatarSunsetPainter && oldDelegate.properties != properties;
  }
}

class AvatarSunsetDataTween extends Tween<AvatarSunsetData?> {
  AvatarSunsetDataTween({ AvatarSunsetData? begin, AvatarSunsetData? end }) : super(begin: begin, end: end);
  @override
  AvatarSunsetData? lerp(double t) => AvatarSunsetData.lerp(begin, end, t);
}

class AnimatedAvatarSunset extends ImplicitlyAnimatedWidget {
  AnimatedAvatarSunset({
    Key? key,
    required this.name,
    this.colors,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
    this.size = Size.zero,
  }): data = AvatarSunsetData.generate(name, colors), super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final String name;
  final List<Color>? colors;
  final AvatarSunsetData data;
  final Size size;

  @override
  AnimatedWidgetBaseState<AnimatedAvatarSunset> createState() => _AnimatedAvatarSunsetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('name', name));
    properties.add(DiagnosticsProperty<List<Color>?>('colors', colors));
    properties.add(DiagnosticsProperty<AvatarSunsetData>('data', data));
    properties.add(DiagnosticsProperty<Size>('size', size));
  }
}

class _AnimatedAvatarSunsetState extends AnimatedWidgetBaseState<AnimatedAvatarSunset> {
  AvatarSunsetDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data, (dynamic value) => AvatarSunsetDataTween(begin: value)) as AvatarSunsetDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: AvatarSunsetPainter.data(_data!.evaluate(animation)!),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AvatarSunsetDataTween>('data', _data, defaultValue: null));
  }
}
