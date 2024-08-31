import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boring_avatars/src/painter/cross.dart';
import 'package:flutter_boring_avatars/src/palette.dart';
import 'painter.dart';
import 'inherited.dart';

class BoringAvatarCanvas extends StatelessWidget {
  final BoringAvatarData avatarData;
  final Widget? child;

  const BoringAvatarCanvas({super.key, required this.avatarData, this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      isComplex: true,
      painter: BoringAvatarCustomPainter(avatarData),
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<BoringAvatarData?>('avatarData', avatarData));
  }
}

class BoringAvatar extends StatelessWidget {
  final String name;

  final BoringAvatarType? type;

  final BoringAvatarPalette? palette;

  final ShapeBorder? shape;

  const BoringAvatar({
    super.key,
    required this.name,
    this.type,
    this.palette,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final palette = this.palette ??
        DefaultBoringAvatarPalette.maybeOf(context)?.palette ??
        BoringAvatarPalette.defaultPalette;
    final type = this.type ??
        DefaultBoringAvatarType.maybeOf(context)?.type ??
        BoringAvatarType.marble;
    return AspectRatio(
      aspectRatio: 1,
      child: BoringAvatarCanvas(
        avatarData: BoringAvatarData.generate(
          name: name,
          type: type,
          palette: palette,
          shape: shape,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('name', name));
    properties
        .add(DiagnosticsProperty<BoringAvatarPalette?>('palette', palette));
    properties.add(DiagnosticsProperty<BoringAvatarType?>('type', type));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape));
  }
}

class AnimatedBoringCanvas extends ImplicitlyAnimatedWidget {
  final BoringAvatarData avatarData;
  final Widget? child;

  const AnimatedBoringCanvas({
    super.key,
    required this.avatarData,
    required super.duration,
    this.child,
    super.curve,
    super.onEnd,
  });

  @override
  AnimatedWidgetBaseState<AnimatedBoringCanvas> createState() =>
      _AnimatedBoringCanvasState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<BoringAvatarData>('avatarData', avatarData));
    properties.add(DiagnosticsProperty<Curve>('curve', curve));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
    properties.add(DiagnosticsProperty<VoidCallback?>('onEnd', onEnd));
  }
}

class _AnimatedBoringCanvasState
    extends AnimatedWidgetBaseState<AnimatedBoringCanvas> {
  BoringAvatarDataTween? _avatarData;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _avatarData = visitor(_avatarData, widget.avatarData,
            (dynamic value) => BoringAvatarDataTween(begin: value))
        as BoringAvatarDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    final avatarData = _avatarData!.evaluate(animation);
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        size: Size.infinite,
        isComplex: true,
        painter: BoringAvatarCustomPainter(avatarData),
        child: widget.child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(
        DiagnosticsProperty<BoringAvatarDataTween>('avatarData', _avatarData));
  }
}

class BoringAvatarCustomPainter extends CustomPainter {
  final BoringAvatarData avatarData;

  BoringAvatarCustomPainter(this.avatarData);

  @override
  void paint(Canvas canvas, Size size) {
    avatarData.paint(canvas, Offset.zero & size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is BoringAvatarCustomPainter) {
      return avatarData != oldDelegate.avatarData;
    }
    return false;
  }
}

class AnimatedBoringAvatar extends StatelessWidget {
  final String name;

  final BoringAvatarType? type;

  final BoringAvatarPalette? palette;

  final Duration duration;

  final VoidCallback? onEnd;

  final Curve curve;

  final ShapeBorder? shape;

  final Widget? child;

  const AnimatedBoringAvatar({
    super.key,
    required this.name,
    required this.duration,
    this.child,
    this.curve = Curves.linear,
    this.onEnd,
    this.type,
    this.palette,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final palette = this.palette ??
        DefaultBoringAvatarPalette.maybeOf(context)?.palette ??
        BoringAvatarPalette.defaultPalette;
    final type = this.type ??
        DefaultBoringAvatarType.maybeOf(context)?.type ??
        BoringAvatarType.marble;
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBoringCanvas(
        avatarData: BoringAvatarData.generate(
          name: name,
          type: type,
          palette: palette,
          shape: shape,
        ),
        onEnd: onEnd,
        curve: curve,
        duration: duration,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('name', name));
    properties
        .add(DiagnosticsProperty<BoringAvatarPalette?>('palette', palette));
    properties.add(DiagnosticsProperty<BoringAvatarType?>('type', type));
    properties.add(DiagnosticsProperty<Curve>('curve', curve));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
    properties.add(DiagnosticsProperty<VoidCallback?>('onEnd', onEnd));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape));
  }
}

class BoringAvatarDecoration extends Decoration {
  final BoringAvatarData avatarData;

  const BoringAvatarDecoration({
    required this.avatarData,
  });

  @override
  bool get isComplex => true;

  @override
  BoringAvatarDecoration? lerpFrom(Decoration? a, double t) {
    assert(debugAssertIsValid());
    if (a is BoringAvatarDecoration) {
      if (avatarData.runtimeType != a.avatarData.runtimeType) {
        return BoringAvatarDecoration(
          avatarData: BoringAvatarCrossData.mixed(
              begin: a.avatarData, end: avatarData, t: t),
        );
      }
      return BoringAvatarDecoration(
        avatarData: a.avatarData.lerp(avatarData, t),
      );
    }
    return this;
  }

  @override
  BoringAvatarDecoration? lerpTo(Decoration? b, double t) {
    assert(debugAssertIsValid());
    if (b is BoringAvatarDecoration) {
      if (avatarData.runtimeType != b.avatarData.runtimeType) {
        return BoringAvatarDecoration(
          avatarData: BoringAvatarCrossData.mixed(
              begin: avatarData, end: b.avatarData, t: t),
        );
      }
      return BoringAvatarDecoration(
        avatarData: avatarData.lerp(b.avatarData, t),
      );
    }
    return this;
  }

  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) {
    return _BoringAvatarDecorationPainter(avatarData, onChanged);
  }
}

class _BoringAvatarDecorationPainter extends BoxPainter {
  BoringAvatarData data;

  _BoringAvatarDecorationPainter(this.data, [super.onChanged]);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    data.paint(canvas, offset & (configuration.size ?? Size.zero));
  }
}
