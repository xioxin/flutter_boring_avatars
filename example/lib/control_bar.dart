import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_boring_avatars_example/multiple_color_picker.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'colors.dart';

class ControlBarWidget extends StatelessWidget {
  final BoringAvatarType type;
  final ValueChanged<BoringAvatarType>? onTypeChanged;
  final BoringAvatarPalette palette;
  final ValueChanged<BoringAvatarPalette>? onPaletteChanged;
  final VoidCallback? onRandomizeNames;

  final ShapeBorder shape;
  final ValueChanged<ShapeBorder>? onShapeChanged;

  const ControlBarWidget({
    super.key,
    required this.type,
    required this.palette,
    required this.shape,
    this.onTypeChanged,
    this.onPaletteChanged,
    this.onRandomizeNames,
    this.onShapeChanged,
  });

  colorButton(BuildContext context, int index) {
    return FilledButton(
      onPressed: () {
        selectColor(context, index);
      },
      child: const SizedBox(
        width: 32,
        height: 32,
      ),
      style: FilledButton.styleFrom(
        backgroundColor: palette.getColor(index),
        padding: const EdgeInsets.all(0),
        minimumSize: Size.zero,
      ),
    );
  }

  selectColor(BuildContext context, int index) {
    showDialog(
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: ColorPicker(
                color: palette.getColor(index),
                colorCodeHasColor: true,
                colorCodeReadOnly: false,
                showColorCode: true,
                onColorChanged: (Color color) {
                  final newPalette = palette.copyWithOne(index, color);
                  onPaletteChanged?.call(newPalette);
                },
                pickersEnabled: const <ColorPickerType, bool>{
                  ColorPickerType.wheel: true,
                  ColorPickerType.both: true,
                  ColorPickerType.primary: false,
                  ColorPickerType.accent: false,
                  ColorPickerType.bw: false,
                  // ColorPickerType.custom: true,
                },
                opacityTrackWidth: 200,
                opacityTrackHeight: 24,
                width: 44,
                height: 44,
                borderRadius: 22,
                heading: Text(
                  'Select color',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                subheading: Text(
                  'Select color shade',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                opacitySubheading: Text(
                  'Select opacity level',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }

  selectMultipleColors(BuildContext context) {
    showDialog(
      builder: (context) {
        return MultipleColorPicker(
            colors: palette.colors,
            onColorsChanged: (colors) {
              onPaletteChanged?.call(BoringAvatarPalette(colors));
            });
      },
      context: context,
    );
  }

  Widget cardBox({required Widget child, isMini = false}) {
    return SizedBox(
      height: 32 + (isMini ? 8 : 16),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(padding: EdgeInsets.all(isMini ? 4 : 8), child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<ShapeBorder, Widget> shapes = {
      const OvalBorder(): const Icon(TablerIcons.circle),
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ): const Icon(TablerIcons.square_rounded),
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ): const Icon(TablerIcons.square),
      // BeveledRectangleBorder(
      //   borderRadius: BorderRadius.circular(24),
      // ): const Icon(TablerIcons.octagon),
    };

    double spacing = 8.0;
    final isMini = MediaQuery.sizeOf(context).width < 700;
    if (isMini) {
      spacing = 4.0;
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
              Theme.of(context).colorScheme.surface.withOpacity(0),
            ]),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 16,
          left: 8,
          right: 8,
        ),
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.center,
          children: [
            if (isMini)
              CardWrap(
                spacing: spacing,
                children: [
                  DropdownButton<BoringAvatarType>(
                    borderRadius: BorderRadius.circular(24),
                    padding: const EdgeInsets.all(4),
                    onChanged: (value) {
                      if (value != null) {
                        onTypeChanged?.call(value);
                      }
                    },
                    value: type,
                    isDense: true,
                    underline: const SizedBox.shrink(),
                    items: BoringAvatarType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: BoringAvatar(
                                name: type.name,
                                type: type,
                                shape: const OvalBorder(),
                              ),
                            ),
                            SizedBox(width: spacing),
                            Text(type.name.toUpperCase()),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            if (!isMini)
              CardWrap(
                spacing: spacing,
                children: BoringAvatarType.values.map((type) {
                  final isSelected = this.type == type;
                  final colorScheme = Theme.of(context).colorScheme;
                  var backgroundColor = colorScheme.surfaceContainerLow;
                  var foregroundColor = colorScheme.onSurface;
                  if (isSelected) {
                    backgroundColor = colorScheme.secondaryContainer;
                    foregroundColor = colorScheme.primary;
                  }
                  return FilledButton.icon(
                    icon: SizedBox(
                      width: 24,
                      height: 24,
                      child: BoringAvatar(
                        name: type.name,
                        type: type,
                        shape: const OvalBorder(),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      elevation: 0,
                      backgroundColor: backgroundColor,
                      foregroundColor: foregroundColor,
                      padding: EdgeInsets.only(
                        left: spacing / 2,
                        right: spacing,
                        top: spacing / 2,
                        bottom: spacing / 2,
                      ),
                    ),
                    onPressed: () {
                      onTypeChanged?.call(type);
                    },
                    label: Text(type.name.toUpperCase()),
                  );
                }).toList(),
              ),
            CardWrap(
              spacing: spacing,
              children: [
                if (!isMini)
                  for (var i = 0; i < 5; i++) colorButton(context, i),
                if (isMini)
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: FilledButton(
                      onPressed: () {
                        selectMultipleColors(context);
                      },
                      clipBehavior: Clip.antiAlias,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        minimumSize: Size.zero,
                      ),
                      child: Row(
                        children: [
                          for (var i = 0; i < 5; i++)
                            Flexible(
                              flex: 1,
                              child: Container(
                                color: palette.getColor(i),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  width: isMini ? 32 : null,
                  height: 32,
                  child: FilledButton.tonal(
                    child: const Icon(TablerIcons.arrows_shuffle),
                    style: isMini
                        ? FilledButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size.square(40),
                          )
                        : null,
                    onPressed: () {
                      onPaletteChanged
                          ?.call(BoringAvatarPalette(getRandomColors()));
                    },
                  ),
                ),
                SizedBox(
                  width: isMini ? 32 : null,
                  height: 32,
                  child: FilledButton.tonal(
                    child: const Icon(TablerIcons.copy),
                    style: isMini
                        ? FilledButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size.square(40),
                          )
                        : null,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text:
                              "const BoringAvatarPalette([${palette.colors.map((e) => "Color(0x${e.value.toRadixString(16)})").join(", ")}])"));
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Palette code copied to clipboard'),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            CardWrap(
              spacing: spacing,
              children: shapes.entries.map((entry) {
                final value = entry.key;
                final icon = entry.value;
                final isSelected = shape == value;
                final colorScheme = Theme.of(context).colorScheme;
                var backgroundColor = colorScheme.surfaceContainerLow;
                var foregroundColor = colorScheme.onSurface;
                if (isSelected) {
                  backgroundColor = colorScheme.secondaryContainer;
                  foregroundColor = colorScheme.primary;
                }
                return SizedBox(
                  height: 32,
                  width: 32,
                  child: IconButton(
                      onPressed: () {
                        onShapeChanged?.call(value);
                      },
                      icon: icon,
                      style: IconButton.styleFrom(
                        iconSize: 20,
                        padding: const EdgeInsets.all(6),
                        minimumSize: Size.zero,
                        backgroundColor: backgroundColor,
                        foregroundColor: foregroundColor,
                      )),
                );
              }).toList(),
            ),
            CardWrap(
              spacing: spacing,
              children: [
                SizedBox(
                  height: 32,
                  child: FilledButton.tonal(
                    child: const Text("Randomize Names"),
                    onPressed: () {
                      onRandomizeNames?.call();
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardWrap extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const CardWrap({super.key, required this.children, this.spacing = 8.0});

  @override
  Widget build(BuildContext context) {
    final height = 32 + spacing * 2;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: SizedBox(
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: children,
              alignment: WrapAlignment.center,
            ),
          ),
        ),
      ),
    );
  }
}
