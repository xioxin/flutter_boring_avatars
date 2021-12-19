import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boring_avatars/src/avatar_bauhaus.dart';

import 'avatar_beam.dart';
import 'avatar_marble.dart';
import 'avatar_pixel.dart';
import 'avatar_ring.dart';
import 'avatar_sunset.dart';
import 'utilities.dart';

enum BoringAvatarsType {
  marble,
  beam,
  pixel,
  sunset,
  bauhaus,
  ring,
}

BoringAvatarsType defaultBoringAvatarsType = BoringAvatarsType.marble;

class BoringAvatars extends StatelessWidget {
  static setDefaultColors(List<Color> colors) {
    defaultBoringAvatarsColors = colors;
  }
  static setDefaultType(BoringAvatarsType type) {
    defaultBoringAvatarsType = type;
  }

  final BoringAvatarsType? type;
  final String name;
  final List<Color>? colors;
  final bool square;

  const BoringAvatars({Key? key, required this.name, this.type, this.colors, this.square = false}): super(key: key);

  getPainter() {
    final type = this.type ?? defaultBoringAvatarsType;
    switch (type) {
      case BoringAvatarsType.bauhaus:
        return AvatarBauhausPainter(name, colors);
      case BoringAvatarsType.marble:
        return AvatarMarblePainter(name, colors);
      case BoringAvatarsType.beam:
        return AvatarBeamPainter(name, colors);
      case BoringAvatarsType.pixel:
        return AvatarPixelPainter(name, colors);
      case BoringAvatarsType.ring:
        return AvatarRingPainter(name, colors);
      case BoringAvatarsType.sunset:
        return AvatarSunsetPainter(name, colors);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: getPainter(),
        );
      }),
    );
    if(square) return avatar;
    return ClipOval(child: avatar);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoringAvatarsType?>('type', type, defaultValue: defaultBoringAvatarsType));
    properties.add(DiagnosticsProperty<String>('name', name));
    properties.add(DiagnosticsProperty<List<Color>?>('colors', colors, defaultValue: defaultBoringAvatarsColors));
    properties.add(DiagnosticsProperty<bool>('square', square));
  }
}

class AnimatedBoringAvatars extends StatelessWidget {
  static setDefaultColors(List<Color> colors) {
    defaultBoringAvatarsColors = colors;
  }
  static setDefaultType(BoringAvatarsType type) {
    defaultBoringAvatarsType = type;
  }

  final BoringAvatarsType? type;
  final String name;
  final List<Color>? colors;

  final Curve curve;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool square;

  const AnimatedBoringAvatars({Key? key,
    required this.duration,
    required this.name,
    this.type,
    this.colors,
    this.curve = Curves.linear,
    this.onEnd,
    this.square = false,
  }): super(key: key);

  getWidget(Size size) {
    final type = this.type ?? defaultBoringAvatarsType;
    switch (type) {
      case BoringAvatarsType.bauhaus:
        return AnimatedAvatarBauhaus(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
      case BoringAvatarsType.marble:
        return AnimatedAvatarMarble(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
      case BoringAvatarsType.beam:
        return AnimatedAvatarBeam(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
      case BoringAvatarsType.pixel:
        return AnimatedAvatarPixel(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
      case BoringAvatarsType.ring:
        return AnimatedAvatarRing(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
      case BoringAvatarsType.sunset:
        return AnimatedAvatarSunset(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
    }
  }

  @override
  Widget build(BuildContext context) {

    final avatar = AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final type = this.type ?? defaultBoringAvatarsType;
          switch (type) {
            case BoringAvatarsType.bauhaus:
              return AnimatedAvatarBauhaus(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
            case BoringAvatarsType.marble:
              return AnimatedAvatarMarble(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
            case BoringAvatarsType.beam:
              return AnimatedAvatarBeam(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
            case BoringAvatarsType.pixel:
              return AnimatedAvatarPixel(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
            case BoringAvatarsType.ring:
              return AnimatedAvatarRing(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
            case BoringAvatarsType.sunset:
              return AnimatedAvatarSunset(name: name, colors: colors, size: size, onEnd: onEnd, curve: curve, duration: duration);
          }
        })
    );
    if(square) return avatar;
    return ClipOval(child: avatar);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoringAvatarsType?>('type', type, defaultValue: defaultBoringAvatarsType));
    properties.add(DiagnosticsProperty<String>('name', name));
    properties.add(DiagnosticsProperty<List<Color>?>('colors', colors, defaultValue: defaultBoringAvatarsColors));
    properties.add(DiagnosticsProperty<bool>('square', square));
    properties.add(DiagnosticsProperty<Curve>('curve', curve));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
    properties.add(DiagnosticsProperty<VoidCallback?>('onEnd', onEnd));
  }
}

