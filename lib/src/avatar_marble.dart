// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import './utilities.dart';
import 'dart:ui';

import 'path/path_parse.dart';
import 'path/svgpath.dart';

const _ELEMENTS = 3;
const _SIZE = 80;

class AvatarMarbleData {
  Color color;
  int translateX;
  int translateY;
  int rotate;
  double scale;
  AvatarMarbleData({
    required this.color,
    required this.translateX,
    required this.translateY,
    required this.rotate,
    required this.scale,
  });
}

List<AvatarMarbleData> generateAvatarMarbleData(String name, List<Color> colors) {
  final numFromName = getNumber(name);
  final range = colors.length;
  final elementsProperties = List.generate(
      _ELEMENTS,
      (i) => AvatarMarbleData(
            color: getRandomColor(numFromName + i, colors, range),
            translateX: getUnit(numFromName * (i + 1), _SIZE ~/ 10, 1),
            translateY: getUnit(numFromName * (i + 1), _SIZE ~/ 10, 2),
            scale: 1.2 + getUnit(numFromName * (i + 1), _SIZE ~/ 20) / 10,
            rotate: getUnit(numFromName * (i + 1), 360, 1),
          ));
  return elementsProperties;
}

class AvatarMarblePainter extends CustomPainter {

  final String name;
  final List<Color> colors;

  AvatarMarblePainter(this.name, this.colors) {
    
  };

  Size viewBox = const Size(80,80);
  Path svgPath(Canvas canvas, Size size, String p, {
    double rotate = 0, double scale = 1,
  }) {
    final scaleX =  size.width / viewBox.width;
    final scaleY =  size.height / viewBox.height;
    final resizeTransform = Matrix4.identity()..scale(scaleX, scaleY);
    final transform = Matrix4.identity()
    ..translate(40.0, 40.0)
    ..rotateZ( rotate * (pi/180))
    ..translate(-40.0, -40.0)
    ..scale(scale, scale);
    Path path = parseSvgPath(p);
    path = path.transform(transform.storage);
    path = path.transform(resizeTransform.storage);
    return path;
  }

 @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final blur = MaskFilter.blur(
      BlurStyle.normal, 7 * size.width / viewBox.width,
    );
    Paint paintFill = Paint()..style = PaintingStyle.fill;
    paintFill.color = Color(0xffce1836);
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paintFill);
    final path1 = svgPath(canvas, size, "M32.414 59.35L50.376 70.5H72.5v-71H33.728L26.5 13.381l19.057 27.08L32.414 59.35z", rotate: 136, scale: 1.2);
    Paint paintFill1 = Paint()..style = PaintingStyle.fill;
    paintFill1.color = Color(0xff009989).withOpacity(1.0);
    paintFill1.maskFilter = blur;
    canvas.drawPath(path1, paintFill1);
    final path2 = svgPath(canvas, size, "M22.216 24L0 46.75l14.108 38.129L78 86l-3.081-59.276-22.378 4.005 12.972 20.186-23.35 27.395L22.215 24z", rotate: -24, scale: 1.2);
    final paintFill2 = Paint()..style = PaintingStyle.fill;
    paintFill2.blendMode = BlendMode.overlay;
    paintFill2.color = Color(0xffa3a948).withOpacity(1.0);
    paintFill2.maskFilter = blur;
    canvas.drawPath(path2, paintFill2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
