import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boring_avatars/src/painter/cross.dart';
import 'package:flutter_boring_avatars/src/palette.dart';
import 'painter.dart';
import 'inherited.dart';

/// A widget that draws a boring avatar on a canvas.
class BoringAvatarCanvas extends StatelessWidget {
  /// The data used to draw the avatar.
  final BoringAvatarData avatarData;
  final Widget? child;

  /// Creates a [BoringAvatarCanvas] widget.
  const BoringAvatarCanvas({super.key, required this.avatarData, this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: avatarData.painter,
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

/// A widget that displays a boring avatar.
class BoringAvatar extends StatelessWidget {
  /// The name used to generate the avatar.
  final String name;

  /// The type of the avatar.
  final BoringAvatarType? type;

  /// The color palette used for the avatar.
  final BoringAvatarPalette? palette;

  /// The shape of the avatar.
  final ShapeBorder? shape;

  /// The clip behavior of the avatar.
  final Clip clipBehavior;

  /// Creates a [BoringAvatar] widget.
  const BoringAvatar({
    super.key,
    required this.name,
    this.type,
    this.palette,
    this.shape,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final palette = this.palette ??
        DefaultBoringAvatarPalette.maybeOf(context)?.palette ??
        BoringAvatarPalette.defaultPalette;
    final type = this.type ??
        DefaultBoringAvatarType.maybeOf(context)?.type ??
        BoringAvatarType.marble;
    final avatarData =
        BoringAvatarData.generate(name: name, type: type, palette: palette);
    final avatar = AspectRatio(
      aspectRatio: 1,
      child: BoringAvatarCanvas(avatarData: avatarData),
    );
    if (shape != null) {
      return Material(
        shape: shape,
        clipBehavior: clipBehavior,
        child: avatar,
      );
    }
    return RepaintBoundary(child: avatar);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('name', name));
    properties
        .add(DiagnosticsProperty<BoringAvatarPalette?>('palette', palette));
    properties.add(DiagnosticsProperty<BoringAvatarType?>('type', type));
    properties.add(DiagnosticsProperty<ShapeBorder>('shape', shape));
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior));
  }
}

/// A widget that animates a boring avatar canvas.
class AnimatedBoringCanvas extends ImplicitlyAnimatedWidget {
  /// The data used to draw the avatar.
  final BoringAvatarData avatarData;
  final Widget? child;

  /// Creates an [AnimatedBoringCanvas] widget.
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
        painter: avatarData.painter,
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

/// A widget that displays an animated boring avatar.
class AnimatedBoringAvatar extends StatelessWidget {
  /// The name used to generate the avatar.
  final String name;

  /// The type of the avatar.
  final BoringAvatarType? type;

  /// The color palette used for the avatar.
  final BoringAvatarPalette? palette;

  /// The duration of the animation.
  final Duration duration;

  /// The callback to be called when the animation ends.
  final VoidCallback? onEnd;

  /// The curve of the animation.
  final Curve curve;

  /// The shape of the avatar.
  final ShapeBorder? shape;

  /// The clip behavior of the avatar.
  final Clip clipBehavior;

  final Widget? child;

  /// Creates an [AnimatedBoringAvatar] widget.
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
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final palette = this.palette ??
        DefaultBoringAvatarPalette.maybeOf(context)?.palette ??
        BoringAvatarPalette.defaultPalette;
    final type = this.type ??
        DefaultBoringAvatarType.maybeOf(context)?.type ??
        BoringAvatarType.marble;
    final avatarData =
        BoringAvatarData.generate(name: name, type: type, palette: palette);
    final avatar = AspectRatio(
      aspectRatio: 1,
      child: AnimatedBoringCanvas(
        avatarData: avatarData,
        onEnd: onEnd,
        curve: curve,
        duration: duration,
        child: child,
      ),
    );
    if (shape != null) {
      return Material(
        shape: shape,
        clipBehavior: clipBehavior,
        child: avatar,
      );
    }
    return avatar;
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
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior));
  }
}

/// A decoration that draws a boring avatar.
class BoringAvatarDecoration extends Decoration {
  /// The data used to draw the avatar.
  final BoringAvatarData avatarData;

  /// Creates a [BoringAvatarDecoration] widget.
  const BoringAvatarDecoration({
    required this.avatarData,
  });

  @override
  bool get isComplex => false;

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
    return _BoringAvatarDecorationPainter(avatarData.painter, onChanged);
  }
}

class _BoringAvatarDecorationPainter extends BoxPainter {
  CustomPainter painter;

  _BoringAvatarDecorationPainter(this.painter, [super.onChanged]);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.translate(offset.dx, offset.dy);
    painter.paint(canvas, (configuration.size ?? Size.zero));
    canvas.translate(-offset.dx, -offset.dy);
  }
}
