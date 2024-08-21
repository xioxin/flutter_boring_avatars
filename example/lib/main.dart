import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:random_name_generator/random_name_generator.dart';

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

  late List<String> names;

  @override
  void initState() {
    colors = getRandomColors().toList();
    names = List.generate(200, (index) => randomNames.fullName());
    super.initState();
  }

  late List<Color> colors;

  Widget controlBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // buttons
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 12)),
                    onPressed: () {
                      setState(() {
                        this.type = type;
                      });
                    },
                    label: Text(type.name),
                  );
                }).toList(),
              ),

              // child: SegmentedButton<BoringAvatarType>(
              //   showSelectedIcon: false,
              //   segments: BoringAvatarType.values
              //       .map(
              //         (type) => ButtonSegment(
              //           value: type,
              //           tooltip: type.name,
              //           icon: SizedBox(
              //             width: 24,
              //             child: BoringAvatar(
              //               name: type.name,
              //               type: type,
              //               shape: const OvalBorder(),
              //             ),
              //           ),
              //           label: Text(type.name, maxLines: 1),
              //         ),
              //       )
              //       .toList(),
              //   style:
              //       SegmentedButton.styleFrom(
              //           padding: const EdgeInsets.all(2)
              //
              //       ),
              //   selected: {type},
              //   onSelectionChanged: (v) {
              //     setState(() {
              //       type = v.first;
              //     });
              //   },
              // ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...[0, 1, 2, 3, 4].expand((key) => [
                        colorButton(key),
                        const SizedBox(width: 8),
                      ]),
                  FilledButton.tonal(
                    child: Icon(Icons.shuffle),
                    onPressed: () {
                      setState(() {
                        colors = getRandomColors();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    child: Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text:
                              "const BoringAvatarPalette([${colors.map((e) => "Color(0x${e.value.toRadixString(16)})").join(", ")}])"));
                    },
                  )
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                child: const Text("Random Names"),
                onPressed: () {
                  setState(() {
                    names =
                        List.generate(200, (index) => randomNames.fullName());
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  colorButton(int index) {
    return FilledButton(
      onPressed: () {
        selectColor(index);
      },
      child: const SizedBox(
        width: 32,
        height: 32,
      ),
      style: FilledButton.styleFrom(
        backgroundColor: colors[index],
        padding: const EdgeInsets.all(0),
        minimumSize: Size.zero,
      ),
    );
  }

  selectColor(int index) {
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: colors[index],
              onColorChanged: (color) {
                setState(() {
                  colors[index] = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      context: context,
    );
  }

  avatar(int index) {
    final name = names[index];
    return Column(
      children: [
        Expanded(
          child: AnimatedBoringAvatar(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutCubicEmphasized,
            name: name,
            palette: BoringAvatarPalette(colors),
            type: type,
            shape: const OvalBorder(),
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
            controller: TextEditingController.fromValue(
              TextEditingValue(text: name),
            ),
            style: TextStyle(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            onChanged: (v) {
              setState(() {
                names[index] = v;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: colors.first);
    return MaterialApp(
      theme: ThemeData.from(colorScheme: colorScheme),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Boring Avatars'),
        ),
        body: Column(
          children: [
            Builder(builder: (context) {
              return controlBar(context);
            }),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(32),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return avatar(index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
