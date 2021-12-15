// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import './utilities.dart';
import 'dart:ui';

const _ELEMENTS = 3;
const _SIZE = 80;

class _AvatarMarbleData {
  String color;
  int translateX;
  int translateY;
  int rotate;
  double scale;
  _AvatarMarbleData({
    required this.color,
    required this.translateX,
    required this.translateY,
    required this.rotate,
    required this.scale,
  });
}

List<_AvatarMarbleData> _generateColors(String name, List<String> colors) {
  final numFromName = getNumber(name);
  final range = colors.length;
  final elementsProperties = List.generate(
      _ELEMENTS,
      (i) => _AvatarMarbleData(
            color: getRandomColor(numFromName + i, colors, range),
            translateX: getUnit(numFromName * (i + 1), _SIZE ~/ 10, 1),
            translateY: getUnit(numFromName * (i + 1), _SIZE ~/ 10, 2),
            scale: 1.2 + getUnit(numFromName * (i + 1), _SIZE ~/ 20) / 10,
            rotate: getUnit(numFromName * (i + 1), 360, 1),
          ));
  return elementsProperties;
}

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(WIDTH, (WIDTH*1).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    // paint_0_fill.color = Colors.white.withOpacity(1.0);
    // canvas.drawRRect(
    //     RRect.fromRectAndCorners(Rect.fromLTWH(0, 0, size.width, size.height),
    //         bottomRight: Radius.circular(size.width * 2.000000),
    //         bottomLeft: Radius.circular(size.width * 2.000000),
    //         topLeft: Radius.circular(size.width * 2.000000),
    //         topRight: Radius.circular(size.width * 2.000000)),
    //     paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xffce1836).withOpacity(1.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(Rect.fromLTWH(0, 0, size.width, size.height),
            bottomRight: Radius.circular(size.width * 0.02500000),
            bottomLeft: Radius.circular(size.width * 0.02500000),
            topLeft: Radius.circular(size.width * 0.02500000),
            topRight: Radius.circular(size.width * 0.02500000)),
        paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.4051750, size.height * 0.7418750);
    path_2.lineTo(size.width * 0.6297000, size.height * 0.8812500);
    path_2.lineTo(size.width * 0.9062500, size.height * 0.8812500);
    path_2.lineTo(size.width * 0.9062500, size.height * -0.006250000);
    path_2.lineTo(size.width * 0.4216000, size.height * -0.006250000);
    path_2.lineTo(size.width * 0.3312500, size.height * 0.1672625);
    path_2.lineTo(size.width * 0.5694625, size.height * 0.5057625);
    path_2.lineTo(size.width * 0.4051750, size.height * 0.7418750);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff009989).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.2777000, size.height * 0.3000000);
    path_3.lineTo(0, size.height * 0.5843750);
    path_3.lineTo(size.width * 0.1763500, size.height * 1.060987);
    path_3.lineTo(size.width * 0.9750000, size.height * 1.075000);
    path_3.lineTo(size.width * 0.9364875, size.height * 0.3340500);
    path_3.lineTo(size.width * 0.6567625, size.height * 0.3841125);
    path_3.lineTo(size.width * 0.8189125, size.height * 0.6364375);
    path_3.lineTo(size.width * 0.5270375, size.height * 0.9788750);
    path_3.lineTo(size.width * 0.2776875, size.height * 0.3000000);
    path_3.close();
    path_3.transform(Matrix4.rotationZ( -24 * pi / 180).storage);

    Matrix4.identity()..rotateZ( -24 * pi / 180);

    // Matrix4.identity()..translate(Constants.elementCardHalfSize)..rotateY(initialRotateX)..translate(-Constants.elementCardHalfSize)

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffa3a948).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
