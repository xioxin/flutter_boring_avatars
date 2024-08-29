import 'dart:ui';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_boring_avatars_example/control_bar.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:super_clipboard/super_clipboard.dart';

import 'colors.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  String name = 'Bessie Coleman';
  TextEditingController textController = TextEditingController.fromValue(
      const TextEditingValue(text: 'Bessie Coleman'));

  BoringAvatarType type = BoringAvatarType.beam;

  RandomNames randomNames = RandomNames(Zone.us);

  late BoringAvatarPalette colorPalette;
  late List<String> names;

  ShapeBorder shape = const OvalBorder();

  @override
  void initState() {
    colorPalette = BoringAvatarPalette(getRandomColors());
    names = List.generate(200, (index) => randomNames.fullName());
    super.initState();
  }

  avatarItem(int index) {
    final name = names[index];
    return AvatarInputWidget(
        name: name,
        resetInput: names.hashCode,
        colorPalette: colorPalette,
        type: type,
        shape: shape,
        onNameChanged: (name) {
          setState(() {
            names[index] = name;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        ColorScheme.fromSeed(seedColor: colorPalette.getColor(2));
    return MaterialApp(
      theme: ThemeData.from(colorScheme: colorScheme),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Boring Avatars'),
          actions: [
            IconButton(
              tooltip: 'Randomize All',
              onPressed: () {
                setState(() {
                  names =
                      List.generate(2000, (index) => randomNames.fullName());
                  colorPalette = BoringAvatarPalette(getRandomColors());
                });
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: GridView.builder(
                padding: const EdgeInsets.only(
                    left: 32, top: 220, right: 32, bottom: 32),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return avatarItem(index);
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 16,
              right: 16,
              child: ControlBarWidget(
                type: type,
                palette: colorPalette,
                shape: shape,
                onShapeChanged: (v) {
                  setState(() {
                    shape = v;
                  });
                },
                onTypeChanged: (v) {
                  setState(() {
                    type = v;
                  });
                },
                onPaletteChanged: (v) {
                  setState(() {
                    colorPalette = v;
                  });
                },
                onRandomizeNames: () {
                  setState(() {
                    names =
                        List.generate(2000, (index) => randomNames.fullName());
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarInputWidget extends StatefulWidget {
  const AvatarInputWidget({
    Key? key,
    required this.name,
    required this.colorPalette,
    required this.type,
    required this.onNameChanged,
    required this.resetInput,
    required this.shape,
  }) : super(key: key);

  final String name;
  final BoringAvatarPalette colorPalette;
  final BoringAvatarType type;
  final ValueChanged<String> onNameChanged;
  final int resetInput;
  final ShapeBorder shape;

  @override
  State<AvatarInputWidget> createState() => _AvatarInputWidgetState();
}

class _AvatarInputWidgetState extends State<AvatarInputWidget> {
  late TextEditingController textController = TextEditingController(
    text: widget.name,
  );

  late int inputKey = widget.resetInput;

  @override
  Widget build(BuildContext context) {
    if (widget.resetInput != inputKey) {
      textController = TextEditingController(
        text: widget.name,
      );
      inputKey = widget.resetInput;
    }
    return Column(
      children: [
        Expanded(
          child: AnimatedBoringAvatar(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutCubicEmphasized,
            name: widget.name,
            palette: widget.colorPalette,
            type: widget.type,
            shape: widget.shape,
            child: RawMaterialButton(
              onPressed: () async {
                final image = await BoringAvatarData.generate(
                  name: widget.name,
                  type: widget.type,
                  palette: widget.colorPalette,
                ).toImage(
                  size: const Size.square(256),
                );

                final pngData =
                    await image.toByteData(format: ImageByteFormat.png);
                final clipboard = SystemClipboard.instance;
                if (clipboard == null) {
                  return; // Clipboard API is not supported on this platform.
                }
                final item = DataWriterItem();
                item.add(Formats.png(pngData!.buffer.asUint8List()));
                await clipboard.write([item]);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Avatar image copied to clipboard'),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 24,
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(32)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.0), width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(32)),
              ),
            ),
            controller: textController,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            onChanged: widget.onNameChanged,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
