import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

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
        width: 30,
        height: 30,
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

  @override
  Widget build(BuildContext context) {
    final Map<ShapeBorder, Widget> shapes = {
      const OvalBorder(): const Icon(Icons.circle_outlined),
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ): const Icon(Icons.rounded_corner),
      const Border(): const Icon(Icons.square_outlined),
      BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ): Padding(
        padding: const EdgeInsets.all(2),
        child: Material(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(width: 1),
          ),
          color: Colors.transparent,
          child: const SizedBox(
            width: 15,
            height: 15,
          ),
        ),
      ),
    };

    const spacing = 8.0;
    const padding = 8.0;
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    );
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
            Card(
              margin: EdgeInsets.zero,
              shape: cardShape,
              child: Padding(
                padding: const EdgeInsets.all(padding),
                // buttons
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 4,
                        ),
                      ),
                      onPressed: () {
                        onTypeChanged?.call(type);
                      },
                      label: Text(type.name.toUpperCase()),
                    );
                  }).toList(),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              shape: cardShape,
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(padding),
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    ...[0, 1, 2, 3, 4].expand((key) => [
                          colorButton(context, key),
                        ]),
                    Tooltip(
                      message: 'Randomize colors',
                      child: FilledButton.tonal(
                        child: const Icon(Icons.shuffle),
                        onPressed: () {
                          onPaletteChanged
                              ?.call(BoringAvatarPalette(getRandomColors()));
                        },
                      ),
                    ),
                    Tooltip(
                      message: 'Copy palette code',
                      child: FilledButton.tonal(
                        child: const Icon(Icons.copy),
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
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              shape: cardShape,
              child: Padding(
                padding: const EdgeInsets.all(padding),
                // buttons
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
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
                    return IconButton(
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
                        ));
                  }).toList(),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              shape: cardShape,
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(padding),
                child: Tooltip(
                  message: 'Randomize names',
                  child: FilledButton.tonal(
                    child: const Text("Randomize names"),
                    onPressed: () {
                      onRandomizeNames?.call();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
