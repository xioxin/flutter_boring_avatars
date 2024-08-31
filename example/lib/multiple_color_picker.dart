import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class MultipleColorPicker extends StatefulWidget {
  final List<Color> colors;
  final ValueChanged<List<Color>> onColorsChanged;

  const MultipleColorPicker({
    super.key,
    required this.colors,
    required this.onColorsChanged,
  });

  @override
  _MultipleColorPickerState createState() => _MultipleColorPickerState();
}

class _MultipleColorPickerState extends State<MultipleColorPicker> {
  late List<Color> colors;

  int index = 0;

  @override
  void initState() {
    super.initState();
    colors = widget.colors;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  for (int i = 0; i < colors.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            index = i;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: index == i ? 3 : 0,
                          backgroundColor: colors[i],
                          minimumSize: const Size(24, 24),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: SizedBox(
                          height: 32,
                          width: 32,
                          child: index == i
                              ? const Icon(TablerIcons.color_picker,
                                  color: Colors.white)
                              : null,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              ColorPicker(
                color: colors[index],
                colorCodeHasColor: true,
                colorCodeReadOnly: false,
                showColorCode: true,
                onColorChanged: (Color color) {
                  setState(() {
                    final newColor = List<Color>.from(colors);
                    newColor[index] = color;
                    colors = newColor;
                    widget.onColorsChanged(newColor);
                  });
                },
                pickersEnabled: const <ColorPickerType, bool>{
                  ColorPickerType.wheel: true,
                  ColorPickerType.both: true,
                  ColorPickerType.primary: false,
                  ColorPickerType.accent: false,
                  ColorPickerType.bw: false,
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
            ],
          ),
        ),
      ),
    );
  }
}
