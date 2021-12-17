import 'package:flutter/material.dart';
import './utilities.dart';
import 'dart:ui';
import 'avatar_base.dart';
import 'package:flutter/foundation.dart';

class AvatarMarbleData {
  late List<AvatarMarbleDataItem> elements;
  AvatarMarbleData({ required this.elements });
  static AvatarMarbleData? lerp(AvatarMarbleData? a, AvatarMarbleData? b, double t) {
    a ??= AvatarMarbleData.generate('');
    b ??= AvatarMarbleData.generate('');
    return AvatarMarbleData(
      elements: [
        AvatarMarbleDataItem.lerp(a.elements[0], b.elements[0], t)!,
        AvatarMarbleDataItem.lerp(a.elements[1], b.elements[1], t)!,
        AvatarMarbleDataItem.lerp(a.elements[2], b.elements[2], t)!,
      ],
    );
  }

  AvatarMarbleData.generate(String name, [List<Color>? colors]) {
    colors ??= defaultBoringAvatarsColors;
    const double boxSize = 80;
    final numFromName = getNumber(name);
    final range = colors.length;
    final elementsProperties = List.generate(
        3,
        (i) => AvatarMarbleDataItem(
              color: getRandomColor(numFromName + i, colors!, range),
              translateX:
                  getUnit(numFromName * (i + 1), boxSize ~/ 10, 1).toDouble(),
              translateY:
                  getUnit(numFromName * (i + 1), boxSize ~/ 10, 2).toDouble(),
              scale: 1.2 + getUnit(numFromName * (i + 1), boxSize ~/ 20) / 10,
              rotate: getUnit(numFromName * (i + 1), 360, 1).toDouble(),
            ));
    elements = elementsProperties;
  }
}

class AvatarMarbleDataItem {
  Color color;
  double translateX;
  double translateY;
  double rotate;     
  double scale;
  AvatarMarbleDataItem({
    required this.color,
    required this.translateX,
    required this.translateY,
    required this.rotate,
    required this.scale,
  });

  static AvatarMarbleDataItem? lerp(AvatarMarbleDataItem? a, AvatarMarbleDataItem? b, double t) {
    assert(a != null);
    assert(b != null);
    return AvatarMarbleDataItem(
      color: Color.lerp(a!.color, b!.color, t)!,
      translateX: lerpDouble(a.translateX, b.translateX, t),
      translateY: lerpDouble(a.translateY, b.translateY, t), 
      rotate: lerpDouble(a.rotate, b.rotate, t), 
      scale: lerpDouble(a.scale, b.scale, t), 
    );
  }

}

class AvatarMarblePainter extends AvatarCustomPainter {
  final AvatarMarbleData propertie;

  static const int elements = 3;
  @override
  double get boxSize => 80;

  AvatarMarblePainter(String name, [List<Color>? colors])
      : propertie = AvatarMarbleData.generate(name, colors);

  AvatarMarblePainter.data(this.propertie);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    final p0 = propertie.elements[0];
    final p1 = propertie.elements[1];
    final p2 = propertie.elements[2];
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final blur = MaskFilter.blur(
      BlurStyle.normal,
      7 * (size.width / boxSize),
    );

    Paint paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = p0.color;

    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paintFill);

    final path1 = svgPath("M32.414 59.35L50.376 70.5H72.5v-71H33.728L26.5 13.381l19.057 27.08L32.414 59.35z",
        rotate: p1.rotate,
        scale: p1.scale,
        transformX: p1.translateX,
        transformY: p1.translateY);

    Paint paintFill1 = Paint()
      ..style = PaintingStyle.fill
      ..color = p1.color
      ..maskFilter = blur;
    canvas.drawPath(path1, paintFill1);

    final path2 = svgPath("M22.216 24L0 46.75l14.108 38.129L78 86l-3.081-59.276-22.378 4.005 12.972 20.186-23.35 27.395L22.215 24z",
        rotate: p1.rotate,
        scale: p2.scale,
        transformX: p2.translateX,
        transformY: p2.translateY);
    final paintFill2 = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay
      ..color = p2.color
      ..maskFilter = blur;

    canvas.drawPath(path2, paintFill2);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AvatarMarbleDataTween extends Tween<AvatarMarbleData?> {
  AvatarMarbleDataTween({ AvatarMarbleData? begin, AvatarMarbleData? end }) : super(begin: begin, end: end);
  @override
  AvatarMarbleData? lerp(double t) => AvatarMarbleData.lerp(begin, end, t);
}

class AnimatedAvatarMarble extends ImplicitlyAnimatedWidget {
  AnimatedAvatarMarble({
    Key? key,
    required this.name,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  }): data = AvatarMarbleData.generate(name), super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final String name;
  final AvatarMarbleData data;

  @override
  AnimatedWidgetBaseState<AnimatedAvatarMarble> createState() => _AnimatedAvatarMarbleState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('name', name));
    properties.add(DiagnosticsProperty<AvatarMarbleData>('data', data));
  }
}

class _AnimatedAvatarMarbleState extends AnimatedWidgetBaseState<AnimatedAvatarMarble> {
  AvatarMarbleDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data, (dynamic value) => AvatarMarbleDataTween(begin: value)) as AvatarMarbleDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: AvatarMarblePainter.data(_data!.evaluate(animation)!),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AvatarMarbleDataTween>('data', _data, defaultValue: null));
  }
}
