import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

void main() {
  runApp(const MyApp());
}

const defaultColors = [
  Color(0xffA3A948),
  Color(0xffEDB92E),
  Color(0xffF85931),
  Color(0xffCE1836),
  Color(0xff009989)
];

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  String name = 'Amelia Earhart';
  TextEditingController textController = TextEditingController.fromValue(const TextEditingValue(text: 'Amelia Earhart'));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: AvatarMarblePainter(name, defaultColors),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: AvatarBeamPainter(name, defaultColors),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: AvatarPixelPainter(name, defaultColors),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: AvatarSunsetPainter(name, defaultColors),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: AvatarBauhausPainter(name, defaultColors),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    size: const Size(100, 100),
                    painter: AvatarRingPainter(name, defaultColors),
                  ),
                ),
                
              ],
            ),
            SizedBox(height: 16,),
             Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: AnimatedAvatarMarble(duration: const Duration(milliseconds: 350), name: name),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: AnimatedAvatarBeam(duration: const Duration(milliseconds: 350), name: name),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: AnimatedAvatarPixel(duration: const Duration(milliseconds: 350), name: name),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: AnimatedAvatarSunset(duration: const Duration(milliseconds: 350), name: name),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: AnimatedAvatarBauhaus(duration: const Duration(milliseconds: 350), name: name),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: AnimatedAvatarRing(duration: const Duration(milliseconds: 350), name: name),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
