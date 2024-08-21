import 'package:flutter/material.dart';
import '../painter.dart';

class BoringAvatarCrossData extends BoringAvatarData {
  late BoringAvatarData begin;
  BoringAvatarData end;
  double t;

  BoringAvatarCrossData({
    required this.begin,
    required this.end,
    required this.t,
  });

  static BoringAvatarData mixed({
    required BoringAvatarData begin,
    required BoringAvatarData end,
    required double t,
  }) {
    if (begin is BoringAvatarCrossData) {
      begin = begin.t > 0.5 ? begin.end : begin.begin;
    }
    if (begin.runtimeType == end.runtimeType) {
      return begin.lerp(end, t);
    }
    return BoringAvatarCrossData(begin: begin, end: end, t: t);
  }

  BoringAvatarCrossData copyWith({
    BoringAvatarData? begin,
    BoringAvatarData? end,
    double? t,
  }) {
    return BoringAvatarCrossData(
      begin: begin ?? this.begin,
      end: end ?? this.end,
      t: t ?? this.t,
    );
  }

  BoringAvatarData lerp(BoringAvatarData end, double t) {
    if (t == 1) return end;
    return this.copyWith(end: end, t: t);
  }

  CustomPainter get painter {
    return BoringAvatarCrossPainter(this);
  }
}

class BoringAvatarCrossPainter extends AvatarCustomPainter {
  final BoringAvatarCrossData properties;

  @override
  double get boxSize => 80;

  BoringAvatarCrossPainter(this.properties);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;
    final p = properties;
    canvas.save();
    p.begin.painter.paint(canvas, size);
    canvas.saveLayer(
        Offset.zero & size, Paint()..color = Colors.white.withOpacity(p.t));
    p.end.painter.paint(canvas, size);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is BoringAvatarCrossPainter &&
        oldDelegate.properties != properties;
  }
}
