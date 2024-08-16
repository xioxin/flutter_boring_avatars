import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

  @override
  void initState() {
    super.initState();
  }

  List<Color> colors = const [
    Color(0xffA3A948),
    Color(0xffEDB92E),
    Color(0xffF85931),
    Color(0xffCE1836),
    Color(0xff009989)
  ];

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

  @override
  Widget build(BuildContext context) {
    final palette = BoringAvatarPalette(colors);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Boring Avatars'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String? v) {
                          setState(() {
                            name = v ?? '';
                          });
                        },
                      ),
                  ),
                  SegmentedButton<BoringAvatarType>(
                    segments: BoringAvatarType.values
                        .map((v) => ButtonSegment(
                            value: v,
                            icon: BoringAvatar(
                              name: v.name,
                              type: v,
                            ),
                            label: Text(v.name)))
                        .toList(),
                    selected: {type},
                    onSelectionChanged: (v) {
                      setState(() {
                        type = v.first;
                      });
                    },
                  ),
                  ...colors.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ElevatedButton(
                            onPressed: () {
                              selectColor(e.key);
                            },
                            child: Container(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: e.value,
                                minimumSize: const Size(50, 50))),
                      ))
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Center(
                  child: Center(
                    child: GridView.count(
                      padding: const EdgeInsets.all(16),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                      crossAxisCount: BoringAvatarType.values.length,
                      children: [
                        BoringAvatar(
                          name: name,
                          palette: palette,
                          type: type,
                        ),
                        AnimatedBoringAvatar(
                          duration: const Duration(milliseconds: 800),
                          name: name,
                          curve: Curves.easeInOutCubicEmphasized,
                          palette: palette,
                          type: type,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
