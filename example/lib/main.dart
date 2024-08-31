import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_boring_avatars_example/control_bar.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class AvatarInputWidget extends StatefulWidget {
  const AvatarInputWidget({
    Key? key,
    required this.name,
    required this.onNameChanged,
    required this.resetInput,
    required this.shape,
  }) : super(key: key);

  final String name;
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

  copyImage() async {
    final type = DefaultBoringAvatarType.maybeOf(context)?.type ??
        BoringAvatarType.marble;
    final colorPalette =
        DefaultBoringAvatarPalette.maybeOf(context)?.palette ??
            BoringAvatarPalette.defaultPalette;

    final image = await BoringAvatarData.generate(
      name: widget.name,
      type: type,
      palette: colorPalette,
      // shape: widget.shape,
    ).toImage(
      size: const Size.square(512),
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
  }

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
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOutCubicEmphasized,
            name: widget.name,
            shape: widget.shape,
            child: RawMaterialButton(
              shape: widget.shape,
              onPressed: copyImage,
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
              tooltip: 'Pub.dev',
              onPressed: () async {
                final uri = Uri.parse(
                    'https://pub.dev/packages/flutter_boring_avatars');
                if (!await launchUrl(uri, webOnlyWindowName: '_blank')) {
                  throw Exception('Could not launch $uri');
                }
              },
              icon: const Icon(TablerIcons.brand_flutter),
            ),
            IconButton(
              tooltip: 'Github',
              onPressed: () async {
                final uri = Uri.parse(
                    'https://github.com/xioxin/flutter_boring_avatars');
                if (!await launchUrl(uri, webOnlyWindowName: '_blank')) {
                  throw Exception('Could not launch $uri');
                }
              },
              icon: const Icon(TablerIcons.brand_github),
            ),
            IconButton(
              tooltip: 'Randomize All',
              onPressed: () {
                setState(() {
                  names =
                      List.generate(2000, (index) => randomNames.fullName());
                  colorPalette = BoringAvatarPalette(getRandomColors());
                });
              },
              icon: const Icon(TablerIcons.refresh),
            ),
          ],
        ),
        body: Stack(
          children: [
            DefaultBoringAvatarStyle(
              type: type,
              palette: colorPalette,
              child: Positioned.fill(
                child: GridView.builder(
                  padding: const EdgeInsets.only(
                      left: 32, top: 140, right: 32, bottom: 32),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 140,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return avatarItem(index);
                  },
                ),
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
