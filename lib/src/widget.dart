import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boring_avatars/src/color_palette.dart';
import 'painter.dart';
import 'inherited.dart';

//
// BoringAvatarsType defaultBoringAvatarsType = BoringAvatarsType.marble;
//
// class BoringAvatars extends StatelessWidget {
//   static setDefaultColors(List<Color> colors) {
//     defaultBoringAvatarsColors = colors;
//   }
//
//   static setDefaultType(BoringAvatarsType type) {
//     defaultBoringAvatarsType = type;
//   }
//
//   final BoringAvatarsType? type;
//   final String name;
//   final List<Color>? colors;
//   final bool square;
//
//   const BoringAvatars(
//       {Key? key,
//       required this.name,
//       this.type,
//       this.colors,
//       this.square = false})
//       : super(key: key);
//
//   getPainter() {
//     final type = this.type ?? defaultBoringAvatarsType;
//     switch (type) {
//       case BoringAvatarsType.bauhaus:
//         return AvatarBauhausPainter(name, colors);
//       case BoringAvatarsType.marble:
//         return AvatarMarblePainter(name, colors);
//       case BoringAvatarsType.beam:
//         return AvatarBeamPainter(name, colors);
//       case BoringAvatarsType.pixel:
//         return AvatarPixelPainter(name, colors);
//       case BoringAvatarsType.ring:
//         return AvatarRingPainter(name, colors);
//       case BoringAvatarsType.sunset:
//         return AvatarSunsetPainter(name, colors);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final avatar = AspectRatio(
//       aspectRatio: 1,
//       child: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints constraints) {
//         return CustomPaint(
//           size: Size(constraints.maxWidth, constraints.maxHeight),
//           painter: getPainter(),
//         );
//       }),
//     );
//     if (square) return avatar;
//     return ClipOval(child: avatar);
//   }
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<BoringAvatarsType?>('type', type,
//         defaultValue: defaultBoringAvatarsType));
//     properties.add(DiagnosticsProperty<String>('name', name));
//     properties.add(DiagnosticsProperty<List<Color>?>('colors', colors,
//         defaultValue: defaultBoringAvatarsColors));
//     properties.add(DiagnosticsProperty<bool>('square', square));
//   }
// }
//
// class AnimatedBoringAvatars extends StatelessWidget {
//   static setDefaultColors(List<Color> colors) {
//     defaultBoringAvatarsColors = colors;
//   }
//
//   static setDefaultType(BoringAvatarsType type) {
//     defaultBoringAvatarsType = type;
//   }
//
//   final BoringAvatarsType? type;
//   final String name;
//   final List<Color>? colors;
//
//   final Curve curve;
//   final Duration duration;
//   final VoidCallback? onEnd;
//   final bool square;
//
//   const AnimatedBoringAvatars({
//     Key? key,
//     required this.duration,
//     required this.name,
//     this.type,
//     this.colors,
//     this.curve = Curves.linear,
//     this.onEnd,
//     this.square = false,
//   }) : super(key: key);
//
//   getWidget(Size size) {
//     final type = this.type ?? defaultBoringAvatarsType;
//     switch (type) {
//       case BoringAvatarsType.bauhaus:
//         return AnimatedAvatarBauhaus(
//             name: name,
//             colors: colors,
//             size: size,
//             onEnd: onEnd,
//             curve: curve,
//             duration: duration);
//       case BoringAvatarsType.marble:
//         return AnimatedAvatarMarble(
//             name: name,
//             colors: colors,
//             size: size,
//             onEnd: onEnd,
//             curve: curve,
//             duration: duration);
//       case BoringAvatarsType.beam:
//         return AnimatedAvatarBeam(
//             name: name,
//             colors: colors,
//             size: size,
//             onEnd: onEnd,
//             curve: curve,
//             duration: duration);
//       case BoringAvatarsType.pixel:
//         return AnimatedAvatarPixel(
//             name: name,
//             colors: colors,
//             size: size,
//             onEnd: onEnd,
//             curve: curve,
//             duration: duration);
//       case BoringAvatarsType.ring:
//         return AnimatedAvatarRing(
//             name: name,
//             colors: colors,
//             size: size,
//             onEnd: onEnd,
//             curve: curve,
//             duration: duration);
//       case BoringAvatarsType.sunset:
//         return AnimatedAvatarSunset(
//             name: name,
//             colors: colors,
//             size: size,
//             onEnd: onEnd,
//             curve: curve,
//             duration: duration);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final avatar = AspectRatio(
//         aspectRatio: 1,
//         child: LayoutBuilder(
//             builder: (BuildContext context, BoxConstraints constraints) {
//           final size = Size(constraints.maxWidth, constraints.maxHeight);
//           final type = this.type ?? defaultBoringAvatarsType;
//           switch (type) {
//             case BoringAvatarsType.bauhaus:
//               return AnimatedAvatarBauhaus(
//                   name: name,
//                   colors: colors,
//                   size: size,
//                   onEnd: onEnd,
//                   curve: curve,
//                   duration: duration);
//             case BoringAvatarsType.marble:
//               return AnimatedAvatarMarble(
//                   name: name,
//                   colors: colors,
//                   size: size,
//                   onEnd: onEnd,
//                   curve: curve,
//                   duration: duration);
//             case BoringAvatarsType.beam:
//               return AnimatedAvatarBeam(
//                   name: name,
//                   colors: colors,
//                   size: size,
//                   onEnd: onEnd,
//                   curve: curve,
//                   duration: duration);
//             case BoringAvatarsType.pixel:
//               return AnimatedAvatarPixel(
//                   name: name,
//                   colors: colors,
//                   size: size,
//                   onEnd: onEnd,
//                   curve: curve,
//                   duration: duration);
//             case BoringAvatarsType.ring:
//               return AnimatedAvatarRing(
//                   name: name,
//                   colors: colors,
//                   size: size,
//                   onEnd: onEnd,
//                   curve: curve,
//                   duration: duration);
//             case BoringAvatarsType.sunset:
//               return AnimatedAvatarSunset(
//                   name: name,
//                   colors: colors,
//                   size: size,
//                   onEnd: onEnd,
//                   curve: curve,
//                   duration: duration);
//           }
//         }));
//     if (square) return avatar;
//     return ClipOval(child: avatar);
//   }
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<BoringAvatarsType?>('type', type,
//         defaultValue: defaultBoringAvatarsType));
//     properties.add(DiagnosticsProperty<String>('name', name));
//     properties.add(DiagnosticsProperty<List<Color>?>('colors', colors,
//         defaultValue: defaultBoringAvatarsColors));
//     properties.add(DiagnosticsProperty<bool>('square', square));
//     properties.add(DiagnosticsProperty<Curve>('curve', curve));
//     properties.add(DiagnosticsProperty<Duration>('duration', duration));
//     properties.add(DiagnosticsProperty<VoidCallback?>('onEnd', onEnd));
//   }
// }
//

class BoringAvatarCanvas extends StatelessWidget {
  final BoringAvatarData avatarData;

  const BoringAvatarCanvas({super.key, required this.avatarData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        size: Size.infinite,
        painter: avatarData.painter,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<BoringAvatarData?>('avatarData', avatarData));
  }
}

@immutable
class BoringAvatar extends StatelessWidget {
  final String name;
  final BoringAvatarType? type;
  final BoringAvatarPalette? palette;

  const BoringAvatar({super.key, required this.name, this.type, this.palette});

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
    return BoringAvatarCanvas(
      avatarData: avatarData,
    );
  }
}

class AnimatedBoringCanvas extends ImplicitlyAnimatedWidget {
  final BoringAvatarData avatarData;

  const AnimatedBoringCanvas({
    super.key,
    required this.avatarData,
    required super.duration,
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

class AnimatedBoringAvatar extends StatelessWidget {
  final String name;
  final BoringAvatarType? type;
  final BoringAvatarPalette? palette;

  final Duration duration;
  final VoidCallback? onEnd;
  final Curve curve;

  const AnimatedBoringAvatar({
    super.key,
    required this.name,
    required this.duration,
    this.curve = Curves.linear,
    this.onEnd,
    this.type,
    this.palette,
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
    return AnimatedBoringCanvas(
      avatarData: avatarData,
      onEnd: onEnd,
      curve: curve,
      duration: duration,
    );
  }
}

class BoringAvatarDecoration extends Decoration {
  final BoringAvatarData avatarData;

  const BoringAvatarDecoration({
    required this.avatarData,
  });

  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) {
    return BoringAvatarDecorationPainter(painter: avatarData.painter);
  }
}

class BoringAvatarDecorationPainter extends BoxPainter {
  CustomPainter painter;

  BoringAvatarDecorationPainter({required this.painter});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    painter.paint(canvas, (configuration.size ?? Size.zero));
  }
}

// todo: animation Decoration
