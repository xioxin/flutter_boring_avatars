import 'package:flutter/cupertino.dart';

import 'painter.dart';
import 'color_palette.dart';

class DefaultBoringAvatarPalette extends InheritedWidget {
  const DefaultBoringAvatarPalette({
    super.key,
    required this.palette,
    required super.child,
  });

  final BoringAvatarPalette palette;

  static DefaultBoringAvatarPalette? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DefaultBoringAvatarPalette>();
  }

  static DefaultBoringAvatarPalette of(BuildContext context) {
    final DefaultBoringAvatarPalette? result = maybeOf(context);
    assert(result != null, 'No DefaultBoringAvatarPalette found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DefaultBoringAvatarPalette oldWidget) =>
      palette != oldWidget.palette;
}

class DefaultBoringAvatarType extends InheritedWidget {
  const DefaultBoringAvatarType({
    super.key,
    required this.type,
    required super.child,
  });

  final BoringAvatarType type;

  static DefaultBoringAvatarType? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DefaultBoringAvatarType>();
  }

  static DefaultBoringAvatarType of(BuildContext context) {
    final DefaultBoringAvatarType? result = maybeOf(context);
    assert(result != null, 'No DefaultBoringAvatarType found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DefaultBoringAvatarType oldWidget) =>
      type != oldWidget.type;
}
